#!/bin/bash
set -e

# Ensure mounted volumes are owned by node
sudo chown node:node "$HOME/.claude" "$HOME/.gemini" "$HOME/.openclaw" 2>/dev/null || true

exec "$@"
