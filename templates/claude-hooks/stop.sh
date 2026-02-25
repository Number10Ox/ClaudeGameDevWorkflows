#!/bin/bash
# Announces when Claude finishes a response via macOS TTS.
# Triggered by Claude Code's Stop lifecycle event.
# Useful when Claude is working on a long task and you've walked away.

say "Done." &
