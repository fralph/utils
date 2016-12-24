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
echo "Creating database $NAME"
mysql -u root --password=$PASSWORD -e "CREATE DATABASE $NAME DEFAULT CHARACTER SET 'UTF8' COLLATE 'utf8_unicode_ci';"
mysql -u root --password=$PASSWORD -e "GRANT ALL PRIVILEGES ON $NAME.* TO $NAME@'%' IDENTIFIED BY 'pepito.P0';"
mysql -u root --password=$PASSWORD -e "FLUSH PRIVILEGES;"
