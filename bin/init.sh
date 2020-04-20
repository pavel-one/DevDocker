#!/bin/bash
RED='\033[0;31m'         #  ${RED}
GREEN='\033[0;32m'      #  ${GREEN}
NORMAL='\033[0m'      #  ${NORMAL}
HR="----------------------------------------------"
ID=$(id -u)
GID=$(id -g)
TEMPLATE_DIR="${PWD}/bin/templates/"

echo -e ${HR}
echo -e "${GREEN}${USER}, Ваш id = ${ID}, ваш GID = ${GID}, если вы не авторизованы не под пользователем с \
которого хотите запускать проект, авторизуйтесь под ним${NORMAL}"
echo -e ${HR}

echo "Для продолжения нажмите ENTER"
read

echo -e "Введите домен вашего сайта без http/https, он будет добавлен hosts"
read URL
sudo bash ${PWD}/bin/hosts.sh ${URL}


echo -e "${GREEN}Генерируем docker-compose.yml${NORMAL}"
echo -e "Укажите прослушиваемый локальный порт по умолчанию - 80, например если вы хотите чтобы ваш контейнер был \
доступен по адресу ${URL}:81 впишите 81"
read PORT
if [[ -z "$PORT" ]]; then
    echo "Порт не задан, используется 80"
    PORT=80
fi

sed -e "s;%user%;${USER};g" -e "s;%uid%;${ID};g" -e "s;%port%;${PORT};g" ${TEMPLATE_DIR}docker-compose.yml > docker-compose.yml

