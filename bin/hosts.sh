#!/bin/bash
RED='\033[0;31m'         #  ${RED}
GREEN='\033[0;32m'      #  ${GREEN}
NORMAL='\033[0m'      #  ${NORMAL}
URL=$1


if grep ${URL}\$ /etc/hosts; then
	echo -e "${RED}Есть запись, выходим${NORMAL}"
	exit 0
else
	echo -e "127.0.0.1\t${URL}"
	echo -e "127.0.0.1\t${URL}" >> /etc/hosts
fi
