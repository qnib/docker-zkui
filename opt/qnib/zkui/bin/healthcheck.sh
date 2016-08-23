#!/bin/bash

echoerr() { echo "$@" 1>&2; }

curl -sI localhost:9090 > /dev/null
if [ $? -ne 0 ];then
    echoerr "> curl -sI localhost:9090 -> FAIL"
    curl -sI localhost:9090 > /dev/null
    exit 1
else
    echo "> curl -I localhost:9090 -> OK"
    curl -sI localhost:9090 > /dev/null
    exit 0
fi
