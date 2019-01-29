.PHONY: all up down kill rm clean

all: up

up:
	docker-compose up -d --force-recreate

down:
	docker-compose down

kill:
	docker-compose kill

rm:
	docker-compose rm -f

clean: kill
	docker system prune -f
	docker rmi mysql phpmyadmin/phpmyadmin
