#!/bin/bash
# Announces when Claude needs your attention via macOS TTS.
# Triggered by Claude Code's Notification lifecycle event.
# Fires when Claude is waiting for input (permission prompts, questions, etc.)

say "Claude needs your attention." &
