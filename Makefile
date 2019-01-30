.PHONY: all up down kill rm clean

all: up

up:
	docker-compose up -d --force-recreate
	make load

down: dump
	docker-compose down
	make rm cleandb

kill: dump
	docker-compose kill
	make rm cleandb

rm:
	docker-compose rm -f

clean: kill
	docker system prune -f
	docker rmi mysql phpmyadmin/phpmyadmin

cleandb:
	if [ -d mysql_data ]; then \
		echo "deleting the garbage..."; \
		rm -rf mysql_data; \
		echo "good riddence to that crap"; \
	fi

dump:
	make backup
	docker exec `docker ps --filter publish=3306 -q` \
	mysqldump --user=root --password=password -A > dump.sql
	make pack

load:
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
		mv dump{,backup}.sql.tar.gz; \
	fi
	if [ -f dump.sql ]; then \
		mv dump{,backup}.sql; \
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
