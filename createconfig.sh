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
echo "Creating config file for $NAME"
cp -f /opt/moodle/mt/$NAME/config-dist.php /opt/moodle/mt/$NAME/config.php
sed -i -- "s/pgsql/mariadb/" /opt/moodle/mt/$NAME/config.php
sed -i -- "s/'username'/'$NAME'/" /opt/moodle/mt/$NAME/config.php
sed -i -- "s/'moodle'/'$NAME'/" /opt/moodle/mt/$NAME/config.php
sed -i -- "s/'password'/'pepito.P0'/" /opt/moodle/mt/$NAME/config.php
sed -i -- "s/'http:\/\/example.com\/moodle'/'http:\/\/www.$NAME.com'/" /opt/moodle/mt/$NAME/config.php
sed -i -- "s/'\/home\/example\/moodledata'/'\/opt\/data\/$NAME'/" /opt/moodle/mt/$NAME/config.php
