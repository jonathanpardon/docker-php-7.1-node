FROM php:7.1-fpm

RUN rm /etc/apt/preferences.d/no-debian-php

# Install selected extensions and other stuff
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    apt-transport-https \
    apt-utils \
    webp \
    git \
    zip \
    openssh-client \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libxml2-dev \
    libssl-dev \
    libwebp-dev \
    libxpm-dev \
    pkg-config \
    php-soap \
    libldap2-dev -y \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql zip \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-webp-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-xpm-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) exif gd \
    && docker-php-ext-install soap \
    && docker-php-ext-install ldap

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug ldap

# install from nodesource using apt-get
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -yq nodejs build-essential

# fix npm - not the latest version installed by apt-get
RUN npm install -g npm

# COMPOSER #################################################################
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 

RUN composer global require hirak/prestissimo