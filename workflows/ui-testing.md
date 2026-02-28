# UI Testing Workflow

Automated testing that verifies UI implementation matches the screen spec. Claude writes the tests; the human reviews failures and approves visual baselines.

---

## The Testing Pyramid

Three layers, each driven by the screen spec. Lower layers are cheaper, faster, and more specific. Higher layers catch broader issues but cost more to maintain.

### Layer 1 — Structural Assertions

**What:** Verify the screen spec's layout tree and elements table against the actual rendered output. Fast, deterministic, no screenshots needed.

**Derived from:**
- **Layout tree** → assert elements exist in the correct hierarchy
- **Elements table** → assert each element has correct type, content, and conditional visibility
- **Size hints** → assert dimensions match spec constraints (min width, fixed height, etc.)
- **States** → assert correct rendering in each specified state (Loading, Empty, Error, Populated)

**Examples:**
```
// From layout tree: sidebar exists and contains fleet-list
expect(screen.querySelector('.sidebar .fleet-list')).toBeTruthy()

// From elements table: status-bar shows ship count pattern
expect(statusBar.textContent).toMatch(/\d+ ships/)

// From elements table: Deploy disabled when no ships
expect(deployButton.disabled).toBe(true)

// From size hints: sidebar is 280px
expect(sidebar.offsetWidth).toBe(280)
```

**Characteristics:** Runs in seconds. Catches most "nope, that's wrong" issues. Breaks immediately when structure drifts from spec.

### Layer 2 — Functional Flow Tests

**What:** Drive multi-step interactions and verify outcomes. BDD-style scenarios that test behavior, not just structure.

**Derived from:**
- **Elements table → Interaction column** → each interaction becomes a test scenario
- **Navigation** → entry and exit paths become flow tests
- **States** → transitions between states become flow tests

**Examples:**
```
// From elements table: "Click selects fleet, populates main panel"
test('selecting a fleet populates the main panel', async () => {
  await page.click('[data-fleet-id="1"]')
  await expect(page.locator('.ship-grid .ship-card')).toHaveCount(3)
})

// From navigation: "Deploy button → Destination Picker (modal)"
test('deploy opens destination picker', async () => {
  await page.click('[data-action="deploy"]')
  await expect(page.locator('.destination-picker-modal')).toBeVisible()
})
```

**Characteristics:** Slower (needs headless browser). Catches interaction bugs and broken flows. Tests what the player *does*, not just what they *see*.

### Layer 3 — Visual Regression

**What:** Capture screenshots at key states, diff against approved baselines. Catches layout drift, styling regressions, visual weight shifts.

**Derived from:**
- **States** → one baseline screenshot per specified state
- **Style Notes** → the subjective "feel" that structural tests can't catch

**Characteristics:** Most brittle — baselines need updating when design intentionally changes. Highest fidelity for catching "it looks wrong." Human approves initial baselines and reviews diffs on intentional changes.

---

## Spec-to-Test Mapping

Each section of the screen spec drives specific test layers:

| Spec Section | Layer 1 (Structural) | Layer 2 (Flows) | Layer 3 (Visual) |
|-------------|---------------------|-----------------|-------------------|
| Layout | Element hierarchy, nesting, spatial rules | — | Screenshot baselines |
| Elements | Existence, type, content, conditional states | Interaction scenarios | — |
| Data | Data binding assertions | — | — |
| States | Per-state rendering assertions | State transition tests | Per-state baselines |
| Navigation | — | Entry/exit flow tests | — |
| Style Notes | — | — | Baseline mood check |

---

## When Tests Get Written

Tests are part of implementation, not an afterthought.

| Phase | What happens |
|-------|-------------|
| **Spec written** | Screen spec is the contract. No tests yet. |
| **Implementation starts** | Claude writes Layer 1 tests alongside (or immediately after) building each element. Structural tests act as a self-check during implementation. |
| **Implementation complete** | Claude writes Layer 2 flow tests for all interactions in the elements table. |
| **Verification** | Claude runs all tests. Layer 3 baselines are captured if visual regression is set up. Human reviews baselines. |
| **Later changes** | When the spec changes, Claude updates tests to match the new spec *before* changing the implementation. Tests break first, then get fixed by the implementation change. |

---

## Who Does What

| Task | Claude | Human |
|------|--------|-------|
| Write Layer 1 tests from spec | Yes | Review if desired |
| Write Layer 2 tests from spec | Yes | Review if desired |
| Run all tests | Yes | Triggered by Claude or CI |
| Capture Layer 3 baselines | Yes (runs the capture) | Approves the baselines |
| Update tests when spec changes | Yes | Reviews the diff |
| Diagnose test failures | Yes (proposes fix) | Decides: fix code or update spec |
| Update visual baselines after intentional change | Yes (captures new) | Approves new baselines |

---

## LLM Mock Requirement

**No automated test at any layer may call a real LLM API.**

Games using LLM-driven agents (NPC behavior, narrative generation, etc.) must ensure all automated tests run against mock/canned responses, never live API calls.

- **Layer 1** — typically no issue; structural tests use pure functions and static data with no LLM dependency.
- **Layers 2 & 3** — Playwright tests run against a live server. If the server calls an LLM during normal operation, it must support a mock mode:
  - The server accepts a startup flag or environment variable (e.g., `USE_MOCK_LLM=true`) to swap the real LLM client for a mock that returns canned/deterministic responses
  - Mock implementation lives in a test fixture (e.g., `tests/fixtures/mockLlmClient.ts`)
  - Canned responses must match the real output shape so flow tests exercise actual parsing paths
  - If a new test scenario needs a response shape not yet in the fixtures, add it to the fixture file — never call the real API
- **Rationale:** LLM calls are slow, non-deterministic, and cost money. Tests that depend on live LLM output are flaky by definition and cannot run in CI without API keys.

---

## Handling Test Failures

When a test fails, the question is: **did the code drift from the spec, or did the spec change?**

- **Code drifted from spec** → fix the code. The spec is authoritative.
- **Spec changed intentionally** → update the spec first, then update the tests, then update the code. Spec leads.
- **Test is wrong** (spec was misread when generating the test) → fix the test. Flag to human if uncertain.

---

## Stack Profiles

The process above is stack-agnostic. The tooling is not. Each project declares which tools it uses for each layer.

### Web (Vanilla JS + DOM)

| Layer | Tooling |
|-------|---------|
| Structural | Vitest + jsdom, or Playwright locators |
| Flows | Playwright |
| Visual | Playwright screenshots + diff library |

### Web (Vanilla JS + Canvas)

| Layer | Tooling |
|-------|---------|
| Structural | Canvas state inspection (engine-level assertions on what was drawn) |
| Flows | Playwright (interactions still go through DOM events) |
| Visual | Playwright screenshots (primary verification for canvas content) |

### Web (React)

| Layer | Tooling |
|-------|---------|
| Structural | React Testing Library |
| Flows | Playwright or RTL + user-event |
| Visual | Playwright screenshots |

### Web (React Three Fiber / Three.js / WebGL)

| Layer | Tooling |
|-------|---------|
| Structural | Limited — jsdom can't render WebGL. Assert component props, data flow, and scene graph structure via React Testing Library, but these can't catch visual/material bugs |
| Flows | Playwright with `--use-gl=angle` or `--use-gl=swiftshader` flag for WebGL support. Interactions go through DOM events (orbit controls, clicks on overlays) |
| Visual | Playwright screenshots (primary verification — most 3D bugs are only visible in screenshots). Use `--use-gl=angle` for GPU-accelerated rendering that matches real browsers |

**Note:** WebGL/3D testing has a unique gap — structural tests (jsdom) can't see rendering at all, and flow tests require a real browser with GL support. Visual regression via Playwright screenshots is the most valuable layer for 3D projects. Prioritize it over structural tests for rendering code.

**Playwright WebGL setup:**
```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    launchOptions: {
      args: ['--use-gl=angle'], // or '--use-gl=swiftshader' for CI without GPU
    },
  },
});
```

### Unity

| Layer | Tooling |
|-------|---------|
| Structural | Unity Test Framework + scene queries (GameObject.Find, component assertions) |
| Flows | Unity Test Framework + simulated input |
| Visual | `ScreenCapture.CaptureScreenshotAsTexture()` in play mode tests, or custom editor screenshot script for batch mode. Compare against baseline PNGs with tolerance threshold |

> **Adapt this:** Add profiles as needed. The pyramid and spec-to-test mapping stay the same. Only the tooling changes.

---

## Project Configuration

Each project declares its testing profile in CLAUDE.md or a project-level test config:

```markdown
## UI Testing
- **Stack profile**: Web (Vanilla JS + DOM) with Canvas tiles
- **Layer 1**: Vitest + jsdom for DOM elements; engine-state assertions for canvas
- **Layer 2**: Playwright
- **Layer 3**: Playwright screenshots (baselines in tests/baselines/)
```

This tells Claude which tools to reach for when generating tests from a screen spec.

---

> **Adapt this:** Not every project needs all three layers from day one. Layer 1 alone catches most structural issues and is cheap. Add Layer 2 when interactions get complex. Add Layer 3 when visual consistency matters and you have time to maintain baselines.
