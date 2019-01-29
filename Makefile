.PHONY: all up down kill rm clean

all: up

up:
	docker-compose up -d --force-recreate

down:
	docker-compose down
	make rm

kill:
	docker-compose kill
	make rm

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

compress:
	if [ -d mysql_data ]; then \
		echo "compressing the garbage"; \
		tar -cvf mysql_data.tgz mysql_data; \
		rm -rf mysql_data; \
	fi

uncompress:
	if [ -f mysql_data.tgz ]; then \
		echo "uncompressing the garbage"; \
		tar -xvf mysql_data.tgz; \
		rm mysql_data.tgz; \
	fi
