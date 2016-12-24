#!/bin/bash
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -n|--name)
    NAME="$2"
    shift # past argument
    ;;
    -p|--password)
    PASSWORD="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
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
echo "Creating nginx site for $NAME"
rm -f /etc/nginx/sites-available/$NAME
sed '47a\
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
        }' /etc/nginx/sites-available/default > /etc/nginx/sites-available/$NAME
sed -i -- "s/try_files \$uri \$uri\/ =404/try_files \$uri \$uri\/index.php/" /etc/nginx/sites-available/$NAME
sed -i -- "s/listen 80 default_server/listen 80/" /etc/nginx/sites-available/$NAME
sed -i -- "s/root \/var\/www\/html/root \/opt\/moodle\/mt\/$NAME/" /etc/nginx/sites-available/$NAME
sed -i -- "s/server_name _/server_name www.$NAME.com/" /etc/nginx/sites-available/$NAME
ln -s /etc/nginx/sites-available/$NAME /etc/nginx/sites-enabled/$NAME
systemctl restart nginx
