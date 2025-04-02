SOURCES_FOLDER	:=	./srcs/
COMPOSE		:=	docker compose --project-directory ${SOURCES_FOLDER}
DATA		:=	${HOME}/data
VOLUMES		:=	${addprefix ${DATA}/, wordpress	mariadb }

.PHONY: all
all: up

.PHONY: up
up: create_dir build create
	${COMPOSE} up -d

.PHONY: stop down build create
stop down build create:
	${COMPOSE} $@

.PHONY: ps
ps:
	${COMPOSE} $@ -a

.PHONY: logs
logs:
	cd srcs && docker-compose logs && cd ..

.PHONY: clean
clean:
	${COMPOSE} down --rmi all

.PHONY: fclean
fclean:
	${COMPOSE} down --rmi all --volumes
	docker system prune -af
	sudo rm -rf ${VOLUMES}

.PHONY: create_dir
create_dir:
	mkdir -p ${VOLUMES}	

.PHONY: re
re: fclean all
