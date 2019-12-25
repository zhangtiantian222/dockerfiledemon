#!/bin/sh
oldcksum=`cksum /etc/nginx/conf.d`

inotifywait -e modify,move,create,delete -mr --timefmt '%d/%m/%y %H:%M' --format '%T' \
/etc/nginx/conf.d/ | while read date time; do

    newcksum=`cksum /etc/nginx/conf.d`
    if [ "$newcksum" != "$oldcksum" ]; then
        echo "At ${time} on ${date}, config file update detected."
        oldcksum=$newcksum
        nginx -s reload
    fi
done
