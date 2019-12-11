#!/bin/sh

defaults import com.qiuyuzhou.ShadowsocksX-NG $1
killall ShadowsocksX-NG
open -a "ShadowsocksX-NG"
rm -f $1