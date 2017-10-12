#!/usr/bin/env bash


cd /tmp/
wget https://github.com/wcgallego/pecl-gearman/archive/master.zip --no-check-certificate
unzip master.zip
cd pecl-gearman-master
phpize
./configure
make
make install
docker-php-ext-enable gearman
