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

echo -e "${ALERT}Сейчас начнется инициализация проекта, это удалит папки ./db и ./redis, если они существуют, а также создаст папку ./app, нажмите ENTER для продолжения"
read

sudo rm -rf db/ redis/
mkdir app

echo -en "${INPUT}Введите домен вашего сайта без http/https/www., он будет добавлен hosts: "
read URL
sudo bash ${PWD}/bin/hosts.sh ${URL}

# Генерация docker-compose.yml
echo -e "${INFO}Генерируем docker-compose.yml"
echo -en "${INPUT}Укажите прослушиваемый локальный порт по умолчанию - 80, например если вы хотите чтобы ваш контейнер был \
доступен по адресу ${URL}:81 впишите 81: "
read PORT

if [[ -z "$PORT" ]]; then
    echo -e "${INFO}Порт не задан, используется 80"
    PORT=80
fi

echo -e "${INPUT}Выберете фреймворк: \n 1. Laravel \n 2. MODX:"
read CMS

## Генерация конфигураций
bash ${PWD}/bin/configs.sh ${CMS} ${URL}
sed -e "s;%user%;${USER};g" -e "s;%uid%;${ID};g" -e "s;%port%;${PORT};g" ${TEMPLATE_DIR}docker-compose.yml > docker-compose.yml

echo -e "${ALERT}Внимание! Это удалит ваш дамп БД и все файлы в папке ./app"
echo -en "${INPUT}Вам нужна автоматическая установка фреймворка в папку ./app [yes/no]: "
read START

if [[ ${START} -eq "yes" ]]; then
	bash ${PWD}/bin/cms.sh ${CMS}
else
	echo -e "${INFO}Собираем и запускаем контейнер"
	make build > /dev/null
fi


echo -e "${HR}\n\n"
if [[ "${PORT}" -eq "80" ]]; then
	echo -e "Установка выполнена успешно, перейдите по адресу: \n\n http://${URL}"
else
	echo -e "Установка выполнена успешно, перейдите по адресу: \n\n http://${URL}:${PORT}"
fi
if [[ "${CMS}" -eq "2" ]]; then
	echo -e "\n ${GREEN}Админ-панель: http://${URL}/manager${NORMAL} \nLogin: modx_admin \nPassword: X5NasAOm\n"
fi
echo -e "\n\n${HR}"