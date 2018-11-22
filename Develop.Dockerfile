FROM zvinger/docker-fpm:latest

RUN pecl install -o -f xdebug \
    && rm -rf /tmp/pear

RUN apt-get update && apt-get install libjudy-dev libjudydebian1 -y && pecl install memprof

RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_autostart=true" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_mode=req" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_log=/var/log/xdebug_remote.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_connect_back=Off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "extension=memprof.so" >> /usr/local/etc/php/conf.d/memprof.ini

RUN touch /var/log/xdebug_remote.log && chmod 777 /var/log/xdebug_remote.log
