FROM php:7.4-fpm


ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.4/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=3a631023f9f9dd155cfa0d1bb517a063d375055a

RUN apt-get update \
    && apt-get install -y \
        --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libicu-dev \
        libc-client-dev \
        git \
        libkrb5-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libmemcached-dev \
        default-libmysqlclient-dev \
        libicu-dev \
        libpq-dev \
        curl \
        wget \
        unzip \
        libgearman-dev
RUN apt-get install -y libonig-dev && docker-php-ext-install intl mbstring pdo_mysql exif mysqli
RUN docker-php-ext-install gd
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis
RUN cd /tmp/ \
    && wget https://github.com/wcgallego/pecl-gearman/archive/master.zip --no-check-certificate \
    && unzip master.zip \
    && cd pecl-gearman-master \
    && phpize \
    && ./configure \
    && make \
    && make install
RUN apt-get install libfontconfig1 libxrender1 xvfb -y \
    && cd ~ \
    && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && cp wkhtmltox/bin/wk* /usr/local/bin/  \
    && docker-php-ext-enable gearman \
    && docker-php-ext-install pdo pdo_pgsql \
    && curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    && apt-get purge -y g++ \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && mkdir /var/soft \
    && cd /var/soft \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv /var/soft/composer.phar /usr/bin/composer \
    && usermod -u 1000 www-data \
    && rm wkhtmltox* -rf

RUN apt-get update -y && \
        apt-get install -y libmcrypt-dev && \
        pecl install mcrypt-1.0.3 && \
        docker-php-ext-enable mcrypt

RUN pecl install mongodb \
      && docker-php-ext-enable mongodb

COPY ./php.ini /usr/local/etc/php/
COPY ./www.conf /usr/local/etc/php/

WORKDIR /var/www
EXPOSE 9000
CMD ["php-fpm"]
