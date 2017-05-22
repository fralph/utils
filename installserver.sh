#!/bin/bash
apt-get update
apt-get -y install php7.0-fpm
apt-get -y install php7.0-gd
apt-get -y install php7.0-xm
apt-get -y install php7.0-mysql
apt-get -y install php7.0-intl
apt-get -y install php7.0-curl
apt-get -y install php7.0-zip
apt-get -y install php7.0-soap
apt-get -y install php7.0-mbstring
apt-get -y instlal nginx
apt-get -y install mariadb-server
apt-get -y install git
apt-get -y install ghostscript
cd /usr/lib/x86_64-linux-gnu
ln -s libgs.so.9 libgs.so
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java8-installer
