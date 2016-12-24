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
echo "Creating moodledata $NAME"
mkdir /opt/data/$NAME
chown -R www-data:www-data /opt/data/$NAME
