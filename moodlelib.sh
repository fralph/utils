#!/bin/bash

function getparams {
  args=("$@")
  # get number of elements
  ELEMENTS=${#args[@]}
  
  # echo each element in array
  # for loop
  for (( i=0;i<$ELEMENTS;i++)); do
      key="${args[${i}]}"
  case $key in
      -n|--name)
      i=$i+1
      value="${args[${i}]}"
      NAME="$value"
      ;;
      -p|--password)
      i=$i+1
      value="${args[${i}]}"
      PASSWORD="$value"
      ;;
      -u|--url)
      i=$i+1
      value="${args[${i}]}"
      URL="$value"
      ;;
      *)
              # unknown option
      ;;
  esac
  done
  
  size=${#NAME}
  if [ "$size" -lt "3" ]; then
     echo "Invalid length $size of moodle site name";
     exit 1;
  fi
  size=${#PASSWORD}
  if [ "$size" -lt "3" ]; then
     echo "Invalid length $size of mysql root password";
     exit 1;
  fi
  size=${#URL}
  if [ "$size" -lt "3" ]; then
     echo "Invalid length $size of URL";
     exit 1;
  fi
}

function createdatabase {
  echo "Creating database $NAME"
  mysql -u root --password=$PASSWORD -e "CREATE DATABASE $NAME DEFAULT CHARACTER SET 'UTF8' COLLATE 'utf8_unicode_ci';"
  mysql -u root --password=$PASSWORD -e "GRANT ALL PRIVILEGES ON $NAME.* TO $NAME@'%' IDENTIFIED BY '$PASSWORD';"
  mysql -u root --password=$PASSWORD -e "FLUSH PRIVILEGES;"
}

function createmoodledata {
  echo "Creating moodledata $NAME"
  mkdir /opt/moodle/mdata/$NAME
  chown -R www-data:www-data /opt/moodle/mdata/$NAME
}

function createnginxsite {
  echo "Creating nginx site for $NAME"
  rm -f /etc/nginx/sites-available/$NAME
  sed '47a\
\
        location ~ [^/]\\.php(/|$) {\
          fastcgi_split_path_info ^(.+?\\.php)(/.*)$;\
          fastcgi_index index.php;\
          fastcgi_pass unix:/run/php/php7.0-fpm.sock;\
          include fastcgi_params;\
          fastcgi_param   PATH_INFO $fastcgi_path_info;\
          fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;\
          if (!-f $document_root$fastcgi_script_name) {\
                  return 404;\
          }\
        }\
        ' /etc/nginx/sites-available/default > /etc/nginx/sites-available/$NAME
  sed -i -- "s/try_files \$uri \$uri\/ =404/try_files \$uri \$uri\/index.php/" /etc/nginx/sites-available/$NAME
  sed -i -- "s/listen 80 default_server/listen 80/" /etc/nginx/sites-available/$NAME
  sed -i -- "s/listen [::]:80 default_server/listen [::]:80/" /etc/nginx/sites-available/$NAME
  sed -i -- "s/root \/var\/www\/html/root \/opt\/moodle\/mt\/$NAME/" /etc/nginx/sites-available/$NAME
  sed -i -- "s/server_name _/server_name $URL/" /etc/nginx/sites-available/$NAME
  ln -s /etc/nginx/sites-available/$NAME /etc/nginx/sites-enabled/$NAME
  systemctl restart nginx
}

function createmoodleconfig {
  echo "Creating config file for $NAME"
  cp -f /opt/moodle/mt/$NAME/config-dist.php /opt/moodle/mt/$NAME/config.php
  sed -i -- "s/pgsql/mariadb/" /opt/moodle/mt/$NAME/config.php
  sed -i -- "s/'username'/'$NAME'/" /opt/moodle/mt/$NAME/config.php
  sed -i -- "s/'moodle'/'$NAME'/" /opt/moodle/mt/$NAME/config.php
  sed -i -- "s/'password'/'$PASSWORD'/" /opt/moodle/mt/$NAME/config.php
  sed -i -- "s/'http:\/\/example.com\/moodle'/'http:\/\/$URL'/" /opt/moodle/mt/$NAME/config.php
  sed -i -- "s/'\/home\/example\/moodledata'/'\/opt\/moodle\/mdata\/$NAME'/" /opt/moodle/mt/$NAME/config.php
}

function runmoodleinstallfirst {
  echo "Installing moodle $NAME"
  cd /opt/moodle/mt/$NAME/admin/cli
  sudo -u www-data /usr/bin/php install_database.php --agree-license --adminemail=soporte@edocere.com --fullname=$NAME --shortname=$NAME --adminpass=$PASSWORD
}

function usage {
  echo "Usage: createsite.sh -n moodle -p pepito -u www.webclass.com"
}
