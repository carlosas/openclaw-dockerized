.PHONY: start stop enter

start:
	docker compose up -d --build

stop:
	docker compose stop

enter:
	docker compose exec openclaw-gateway zsh
