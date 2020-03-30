init:
	docker-compose up --build -d
	@composer
up:
	@make down
	docker-compose up -d #тут название контейнера
down:
	docker-compose stop
exec:
	docker-compose exec app bash
rm:
	docker-compose rm
exec.nginx:
	docker-compose exec nginx bash
exec.db:
	docker-compose exec db bash
network.down:
	@make down
	docker network prune
remove.all:
	docker system prune -a
composer:
	docker-compose exec app composer install