#!/bin/bash
apt-get install nginx
apt-get install php7.0-fpm
apt-get install php7.0-gd
apt-get install php7.0-xm
apt-get install php7.0-mysql
apt-get install php7.0-intl
apt-get install php7.0-curl
apt-get install php7.0-zip
apt-get install php7.0-soap
apt-get install php7.0-mbstring
apt-get install mariadb-server
apt-get install git
apt-get install ghostscript
cd /usr/lib/x86_64-linux-gnu
ln -s libgs.so.9 libgs.so
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java8-installer
