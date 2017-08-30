#!/usr/bin/env bash
# 清除app缓存目录 runtime 的缓存
app=$1
if [ $# != 1 ];then
	echo "传入的参数有误！请确认！" 
	exit
fi
if [ ! -d /www/web/$app ];then
	echo "指定的程序目录不存在！"
	exit
fi
cd /www/web/$app/ && a=`find ./ -name Runtime` && for i in $a;do rm -rf $i/* ;done
if [ $? -eq 0 ];then
	echo "$app 的runtime目录已经成功删除！" 
	exit
fi

