#!/bin/bash

DIRECTORY="/media/backup/floor"
FILENAME="archive.zip"

if [ ! -d "$DIRECTORY" ]; then
        print "Directory not found. Exiting"
        exit 1
fi

if [ ! -f "$DIRECTORY/$FILE" ]; then
        print "Archive $file  not found"
fi

inotifywait -e access $DIRECTORY/$FILE
inotifywait -e close $DIRECTORY/$FILE
inotifywait -e delete $DIRECTORY/$FILE
inotifywait -e create $DIRECTORY/$FILE
inotifywait -e close $DIRECTORY/$FILE
inotifywait -e close $DIRECTORY/$FILE
cp $DIRECTORY/$FILE $DIRECTORY/"Archive$(date +%Y-%m-%d).zip"
