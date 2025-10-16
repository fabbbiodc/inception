# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fdi-cecc <fdi-cecc@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/06 11:31:41 by fdi-cecc          #+#    #+#              #
#    Updated: 2025/10/16 11:15:06 by fdi-cecc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PROJECT_NAME = inception

all:
	@mkdir -p ~/data/db_data
	@mkdir -p ~/data/wp_data
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml up --build -d
	@echo "Waiting for services to start..."
	@until curl -f -k -s https://fdi-cecc.42.fr >/dev/null 2>&1; do sleep 2; done
	@echo "Services are ready!"

up:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml up -d
	@echo "Waiting for services to start..."
	@until curl -f -k -s https://fdi-cecc.42.fr >/dev/null 2>&1; do sleep 2; done
	@echo "Services are ready!"

down:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml down

clean:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml down --volumes --rmi all
	docker system prune -af

vclean:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml down --volumes --rmi all
	docker system prune -af
	sudo rm -rf ~/data/wp_data ~/data/db_data

re:
	$(MAKE) clean
	$(MAKE) all

vre:
	$(MAKE) vclean
	$(MAKE) all

.PHONY: all up down clean vclean re vre
