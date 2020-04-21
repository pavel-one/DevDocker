#!/bin/bash
RED='\033[0;31m'         #  ${RED}
GREEN='\033[0;32m'      #  ${GREEN}
NORMAL='\033[0m'      #  ${NORMAL}
HR="----------------------------------------------"
ID=$(id -u)
GID=$(id -g)
TEMPLATE_DIR="${PWD}/bin/templates/"


sudo rm -rf db/ redis/ app/
mkdir app

echo -e ${HR}
echo -e "${GREEN}${USER}, Ваш id = ${ID}, ваш GID = ${GID}, если вы не авторизованы не под пользователем с \
которого хотите запускать проект, авторизуйтесь под ним${NORMAL}"
echo -e ${HR}

echo "Для продолжения нажмите ENTER"
read

echo -en "Введите домен вашего сайта без http/https/www., он будет добавлен hosts: "
read URL
sudo bash ${PWD}/bin/hosts.sh ${URL}

# Генерация docker-compose.yml
echo -e "${GREEN}Генерируем docker-compose.yml${NORMAL}"
echo -en "Укажите прослушиваемый локальный порт по умолчанию - 80, например если вы хотите чтобы ваш контейнер был \
доступен по адресу ${URL}:81 впишите 81: "
read PORT
if [[ -z "$PORT" ]]; then
    echo "Порт не задан, используется 80"
    PORT=80
fi

echo -e "Выберете фреймворк: \n 1. Laravel \n 2. MODX:"
read CMS

## Генерация nginx
echo -e "${GREEN}Генерируем nginx конфигурации${NORMAL}"

if [[ "${CMS}" -eq "2" ]]; then
	echo "Выбран MODX"
	sed -e "s;%url%;${URL};g" ${TEMPLATE_DIR}modx.conf > ./conf/nginx/project.conf
	cp ${TEMPLATE_DIR}modx.sql ${PWD}/dump/dump.sql
else
	echo "Выбран Laravel"
	sed -e "s;%url%;${URL};g" ${TEMPLATE_DIR}laravel.conf > ./conf/nginx/project.conf
	cp ${TEMPLATE_DIR}laravel.sql ${PWD}/dump/dump.sql
fi
sed -e "s;%user%;${USER};g" -e "s;%uid%;${ID};g" -e "s;%port%;${PORT};g" ${TEMPLATE_DIR}docker-compose.yml > docker-compose.yml

make build > /dev/null

echo -en "${RED}Вам нужна автоматическая установка CMS в папку ./app [yes/no]:${NORMAL}"
read START

if [[ ${START} != "yes" ]]; then
	echo "Выходим"
	exit 25;
fi

if [[ "${CMS}" -eq "2" ]]; then
	echo -e "${GREEN}Устанавливаем MODX${NORMAL}"
	tar -xvf ${TEMPLATE_DIR}modx.tar.gz -C ./app > /dev/null
	echo -e "${GREEN}Установка выполнена успешно, ожидаем создание базы данных${NORMAL}"
	sleep 5
else
	echo -e "${GREEN}Устанавливаем Laravel${NORMAL}"
	git clone https://github.com/laravel/laravel.git app
	rm -rf ./app/.git
	sed -e "s;%url%;${URL};g" ${TEMPLATE_DIR}laravel.env > ./app/.env

	docker-compose exec app composer install
	docker-compose exec app php artisan key:generate

	make status
fi

echo -e "${HR}\n\n"
if [[ "${PORT}" -eq "80" ]]; then
	echo -e "Установка выполнена успешно, перейдите по адресу: \n\n http://${URL}"
else
	echo -e "Установка выполнена успешно, перейдите по адресу: \n\n http://${URL}:${PORT}"
fi
if [[ "${CMS}" -eq "2" ]]; then
	echo -e "\n ${GREEN}Админ-панель: /manager${NORMAL} \n Login: modx_admin \n Password: X5NasAOm\n"
fi
echo -e "\n\n${HR}"