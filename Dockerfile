FROM php:7.1-fpm

# Install selected extensions and other stuff
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    apt-utils \
    openssh-client \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxml2-dev \
    wkhtmltopdf \
    xvfb \
    libssl-dev \
    pkg-config \
    zip \
    unzip \
    git \
    default-jre \
    libjpeg62-turbo-dev \
    webp \
    libwebp-dev \
    libxpm-dev \
    imagemagick \
    libtool \
    libmagickwand-dev \
    libmagickcore-dev \
    libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ \
    php7.1-ldap \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql zip \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-webp-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-xpm-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) exif gd

RUN pecl install redis \
    && pecl install imagick-3.4.3 \
    && pecl install xdebug \
    && pecl install apcu \
    && pecl install mongodb \
    && docker-php-ext-enable redis xdebug apcu mongodb imagick soap

# install from nodesource using apt-get
RUN curl -sL https://deb.nodesource.com/setup | sudo bash - && \
    RUN apt-get install -yq nodejs build-essential

# fix npm - not the latest version installed by apt-get
RUN npm install -g npm