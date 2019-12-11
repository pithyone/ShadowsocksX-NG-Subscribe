#!/bin/sh

if [ -z "$HOST_USER" ]; then
    echo "Please set your host user with -e HOST_USER=foo"
    exit 1
fi

/usr/local/bin/node index.js

TMP=com.qiuyuzhou.ShadowsocksX-NG.tmp.plist
FILE="~/Library/Preferences/$TMP"
DT="[$(TZ=Asia/Shanghai date '+%d/%m/%Y:%H:%M:%S %z')]";

if [ -f "$TMP" ]; then
    scp -o "StrictHostKeyChecking no" $TMP $HOST_USER@host.docker.internal:$FILE
    ssh -o "StrictHostKeyChecking no" $HOST_USER@host.docker.internal "bash -s" < remote.sh $FILE
    echo "$DT \"update successful\""
else
    echo "$DT \"$TMP does not exist\""
    exit 1
fi