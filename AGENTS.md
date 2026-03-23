# CLAUDE.md

This file provides guidance to AI Assistants when working with code in this repository.

## Project Overview

Dockerized deployment of OpenClaw gateway with pre-installed AI CLI tools (Claude Code, Gemini CLI). Single-container setup running on Node.js 22 with zsh shell.

## Commands

```bash
make help         # Show all available commands
make install      # Build Docker image
make reinstall    # Rebuild without cache
make start        # Start container (detached)
make stop         # Stop container
make down         # Stop and remove container
make restart      # Restart container
make enter        # Open zsh shell inside running container
make logs         # Tail container logs
make status       # Show OpenClaw status
make doctor       # Run openclaw doctor
make clean        # Clean unused Docker resources
make purge        # Delete everything (containers, images, volumes, local data)
```

Gateway runs at http://127.0.0.1:8888 (maps to container port 8080).

## Architecture

This is a pure infrastructure/deployment project — no application source code. Everything is defined in five files:

- **Dockerfile** — Node.js 22 base, installs system deps (git, python3, zsh, sudo), pnpm (via Corepack), global npm packages (openclaw, @google/gemini-cli), Claude Code CLI, and configures oh-my-zsh for the `node` user
- **entrypoint.sh** — Fixes ownership of host-mounted volumes before starting the gateway
- **docker-compose.yml** — Single `openclaw` service with three host-mounted volumes for persistent config (`./openclaw/`, `./gemini/`, `./claude/`), localhost-only port binding, and env vars from `.env`
- **Makefile** — Thin wrapper; loads `.env` for `PROJECT_NAME` and uses `docker exec` with the container name (`openclaw-<PROJECT_NAME>`) for exec-based commands
- **.env.dist** — Template for `.env` (TZ, OPENCLAW_GATEWAY_MODE, ROOT_PASSWORD, PROJECT_NAME)

The container runs as non-root user `node` (with passwordless sudo) via `entrypoint.sh`, which delegates to `openclaw gateway run --allow-unconfigured`. Configuration directories are mounted from the host so they persist across rebuilds.

## Key Details

- Port binding is restricted to `127.0.0.1` — not exposed externally
- `.env` file (copied from `.env.dist`) is gitignored along with the `openclaw/`, `gemini/`, and `claude/` config directories
- Claude Code is installed via `curl -fsSL https://claude.ai/install.sh | sh` (not npm)
- pnpm is enabled via Corepack (not `npm install -g pnpm`)
- The `node` user has passwordless sudo for volume ownership fixes in `entrypoint.sh`
- The gateway starts with `--allow-unconfigured` so no pre-configuration is needed
- After first start, run `openclaw onboard --install-daemon` inside the container to complete setup
