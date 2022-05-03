FROM php:7.4-fpm

# install the PHP extensions we need
RUN apt-get update && apt-get install -y  libonig-dev libpng-dev libcurl4-openssl-dev curl libzip-dev libjpeg-dev unzip  && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-jpeg=/usr \
	&& docker-php-ext-install curl gd opcache mysqli pdo pdo_mysql json mbstring zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# set timezone
RUN { \
		echo 'date.timezone=Europe/Moscow'; \
	} > /usr/local/etc/php/conf.d/datetime.ini

WORKDIR /var/www/html



CMD ["php-fpm"]
