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
URL=$2

if [[ -z "$CMS" ]]; then
    echo -e "${ALERT}CMS не выбрана, выходим"
    exit 0
fi

echo -e "${INFO}Генерируем nginx и docker-compose конфигурации"

case ${CMS} in
     1)
     	echo -e "${INFO}Выбран Laravel"
		sed -e "s;%url%;${URL};g" ${TEMPLATE_DIR}laravel.conf > ./conf/nginx/project.conf
		;;
     2)
		echo -e "${INFO}Выбран MODX"
		sed -e "s;%url%;${URL};g" ${TEMPLATE_DIR}modx.conf > ./conf/nginx/project.conf
		;;
esac