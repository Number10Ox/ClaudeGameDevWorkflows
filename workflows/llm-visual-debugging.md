# LLM-Assisted Visual Debugging

> Workflow: how LLMs can debug UI issues through screenshots, geometry inspection, logging, and automated testing.
> Stack context: React + Vite + TypeScript + Playwright

---

## The Problem

LLMs are blind to runtime behavior **unless we explicitly capture runtime artifacts**. When a component renders at the wrong offset or a panel clips its content, the LLM sees only source code — not the actual pixels. Today we debug visually by:

1. Developer takes a screenshot manually
2. Pastes it into the conversation
3. LLM guesses from the image + code

This is slow, error-prone, and breaks the autonomous debugging loop. We need the LLM to **capture its own evidence, analyze it, and iterate.**

---

## 1. Screenshot Capture (Playwright)

Playwright gives us programmatic eyes. Key APIs:

### Page & Element Screenshots
```typescript
// Full viewport
await page.screenshot({ path: '/tmp/viewport.png' });

// Specific element
const canvas = page.locator('[data-testid="main-canvas"]');
await canvas.screenshot({ path: '/tmp/canvas.png' });

// Full scrollable page
await page.screenshot({ path: '/tmp/full.png', fullPage: true });

// Clip to region
await page.screenshot({
  path: '/tmp/region.png',
  clip: { x: 100, y: 200, width: 400, height: 300 }
});
```

### Wait for Ready State

"Loaded" is not the same as "visually ready." Screenshot after the UI's readiness signals, not just after navigation.

```typescript
await page.goto('/dashboard');
await page.waitForLoadState('networkidle');
await page.locator('[data-testid="main-canvas"]').waitFor({ state: 'visible' });
await expect(page.locator('[data-testid="main-canvas"]')).toBeVisible();
```

Every app has its own "ready" signals. Common ones:
- Data fetched and rendered (not just loading spinner gone)
- Fonts loaded (custom web fonts affect layout)
- Images / SVG assets fully loaded
- Animations completed or disabled
- Dynamic content populated

### Deterministic State for Screenshots
```typescript
// Freeze time
await page.clock.setFixedTime(new Date('2026-01-01T12:00:00Z'));

// Mock API responses for consistent data
await page.route('**/api/data', route => {
  route.fulfill({ json: { score: 42, level: 7 } });
});

// Disable animations (CSS transitions, JS animations)
await page.screenshot({ animations: 'disabled' });

// Mask dynamic elements (timestamps, random IDs)
await page.screenshot({
  mask: [page.locator('.timestamp'), page.locator('.session-id')]
});
```

### Viewport Control = Camera Control
```typescript
// Set viewport (our "camera position")
await page.setViewportSize({ width: 1280, height: 720 });

// Scroll to element
await page.locator('.target-section').scrollIntoViewIfNeeded();

// Device emulation
import { devices } from '@playwright/test';
const context = await browser.newContext({
  ...devices['iPhone 13'],
  colorScheme: 'dark'
});
```

---

## 2. Determinism Checklist

Before trusting any screenshot diff, first prove the page is deterministic. Most false regressions come from unstable test state, not real UI changes.

Pre-flight checklist for every visual test:

- [ ] Fixed viewport size and device scale factor
- [ ] Fixed color scheme (dark/light)
- [ ] Mocked network responses (no live API calls)
- [ ] Seeded randomness (procedural generation, etc.)
- [ ] Fixed time/date (`page.clock.setFixedTime()`)
- [ ] Animations disabled
- [ ] Fonts loaded before capture (`document.fonts.ready`)
- [ ] Images/SVG assets loaded before capture
- [ ] No live timestamps, rotating IDs, or dynamic avatars
- [ ] Feature flags / experiments disabled or pinned

If a test is flaky, check this list before investigating the component.

---

## 3. Visual Comparison (Pixel Diff)

### Playwright Built-in
```typescript
// Baseline comparison — first run creates golden image, later runs diff
await expect(page).toHaveScreenshot('dashboard.png', {
  maxDiffPixelRatio: 0.01,  // Allow 1% pixel difference
  animations: 'disabled',
  threshold: 0.2             // Per-pixel color tolerance (anti-aliasing)
});

// Element-level comparison
await expect(page.locator('.editor-panel')).toHaveScreenshot('editor.png');

// Update baselines when design changes
// npx playwright test --update-snapshots
```

### When Pixel Diff Falls Short

Pixel diff catches **any** change but produces false positives from:
- Anti-aliasing differences across platforms
- Font rendering variations
- Dynamic content (timestamps, avatars)
- Animation timing

This is where LLM vision adds value — semantic comparison.

### Golden Screenshot Discipline

Golden images are design contracts. Treat updates like API changes, not routine cleanup.

- Keep baselines **small and component-focused** — avoid giant full-page goldens unless necessary
- Update snapshots **intentionally**, never casually
- Include rationale in the commit message when updating goldens after design changes
- Review snapshot diffs in PRs the same way you review code diffs

---

## 4. Geometry & Computed Style Inspection

Screenshots show symptoms. Geometry inspection shows coordinates, dimensions, transforms, and clipping facts. For layout bugs, this is often the fastest route to a real diagnosis.

### DOM Geometry
```typescript
// Bounding box (viewport-relative)
const box = await page.locator('[data-testid="main-canvas"]').boundingBox();
// → { x: 120, y: 80, width: 500, height: 700 }

// Computed styles and rect from inside the page
const metrics = await page.locator('.target-element').evaluate(el => {
  const rect = el.getBoundingClientRect();
  const style = window.getComputedStyle(el);
  return {
    x: rect.x,
    y: rect.y,
    width: rect.width,
    height: rect.height,
    transform: style.transform,
    opacity: style.opacity,
    overflow: style.overflow,
    zIndex: style.zIndex,
    clipPath: style.clipPath,
  };
});
```

### SVG-Specific Geometry

Many "visual" SVG bugs are actually coordinate-space bugs: wrong viewBox, wrong transform origin, inherited scale, or mismatch between logical positions and rendered bounding boxes.

```typescript
// SVG bounding box (in SVG coordinate space, not viewport)
const svgMetrics = await page.locator('#svg-element').evaluate(el => {
  const svgEl = el as unknown as SVGGraphicsElement;
  const bbox = svgEl.getBBox();
  const ctm = svgEl.getCTM();
  return {
    bbox: { x: bbox.x, y: bbox.y, width: bbox.width, height: bbox.height },
    ctm: ctm ? {
      a: ctm.a, b: ctm.b, c: ctm.c, d: ctm.d, e: ctm.e, f: ctm.f
    } : null
  };
});
```

SVG debugging checklist:
- **viewBox** — does it encompass the actual path coordinates?
- **transform chains** — are parent `<g>` transforms composing correctly?
- **coordinate-space confusion** — SVG units vs. viewport pixels vs. CSS pixels
- **preserveAspectRatio** — is `none` vs `xMidYMid` causing unexpected scaling?
- **stroke scaling** — `vector-effect: non-scaling-stroke` vs. scaled strokes
- **clipPath / mask interactions** — clipping in unexpected coordinate spaces
- **pointer-events** — invisible hit regions from `fill: none` without `pointer-events: stroke`

### The Three-Layer Evidence Model

```
Layer 1: Geometry / computed style facts (fast, precise, numerical)
  → Answers: WHERE is it? HOW BIG is it? WHAT transforms apply?

Layer 2: Pixel diff (fast, cheap, catches everything visual)
  → Answers: WHAT changed? WHERE on screen?

Layer 3: LLM vision (selective, semantic)
  → Answers: IS this a regression? WHAT does it mean? HOW to fix it?
```

Use geometry first for layout bugs. Use pixel diff for regression detection. Use LLM vision for classification and explanation.

---

## 5. LLM Vision Analysis

### What Vision Models Can Detect

**Good at (semantic):**
- Layout issues: misalignment, overflow, truncation, spacing inconsistency
- Missing/broken elements: absent buttons, broken images, missing states
- Color problems: wrong palette, insufficient contrast
- Design system violations: "this card doesn't match the established style"
- Hierarchy issues: headings smaller than body text
- Responsive problems: elements that overflow viewport
- Clipping / occlusion: elements hidden behind others
- Layering / z-index errors: wrong stacking order
- Inconsistent icon sizing or weight

**Not source of truth for:**
- Exact pixel measurements ("is this 16px or 17px?")
- Sub-pixel differences
- Precise color hex values from screenshots
- Animation/transition bugs (static image)
- Performance issues (render timing)
- Accessibility tree state

For precision questions, use geometry inspection (Layer 1). For semantic questions, use vision.

### Prompting for Visual Analysis

**Structured checklist prompt (reduces hallucination):**
```
Analyze this screenshot of [component name]:

1. Layout: alignment, spacing, overflow
2. Colors: match design system? (list your design system colors here)
3. Typography: consistent sizes, weights, readability
4. Missing elements: expected buttons, labels, icons
5. Visual effects: backdrop-blur, shadows, borders correct

Rate each: OK / MINOR / MAJOR / CRITICAL
```

**Before/after comparison:**
```
Image 1: Expected (baseline)
Image 2: Current build

List specific differences. For each:
- Location on screen
- What changed
- Is this a regression or intentional?
```

**Component-focused (more accurate than full-page):**
- Isolate the component, screenshot just that element
- Provide design system reference in the prompt
- Ask **one specific question** at a time, not "find all issues"
- Give expected behavior: "the icon should be centered within the button"
- Give explicit pass/fail criteria: "the tooltip should not extend beyond the viewport"

**Hallucination guard:** Ask the model to distinguish between **observed evidence** and **inference**. Vision is best used to classify and explain, not to invent hidden causes. If the model says "the transform is wrong," ask it to show the evidence — the screenshot alone can't prove that.

---

## 6. Failure Taxonomy

Different bugs need different evidence. Reaching for screenshots first is not always the right move.

| Bug Type | Start With | Then |
|----------|-----------|------|
| Misalignment / wrong offset | Bounding boxes + geometry | Screenshot for visual confirmation |
| Overflow / clipping / z-index | Computed styles (`overflow`, `clipPath`, `zIndex`) | Screenshot |
| Wrong palette / visual hierarchy | Screenshot + design-system prompt | — |
| Missing element | DOM existence check (`locator.count()`) | Screenshot if element should be visible |
| Animation jank / flicker | Video capture / trace / repeated screenshots | Not single-frame vision |
| Performance regression | Profiler / trace / timings | Not screenshots |
| SVG coordinate bug | `getBBox()` + transform matrices | Screenshot for visual confirmation |
| Responsive breakage | Screenshots at multiple viewports | Geometry at breakpoints |

This helps the LLM (or the developer) choose the right diagnostic tool instead of defaulting to "take a screenshot and stare at it."

---

## 7. Logging for LLM Consumption

### Structured Logging (JSON, not console.log)
```typescript
// Bad: console.log('rendered', component.id, 'at', Date.now());
// Good:
logger.info('component_render', {
  component: 'EditorCanvas',
  entityId: entity.id,
  childCount: children.length,
  renderCount: renderCountRef.current,
  duration: performance.now() - startTime
});
```

Key metadata for React apps:
- **Component path**: `Editor > Canvas > Entity`
- **Render trigger**: prop change, state update, context change
- **State diff**: what changed from last render
- **Performance**: render duration, hook execution time

### Correlation IDs

Every screenshot, log bundle, and action sequence should be tied together so artifacts can be matched after the fact.

```typescript
const runContext = {
  runId: crypto.randomUUID(),
  route: '/editor',
  variant: 'preset-A',
  viewport: { width: 1280, height: 720 },
  seed: 42,
  timestamp: Date.now(),
  scenarioId: 'layout-alignment-check'
};

// Attach to screenshots
await page.screenshot({
  path: `test-results/${runContext.scenarioId}-${runContext.variant}.png`
});

// Attach to logs
logger.info('scenario_start', runContext);
```

Without correlation, log bundles get hard to align with screenshots across runs.

### Capturing Console in Playwright
```typescript
test('debug component rendering', async ({ page }) => {
  const logs: any[] = [];
  page.on('console', msg => {
    logs.push({
      type: msg.type(),
      text: msg.text(),
      location: msg.location()
    });
  });

  await page.goto('/editor');

  // After interaction, dump logs for analysis
  const errors = logs.filter(l => l.type === 'error');
  const warnings = logs.filter(l => l.type === 'warning');
  // Save to file for LLM analysis
});
```

### Interaction State Capture

Many bugs only manifest in a specific interaction state. Capture a state matrix:

```typescript
const states = ['default', 'hover', 'focus-visible', 'active', 'disabled', 'loading', 'error', 'empty'];

// Screenshot each state
for (const state of states) {
  await setupState(page, state); // app-specific setup
  await page.screenshot({ path: `test-results/button-${state}.png` });
}

// Accessibility tree snapshot
const snapshot = await page.accessibility.snapshot();
```

Also capture:
- ARIA attributes and accessibility tree for screen reader state
- Keyboard navigation (tab order, focus ring visibility)
- Dark/light mode, reduced motion, high contrast variants

### React-Specific: Why-Did-You-Render
```typescript
function useWhyDidYouUpdate(name: string, props: Record<string, any>) {
  const prev = useRef(props);
  useEffect(() => {
    if (prev.current) {
      const changes: Record<string, { from: any; to: any }> = {};
      for (const key of Object.keys(props)) {
        if (prev.current[key] !== props[key]) {
          changes[key] = { from: prev.current[key], to: props[key] };
        }
      }
      if (Object.keys(changes).length > 0) {
        console.log(`[rerender] ${name}:`, changes);
      }
    }
    prev.current = props;
  });
}
```

### React Profiler API
```typescript
<Profiler id="MyComponent" onRender={(id, phase, actualDuration) => {
  if (actualDuration > 16) { // > 60fps budget
    logger.warn('slow_render', { component: id, phase, ms: actualDuration });
  }
}}>
  <MyComponent />
</Profiler>
```

---

## 8. LLM Self-Debugging Loop

The most powerful pattern: LLM writes diagnostic code, runs it, analyzes results, iterates.

### The Loop
```
1. Developer describes bug: "icon is offset from its container"
2. LLM writes Playwright test:
   - Navigate to the page
   - Select the relevant variant/state
   - Wait for ready state
   - Screenshot the target component
   - Get bounding boxes of child elements
   - Log computed positions + transforms
3. Test runs → captures screenshot + geometry data + logs
4. LLM reads screenshot + geometry + logs:
   "Icon bbox is at y=40 but container center is at y=80.
    The icon's transform is shifting it 40px too high."
5. LLM proposes fix: adjust positioning or transform
6. Verify with another screenshot + geometry check
```

### Trace Viewer: Time-Travel Debugging

Playwright's Trace Viewer provides a richer artifact than any single screenshot. It captures DOM snapshots, user actions, console output, network requests, and screenshots at each step — a complete replay of the test.

```typescript
// Enable tracing
const context = await browser.newContext();
await context.tracing.start({ screenshots: true, snapshots: true, sources: true });

// ... run test actions ...

// Save trace
await context.tracing.stop({ path: 'test-results/trace.zip' });
// View: npx playwright show-trace test-results/trace.zip
```

For debugging, a trace is often more useful than a final screenshot because it shows the sequence of events that led to the bug, not just the end state.

### What the LLM Can Write and Run
- **Playwright tests** that navigate, interact, screenshot
- **Node scripts** that analyze JSON data files
- **SVG analysis scripts** that compute bounding boxes and transforms
- **Diff scripts** that compare before/after states

### Example: Automated Layout Check
```typescript
test('components align correctly', async ({ page }) => {
  await page.goto('/editor');
  await page.waitForLoadState('networkidle');

  for (const variant of ['variant-a', 'variant-b', 'variant-c']) {
    await page.locator(`button:has-text("${variant}")`).click();
    await page.locator('[data-testid="main-canvas"]').waitFor({ state: 'visible' });

    const canvas = page.locator('[data-testid="main-canvas"]');

    // Capture screenshot
    await canvas.screenshot({
      path: `test-results/layout-${variant}.png`
    });

    // Capture geometry
    const geometry = await canvas.evaluate(el => {
      const children = el.querySelectorAll('[data-component]');
      return Array.from(children).map(c => {
        const rect = c.getBoundingClientRect();
        return {
          id: c.getAttribute('data-component'),
          x: rect.x, y: rect.y,
          width: rect.width, height: rect.height
        };
      });
    });

    console.log(`[geometry] ${variant}:`, JSON.stringify(geometry, null, 2));
  }
});
```

Then feed screenshots + geometry data to Claude Code via `Read` tool for analysis.

---

## 9. Debugging Artifact Bundle

Every autonomous visual-debugging run should output a small, structured bundle — not just a screenshot.

```
test-results/
  layout-check/
    meta.json              # run ID, route, variant, viewport, seed, timestamp
    variant-a.png          # screenshot
    variant-a-geometry.json # bounding boxes, transforms, computed styles
    console.log            # captured console output
    network.json           # intercepted/mocked responses
    trace.zip              # optional Playwright trace
```

This gives the LLM a complete evidence packet. A screenshot alone is often insufficient — the geometry dump may reveal the bug faster, and the console log may show the root cause.

```typescript
// Helper to save a complete artifact bundle
async function captureBundle(page: Page, name: string, meta: Record<string, any>) {
  const dir = `test-results/${meta.scenarioId}`;
  await fs.mkdir(dir, { recursive: true });

  await fs.writeFile(`${dir}/meta.json`, JSON.stringify(meta, null, 2));

  await page.locator('[data-testid="main-canvas"]').screenshot({
    path: `${dir}/${name}.png`
  });

  const geometry = await page.evaluate(() => { /* ... collect geometry ... */ });
  await fs.writeFile(`${dir}/${name}-geometry.json`, JSON.stringify(geometry, null, 2));
}
```

---

## 10. Error Boundaries + State Snapshots

### Enhanced Error Boundary
```typescript
class DebugErrorBoundary extends React.Component {
  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    const context = {
      error: { message: error.message, stack: error.stack },
      componentStack: errorInfo.componentStack,
      url: window.location.href,
      recentLogs: window.__logBuffer?.slice(-50),
      timestamp: Date.now()
    };
    // Write to file or send to backend for LLM analysis
    console.error('[ErrorBoundary]', JSON.stringify(context));
  }
}
```

### State Snapshot for Debugging
```typescript
// Dev-only: dump current app state for LLM analysis
function useStateSnapshot(name: string) {
  useEffect(() => {
    (window as any).__snapshot = () => ({
      component: name,
      timestamp: Date.now(),
      state: /* serialize current state */,
      props: /* serialize current props */
    });
  });
}
```

Keep snapshots **small and scenario-specific**. Dumping the entire app state tree produces noise that obscures the signal. Serialize only the component subtree relevant to the bug.

---

## 11. Adoption Roadmap

A phased approach for adding LLM visual debugging to an existing React project:

**Phase 1: Playwright + Screenshot Capture**
- Add Playwright config
- Write tests that navigate to key routes and screenshot
- Include wait-for-ready-state logic for each page
- Save screenshots to `test-results/` for manual LLM analysis via `Read` tool
- This alone solves the "take a screenshot and show it to the LLM" problem

**Phase 2: Visual Regression Baselines**
- `toHaveScreenshot()` for key components and pages
- Golden images committed to repo (component-focused, not full-page)
- CI catches visual regressions automatically

**Phase 3: Geometry + Structured Logging**
- Add structured logger (Pino or custom)
- Instrument key components
- Add geometry capture helpers for SVG components
- Capture console in Playwright tests
- Save artifact bundles (screenshot + geometry + logs + metadata)

**Phase 4: Self-Debugging Scripts**
- Write Playwright helpers: "screenshot this component at these 5 viewport sizes"
- Write SVG analysis helpers: "compute actual bounding box of rendered element"
- Write state-matrix helpers: "capture this component in all interaction states"
- LLM can use these as building blocks for ad-hoc debugging

**Phase 5: LLM-in-the-Loop CI**
- On PR, capture screenshots of changed components
- Feed diffs to Claude API with design system prompt
- Post analysis as PR comment
- Flag regressions for human review

**CI caution:** Start advisory-only. LLM-in-the-loop CI should flag, not block. Early runs will produce noise as baselines stabilize and prompts get tuned. Graduate to blocking only after the signal-to-noise ratio proves itself.

---

## Tools Referenced

| Tool | Purpose |
|------|---------|
| Playwright | Browser automation, screenshots, visual regression |
| `page.screenshot()` | Capture viewport/element/full-page images |
| `toHaveScreenshot()` | Pixel-diff visual regression |
| Playwright Trace Viewer | Step-by-step replay with DOM snapshots, actions, console, network |
| `boundingBox()` / `evaluate()` | DOM geometry and computed style inspection |
| `getBBox()` / `getCTM()` | SVG coordinate-space inspection |
| Claude Code `Read` tool | LLM reads PNG/JPG screenshots for analysis |
| Pino / custom logger | Structured JSON logging for LLM parsing |
| React Profiler | Render performance measurement |
| `@playwright/experimental-ct-react` | Isolated React component testing |
| Applitools / Percy / Chromatic | Cloud visual regression services |

---

## Key Insight

The gap isn't capability — it's **plumbing**. Claude can already analyze screenshots (via Read tool) and write diagnostic code (via Bash/Write). What's missing is the automated pipeline that:

1. Captures screenshots **and geometry** without human intervention
2. Bundles evidence (screenshot + geometry + logs + metadata) in a structured way
3. Lets the LLM iterate (capture → analyze → fix → re-capture)

Playwright is that plumbing. Adding it unlocks the full self-debugging loop.
