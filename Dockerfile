FROM php:7.4-fpm

# Аргументы принимающие из docker-compose.yml
ARG user
ARG uid

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    mc \
    nano \
    vim \
    unzip

# Очистка кэша apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка расширений php
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Последний композер
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Создание системного пользователя
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Установка рабочей директории
WORKDIR /var/www

USER $user
