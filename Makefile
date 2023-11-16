all:
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

re:
	docker-compose -f srcs/docker-compose.yml up -d --build

clean: down
	sudo rm -rf /home/tadiyamu/data/wordpress/*
	sudo rm -rf /home/tadiyamu/data/mariadb/*
	docker system prune -a

.PHONY: all re down clean
