.PHONY: all up down kill rm clean

all: up

up:
	docker-compose up -d --force-recreate
	make load

down: dump
	docker-compose down
	make rm

kill: dump
	docker-compose kill
	make rm

rm:
	docker-compose rm -f

clean: kill
	docker system prune -f
	docker rmi mysql phpmyadmin/phpmyadmin

dump:
	if make is_running; then \
		make backup; \
		docker exec `docker ps --filter publish=3306 -q` \
		mysqldump --user=root --password=password -A > dump.sql; \
		make pack; \
	fi

load:
	make is_running
	@echo "loading database backup to container..."
	@echo "PLZ no exit!! This may take a minute..."
	@if [ -f dump.sql.tar.gz ]; then \
		make unpack; \
		for i in `seq 30`; do \
			sleep 1; \
		  docker exec -i `docker ps --filter publish=3306 -q` \
		  mysql --password=password < dump.sql 2> /dev/null && break; \
		done; \
		echo "Success!"; \
	fi;
	make pack

backup:
	if [ -f dump.sql.tar.gz ]; then \
		cp dump{,backup}.sql.tar.gz; \
	fi
	if [ -f dump.sql ]; then \
		cp dump{,backup}.sql; \
	fi

is_running:
	@if [ -z "`docker ps --filter publish=3306 -q`" ]; then \
		exit 1; \
	fi

pack:
	if [ -f dump.sql ]; then \
		tar -cvf dump.sql{.tar.gz,}; \
		rm dump.sql; \
	fi

unpack:
	if [ -f dump.sql.tar.gz ]; then \
		tar -xvf dump.sql.tar.gz; \
		rm dump.sql.tar.gz; \
	fi
