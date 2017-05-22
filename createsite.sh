#!/bin/bash

source moodlelib.sh

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
   usage
   exit 1;
fi
size=${#PASSWORD} 
if [ "$size" -lt "3" ]; then
   echo "Invalid length $size of mysql root password";
   usage
   exit 1;
fi
size=${#URL} 
if [ "$size" -lt "3" ]; then
   echo "Invalid length $size of URL";
   usage
   exit 1;
fi

echo "Creating site $NAME with password $PASSWORD for URL $URL";

createdatabase

createmoodledata

createnginxsite

createmoodleconfig

runmoodleinstallfirst
