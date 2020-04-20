init:
	@make down
	bash bin/init.sh
#	@make build
#	@composer
build:
	docker-compose up --build -d
up:
	@make down
	docker-compose up -d
status:
	docker-compose ps
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