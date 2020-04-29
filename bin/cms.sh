#!/bin/bash
RED='\033[0;31m'         #  ${RED}
GREEN='\033[0;32m'      #  ${GREEN}
YELLOW='\033[33m'      #  ${YELLOW}
BLUE='\033[36m'      #  ${BLUE}
NORMAL='\033[0m'      #  ${NORMAL}

BUILD="[${YELLOW}BUILD${NORMAL}] "
INFO="[${GREEN}INFO${NORMAL}] "
ALERT="[${RED}ALERT${NORMAL}] "
INPUT="[${BLUE}INPUT${NORMAL}] "

HR="----------------------------------------------"
ID=$(id -u)
GID=$(id -g)
TEMPLATE_DIR="${PWD}/bin/templates/"

CMS=$1

if [[ -z "$CMS" ]]; then
    echo -e "${ALERT}CMS не выбрана, выходим"
    exit 0
fi

echo -e "${ALERT}Очищаем папку ./app"
sudo rm -rf app/
mkdir app

case ${CMS} in
     1)
		echo -e "${INFO}Устанавливаем Laravel"
		echo -e "${INFO}Копируем чистую базу данных"
		cp ${TEMPLATE_DIR}laravel.sql ${PWD}/dump/dump.sql
		git clone https://github.com/laravel/laravel.git app
		rm -rf ./app/.git
		sed -e "s;%url%;${URL};g" ${TEMPLATE_DIR}laravel.env > ./app/.env

		make build > /dev/null
		echo -e "${INFO}Установка выполнена успешно, ожидаем создание базы данных"
		sleep 5

		echo -e "${INFO}Устанавливаем зависимости"
		docker-compose exec app composer install
		docker-compose exec app php artisan key:generate

		make status
		;;
     2)
		echo -e "${INFO}Устанавливаем MODX"
		echo -e "${INFO}Копируем чистую базу данных"
		cp ${TEMPLATE_DIR}modx.sql ${PWD}/dump/dump.sql
		echo -e "${INFO}Распаковываем слепок modx"
		tar -xvf ${TEMPLATE_DIR}modx.tar.gz -C ./app > /dev/null
		make build > /dev/null
		echo -e "${INFO}Установка выполнена успешно, ожидаем создание базы данных"
		sleep 10
		make status
		;;
esac


