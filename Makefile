.PHONY: all up down kill rm clean

all: up

up:
	docker-compose up -d --force-recreate
	@make load

down: dump
	docker-compose down
	@make rm

kill: dump
	docker-compose kill
	@make rm

rm:
	docker-compose rm -f

clean: kill
	docker system prune -f
	docker rmi mysql phpmyadmin/phpmyadmin

dump:
	./dump.sh

load:
	./load.sh

backup:
	@if [ -f dump.sql.tar.gz ]; then \
		cp dump{,backup}.sql.tar.gz; \
	fi
	@if [ -f dump.sql ]; then \
		cp dump{,backup}.sql; \
	fi

is_running:
	@if [ -z "`docker ps --filter publish=3306 -q`" ]; then \
		exit 1; \
	fi

pack:
	@if [ -f dump.sql ]; then \
		tar -zcvf dump.sql{.tar.gz,}; \
		rm dump.sql; \
	fi

unpack:
	@if [ -f dump.sql.tar.gz ]; then \
		tar -zxvf dump.sql.tar.gz; \
		rm dump.sql.tar.gz; \
	fi
