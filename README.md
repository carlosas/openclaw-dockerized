# OpenClaw-Dockerized 🦞+🐳

Containerized [OpenClaw](https://github.com/openclaw) gateway with Claude Code and Gemini CLI pre-installed.

## What's included

- **Node.js 22** (Debian Bookworm)
- **OpenClaw** - AI coding gateway
- **Claude Code** - Anthropic CLI
- **Gemini CLI** - Google CLI
- **pnpm** - Fast package manager (via Corepack)
- **zsh** with oh-my-zsh and syntax highlighting

## Quick start

```bash
# Create your environment file from the template
cp .env.dist .env

# Build the image
make install

# Start the gateway
make start

# Enter the container
make enter

# Configure OpenClaw (inside the container)
openclaw onboard --install-daemon
```

Run `make help` to see all available commands.


## Configuration

### Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TZ` | `Europe/Madrid` | Container timezone |
| `OPENCLAW_GATEWAY_MODE` | `local` | Gateway operation mode |
| `ROOT_PASSWORD` | `root` | Root password inside the container |
| `PROJECT_NAME` | `my-project` | Used in container name (`openclaw-<project-name>`) and shell prompt |

### Volumes

| Host path | Container path | Purpose |
|-----------|---------------|---------|
| `./openclaw/` | `/home/node/.openclaw` | OpenClaw configuration and data |
| `./gemini/` | `/home/node/.gemini` | Gemini CLI configuration |
| `./claude/` | `/home/node/.claude` | Claude Code configuration |

## Ports

| Host | Container | Description |
|------|-----------|-------------|
| 8888 | 8080 | OpenClaw gateway (localhost only) |

The gateway runs in local mode and is accessible at [http://127.0.0.1:8888](http://127.0.0.1:8888) or via TUI inside the container.
