init:
	docker-compose up --build
up:
	@make down
	docker-compose up -d #тут название контейнера
down:
	docker-compose stop
exec:
	docker-compose exec app bash
exec.db:
	docker-compose exec mariadb bash
network.down:
	@make down
	docker network prune