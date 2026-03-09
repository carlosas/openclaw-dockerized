.PHONY: install reinstall start stop enter logs

install:
	docker compose build

reinstall:
	docker compose build --no-cache

start:
	docker compose up -d

stop:
	docker compose stop

enter:
	docker compose exec openclaw zsh

logs:
	docker compose logs -f
