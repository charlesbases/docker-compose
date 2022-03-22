clean:
	@echo "cleaning..."
	@docker rm -f `docker ps -aq`

# MySQL
mysql-up:
	docker-compose -f mysql.yml up -d

mysql-down:
	docker-compose -f mysql.yml down

# Redis
redis-up:
	docker-compose -f redis.yml up -d

redis-down:
	docker-compose -f redis.yml down

# NSQ
nsq-up:
	docker-compose -f nsq.yml up -d

nsq-down:
	docker-compose -f nsq.yml down

# Nats
nats-up:
	docker-compose -f nats.yml up -d

nats-down:
	docker-compose -f nats.yml down

kafka-up:
	docker-compose -f kafka.yml up -d

kafka-down:
	docker-compose -f kafka.yml down