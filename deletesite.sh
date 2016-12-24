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
    -u|--url)
    URL="$2"
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
size=${#URL} 
if [ "$size" -lt "3" ]; then
   echo "Invalid length $size of URL";
   exit 1;
fi

echo "Deleting database $NAME"
mysql -u root --password=$PASSWORD -e "DROP DATABASE $NAME;"

echo "Deleting moodledata $NAME"
rm -rf /opt/data/$NAME

echo "Deleting nginx site for $NAME"
rm -f /etc/nginx/sites-available/$NAME
rm -f /etc/nginx/sites-enabled/$NAME
systemctl restart nginx

echo "Deleting config file for $NAME"
rm -f /opt/moodle/mt/$NAME/config.php
