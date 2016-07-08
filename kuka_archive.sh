#!/bin/bash

DIRECTORY="/media/backup/"
FILENAME="archive.zip"

show_help() {
    echo "Makes a copy of an Kuka archive.zip with creation date as part of the name."
    echo "Setup on KRC:"
    echo "Mount a network share on the KRC and set this as the archive drive. "
    echo ""
    echo "Setup on server host the share:"
    echo "This script should be started at boot. Will create a copy of the archive file once KRC is done archiving."
    echo ""
    echo "Script parameters:"
    echo "-d Directory where the archive file is stored"
    echo "-f Filname of the archive"
    echo "-h display this help message"
}

OPTIND=1
while getopts ":h?d:f:" opt; do
        case $opt in
                h|\?) 
                        show_help
                        exit 0
                        ;;
                d) DIRECTORY=$OPTARG
                        ;;
                f) FILENAME=$OPTARG
                        ;;
        esac
done



if [ ! -d "$DIRECTORY" ]; then
        echo "Directory $DIRECTORY not found. Exiting"
        exit 1
fi

if [ ! -f "$DIRECTORY/$FILENAME" ]; then
        echo "Archive $FILENAME  not found"
fi        


while true; do
    inotifywait -qq -e access $DIRECTORY/$FILENAME
    inotifywait -qq -e close $DIRECTORY/$FILENAME
    echo "File read"
    inotifywait -qq -e delete_self $DIRECTORY/$FILENAME
    inotifywait -qq -e create $DIRECTORY
    echo "File created"
    inotifywait -qq -e close $DIRECTORY/$FILENAME
    inotifywait -qq -e close $DIRECTORY/$FILENAME
    echo "Copying file"
    cp $DIRECTORY/$FILENAME $DIRECTORY/"Archive-$(date +%Y-%m-%d-%H:%M).zip"
    sleep 1
done
