FROM php:7.1-fpm

# Install required libs
RUN apt-get update && \
    apt-get install -y \
        gnupg \
        sudo \
        git \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        libsqlite3-dev \
        sqlite3 \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        libjudydebian1 \
        libjudy-dev \
        zlib1g-dev \
        cron \
        wget \
    && apt-get clean

#
# Install extensions
#
RUN docker-php-ext-install \
        mcrypt \
        pdo_mysql \
        pdo_sqlite \
        pcntl \
        sockets \
        bcmath \
        gd

#
# Install non standard extensions
#
RUN pecl install ev
RUN pecl install -o -f redis

# Install zip
RUN docker-php-ext-install zip

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

RUN rm -r /var/lib/apt/lists/*
RUN rm -rf /tmp/pear

#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="/var/www/vendor/bin:$PATH"' >> ~/.bashrc


WORKDIR /var/www/

RUN usermod -u 1000 www-data
USER www-data

EXPOSE 80
