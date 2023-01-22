#!/bin/bash

usage(){
    echo ""
    echo "Usage ./simple_log.sh [OPTIONS] [your_log_file]"
    echo ""
    echo "If you need some guides."
    echo "      ./simple_log.sh -h"
    echo ""
}

option_help() {
    echo ""
    echo "Help: Show commands"
    echo ""
    echo "  -c     : Custom web logs."
    echo "  -d     : Analysis directory."
    echo "  -h     : Show commands."
    echo "  -t     : Log type. Apache or Nginx"
    echo "  -v     : Show version"
}

analysis(){
    echo ""
    echo "$file analysis."
    DATE=$(date "+%Y.%m.%d_%H-%M-%S")

    SHA1=$(sha1sum $file)
    MD5=$(md5sum $file)

    if [ ! -d ./log ]; then
        echo "$date [Info] Create directory \"log\"" > .log
        mkdir ./log
    fi

    mkdir ./log/$DATE

    echo "$date [Info] Parse Meta data." > .log
    awk '{print $1, $6}' $file > .total_method
    awk '{print $1}' .total_method | uniq -c | sort -rn > .ip

    TOTAL_UNIQ=$(awk -F " " '{sub("\"", "", $6); print $1, $6}' $file | uniq | wc -l)

    IP_UNIQ=$(cat .ip | wc -l)
    TOTAL_COUNT=$(cat .total_method | wc -l)
    GET_COUNT=$(cat .total_method | grep "GET" | wc -l)
    POST_COUNT=$(cat .total_method | grep "POST" | wc -l)
    PUT_COUNT=$(cat .total_method | grep "PUT" | wc -l)
    DELETE_COUNT=$(cat .total_method | grep "DELETE" | wc -l)
    OPTION_COUNT=$(cat .total_method | grep "OPTION" | wc -l)
    OTHERS_COUNT=$(($TOTAL_COUNT-$GET_COUNT-$POST_COUNT-$PUT_COUNT-$DELETE_COUNT-$OPTION_COUNT))

    echo "$date [Info] Parse GET request." > .log
    grep -h 'GET' $file > ./log/$DATE/$file.GET.log

    echo "$date [Info] Parse none-GET request." > .log
    grep -hv 'GET' $file > ./log/$DATE/$file.NONE-GET.log

    echo "$date [Info] Parse suspicious request." > .log
    grep '(\\x)[0-9a-zZ-Z]|..' $file > ./log/$DATE/$file.suspicious.log

    echo ""
    echo "------------------result------------------"
    echo ""
    echo "file: $file."
    echo "md5: $MD5"
    echo "sha1: $SHA1"
    echo "total unique log: $TOTAL_UNIQ"
    echo "count per IP: $IP_UNIQ"
    echo "$(head -n 5 .ip)"
    echo "count per http method: $TOTAL_COUNT"
    echo "  GET: $GET_COUNT"
    echo "  POST: $POST_COUNT"
    echo "  PUT: $PUT_COUNT"
    echo "  DELETE: $DELETE_COUNT"
    echo "  OPTION: $OPTION_COUNT"
    echo "  OTHERS: $OTHERS_COUNT"

    rm .total_method
    rm .ip
}


if [ -z "$1" ]; then
    usage
else
    file=$1
    if [ "$1" == "-h" ]; then
        option_help
    elif [ "$1" == "-d" ]; then
        if [ -z "$2" ]; then
            usage
        else
            option_dir
        fi
    else
        analysis
    fi
fi
