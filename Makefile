clean:
	docker rm -f `docker ps -a | awk 'NR==2 {print $1}'`

.phony: up-mysql
up-mysql:
	docker-compose -f mysql.yml up -d

.phony: down-mysql
down-mysql:
	docker-compose -f mysql.yml down

.phony: up-redis
up-redis:
	docker-compose -f redis.yml up -d

.phony: down-redis
down-redis:
	docker-compose -f redis.yml down

.phony: up-nats
up-nats:
	docker-compose -f nats.yml up -d

.phony: down-nats
down-nats:
	docker-compose -f nats.yml up -d
