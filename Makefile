clean:
	docker rm -f `docker ps -a | awk 'NR==2 {print $1}'`

.phony: mysql-up
mysql-up:
	docker-compose -f mysql.yml up -d

.phony: mysql-down
mysql-down:
	docker-compose -f mysql.yml down

.phony: redis-up
redis-up:
	docker-compose -f redis.yml up -d

.phony: redis-down
redis-down:
	docker-compose -f redis.yml down

.phony: nats-up
nats-up:
	docker-compose -f nats.yml up -d

.phony: nats-down
nats-down:
	docker-compose -f nats.yml down

.phony: mongo-up
mongo-up:
	docker-compose -f mongo.yml up -d

.phony: mongo-down
mongo-down:
	docker-compose -f mongo.yml down

.phony: nsq-up
nsq-up:
	docker-compose -f nsq.yml up -d

.phony: nsq-down
nsq-down:
	docker-compose -f nsq.yml down