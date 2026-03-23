# CLAUDE.md

This file provides guidance to AI Assistants when working with code in this repository.

## Project Overview

Dockerized deployment of OpenClaw gateway with pre-installed AI CLI tools (Claude Code, Gemini CLI). Single-container setup running on Node.js 22 with zsh shell.

## Commands

```bash
make install      # Build Docker image
make reinstall    # Rebuild without cache
make start        # Start container (detached)
make stop         # Stop container
make enter        # Open zsh shell inside running container
make logs         # Tail container logs
```

Gateway runs at http://127.0.0.1:8888 (maps to container port 8080).

## Architecture

This is a pure infrastructure/deployment project — no application source code. Everything is defined in four files:

- **Dockerfile** — Node.js 22 base, installs system deps (git, python3, zsh), global npm packages (openclaw, @google/gemini-cli), Claude Code CLI, and configures oh-my-zsh for the `node` user
- **docker-compose.yml** — Single `openclaw` service with three host-mounted volumes for persistent config (`./openclaw/`, `./gemini/`, `./claude/`), localhost-only port binding, and env vars from `.env`
- **Makefile** — Thin wrapper around `docker compose` commands
- **.env.dist** — Template for `.env` (TZ, OPENCLAW_GATEWAY_MODE, ROOT_PASSWORD, PROJECT_NAME)

The container runs as non-root user `node` with entrypoint `openclaw gateway run`. Configuration directories are mounted from the host so they persist across rebuilds.

## Key Details

- Port binding is restricted to `127.0.0.1` — not exposed externally
- `.env` file (copied from `.env.dist`) is gitignored along with the `openclaw/`, `gemini/`, and `claude/` config directories
- Claude Code is installed via `curl -fsSL https://claude.ai/install.sh | sh` (not npm)
- After first start, run `openclaw onboard --install-daemon` inside the container to complete setup
