#!/bin/bash

config=~/.config/exportcam

if [ -n "$1" ]
then
    album="$1"
else
    if [ -f "$config" ]
    then
        album=$(cat "$config")
    else
        >&2 echo Neither command line option nor configuration file exists.
        >&2 echo -e "\nUse: exportcam /export/directory\n"
        >&2 echo No action will be performed. Exiting.
        exit 1
    fi
fi

if [ ! -d "$album" ]
then
    >&2 echo Album directory not exits: $album
    >&2 echo -e "\nPlease specify a valid one by command line:"
    >&2 echo By example:
    >&2 echo -e "\n\texportcam /data/album\n"
    >&2 echo No action will be performed. Exiting.
    exit 2
fi

for i in IMG_*.jpg VID_*.mp4
do
    if [ ! -f "$i" ]
    then
        echo No file: $i
        continue
    fi
    
    n=$(echo $i | cut -c 5- | tr _ ' ')
    year=$(echo $n | cut -c1-4)
    month=$(echo $n | cut -c5-6)

    case $month in
        01)
        month='01-Enero'
        ;;
        01)
        month='02-Febrero'
        ;;
        03)
        month='03-Marzo'
        ;;
        04)
        month='04-Abril'
        ;;
        05)
        month='05-Mayo'
        ;;
        06)
        month='06-Junio'
        ;;
        07)
        month='07-Julio'
        ;;
        08)
        month='08-Agosto'
        ;;
        09)
        month='09-Septiembre'
        ;;
        10)
        month='10-Octubre'
        ;;
        11)
        month='11-Noviembre'
        ;;
        12)
        month='12-Diciembre'
        ;;
        *)
        >&2 echo "Error to process month: $month"
        exit 3
        ;;
    esac
    
    savedir="$album/$year/$month"
    
    mkdir -pv "$savedir" &&
    mv -iv "$i" "$savedir/$n" || echo "Failed to move $i to $savedir/$n"
done

