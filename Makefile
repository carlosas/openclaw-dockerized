-include .env
export

PROJECT_NAME ?= my-project

.PHONY: install reinstall start stop down restart logs status enter doctor clean purge help

help:
	@echo "Available commands:"
	@echo "  make install   - Build the Docker image"
	@echo "  make reinstall - Rebuild the Docker image (no cache)"
	@echo "  make start     - Start the container (detached)"
	@echo "  make stop      - Stop the container"
	@echo "  make down      - Stop and remove the container"
	@echo "  make restart   - Restart the container"
	@echo "  make logs      - Tail container logs"
	@echo "  make status    - Show OpenClaw status"
	@echo "  make enter     - Open zsh shell inside the container"
	@echo "  make doctor    - Run openclaw doctor"
	@echo "  make clean     - Clean unused Docker resources"
	@echo "  make purge     - DELETE everything (containers, images, volumes, local data)"

install:
	mkdir -p ./openclaw
	docker compose build

reinstall:
	docker compose build --no-cache

start:
	docker compose up -d

stop:
	docker compose stop

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

status:
	docker exec -it openclaw-$(PROJECT_NAME) openclaw status

enter:
	docker exec -it openclaw-$(PROJECT_NAME) zsh

doctor:
	docker exec -it openclaw-$(PROJECT_NAME) openclaw doctor

clean:
	docker system prune -f

purge:
	@echo "WARNING: This will delete containers, images, volumes, and the './openclaw' directory."
	@read -p "Are you sure? [y/N] " confirm; \
	if [ "$$confirm" != "y" ] && [ "$$confirm" != "Y" ]; then \
		echo "Cancelled."; \
		exit 1; \
	fi
	docker compose down -v --rmi all --remove-orphans
	rm -rf ./openclaw
