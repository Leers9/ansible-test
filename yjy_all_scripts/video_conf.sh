#! /usr/bin/env bash
# 定时备份/root/shell 和 /root/scripts目录下的脚本文件以及配置文件
# 每天早上7点执行
bak_dir=(/root/shell/ /root/scripts/)
bak_dest_dir=/data/root_conf
today=`date +%Y%m%d`
today_dest=$bak_dest_dir"/"$today
if [ ! -f $today_dest ];then
	mkdir -p $today_dest
fi
for dir in ${bak_dir[@]}
do
	cd $dir
	tar zcvf $today_dest"/"$today"_conf".tar.gz ./*
done
find ./ -mtime +15 | xargs rm -rf 
