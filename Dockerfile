FROM 7.0-apache

MAINTAINER Minho <longfei6671@163.com>

ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/vhosts.conf /etc/apache2/vhosts.conf

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
		git \
		gcc \
		make \
        bzip2 \
		libbz2-dev \
		libmemcached-dev \
		libpcre3-dev \
    && docker-php-ext-install -j$(nproc) gd mcrypt mbstring  bz2 ctype zip pdo pdo_mysql
	
#安装Memcached扩展，不需要的可以删除
WORKDIR /usr/src/php/ext/
RUN git clone -b php7 https://github.com/php-memcached-dev/php-memcached.git \
	&& docker-php-ext-configure php-memcached \
	&& docker-php-ext-install php-memcached \
	&& rm -rf php-memcached
	
#Composer
RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer


RUN git clone https://github.com/lifei6671/SmartWiki.git \
	&& && chmod -R 0777 /var/www/html && cp SmartWiki/ /var/www/html/ && cd /var/www/html/ \
	&& composer install \
	&& php artisan key:generate
	