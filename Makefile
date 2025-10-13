# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fdi-cecc <fdi-cecc@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/06 11:31:41 by fdi-cecc          #+#    #+#              #
#    Updated: 2025/10/13 12:58:35 by fdi-cecc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PROJECT_NAME = inception

all: up

up:
	@mkdir -p ~/data/db_data
	@mkdir -p ~/data/wp_data
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml up --build -d
	@echo "Waiting for services to start..."
	@until curl -f -k -s https://fdi-cecc.42.fr >/dev/null 2>&1; do sleep 2; done
	@echo "Services are ready!"

down:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml down --volumes

clean:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml down --volumes --rmi all
	docker system prune -af

re:
	$(MAKE) down
	$(MAKE) up

.PHONY: all up down clean re
