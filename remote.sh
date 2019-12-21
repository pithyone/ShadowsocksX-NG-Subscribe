#!/bin/sh

# 数据库配置导入
defaults import com.qiuyuzhou.ShadowsocksX-NG $1

# 重启客户端
killall ShadowsocksX-NG ; open -a "ShadowsocksX-NG"

# 删除临时文件
rm -f $1
