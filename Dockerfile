FROM php:7.3-fpm

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
    libmagickwand-dev \
    imagemagick \
    zlib1g-dev \
    libzip-dev \
    unzip

# Очистка кэша apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка расширений php
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Image Magick
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

# Последний композер
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Создание системного пользователя
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Установка рабочей директории
WORKDIR /var/www

USER $user
