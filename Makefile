# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fdi-cecc <fdi-cecc@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/06 11:31:41 by fdi-cecc          #+#    #+#              #
#    Updated: 2025/10/17 16:26:34 by fdi-cecc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PROJECT_NAME = inception

all:
	@mkdir -p ~/data/db_data
	@mkdir -p ~/data/wp_data
	@mkdir -p ~/data/port_data
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml up --build -d

up:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml up -d

down:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml down

clean:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml down --volumes --rmi all
	docker system prune -af

vclean:
	docker-compose -p $(PROJECT_NAME) -f ./srcs/docker-compose.yml down --volumes --rmi all
	docker system prune -af
	sudo rm -rf ~/data/wp_data ~/data/db_data ~/data/port_data

re:
	$(MAKE) clean
	$(MAKE) all

vre:
	$(MAKE) vclean
	$(MAKE) all

.PHONY: all up down clean vclean re vre
