#!/bin/sh

# 临时文件名称
TMP_FILENAME=com.qiuyuzhou.ShadowsocksX-NG.tmp.plist

# 主机存储临时文件的路径
TMP_FILEPATH_ON_HOST="~/Library/Preferences/$TMP_FILENAME"

# 日志日期格式
LOGGER_DATE_FORMAT="$(TZ=Asia/Shanghai date '+%Y-%m-%d %H:%M:%S')";

# 错误日志
logger_error()
{
    echo "${LOGGER_DATE_FORMAT} ERROR ${1}"
    exit 1
}

# 常规日志
logger_info()
{
    echo "${LOGGER_DATE_FORMAT} INFO ${1}"
}

# 检查是否输入 HOST_USER 环境变量
if [ -z "$HOST_USER" ]; then
    logger_error "please set your host user with -e HOST_USER=\$USER"
fi

# 检查是否输入 URL 环境变量
if [ -z "$URL" ]; then
    logger_error "please set your subscribe link with -e URL=\"***\""
fi

# 检测 ssh 通道是否正常
ssh -o "StrictHostKeyChecking no" $HOST_USER@host.docker.internal exit \
|| logger_error "ssh permission denied, please check -v \$HOME/.ssh:/root/.ssh/host or -e HOST_USER=\$USER is correct"

# 更新订阅
/usr/local/bin/node index.js \
&& scp $TMP_FILENAME $HOST_USER@host.docker.internal:$TMP_FILEPATH_ON_HOST \
&& ssh $HOST_USER@host.docker.internal "bash -s" < remote.sh $TMP_FILEPATH_ON_HOST \
&& logger_info "refresh successful"
