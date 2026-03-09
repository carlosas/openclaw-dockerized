.PHONY: start stop enter logs

start:
	docker compose up -d --build

stop:
	docker compose stop

enter:
	docker compose exec openclaw zsh

logs:
	docker compose logs -f
