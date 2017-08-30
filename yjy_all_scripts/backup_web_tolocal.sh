#!/usr/bin/env bash
# 不应该备份在一块阿里云的磁盘分区上
today=`date +%Y%m%d`
conn=_
web_back_dir=/web_copy_temp/$today"/"
mkdir -p $web_back_dir
web_dir=/www/web/
cd $web_back_dir 
tar -zcf all_web$conn$today.tar.gz $web_dir/*

# 保留10天web备份
find ./ -mtime +3 | xargs rm -rf 
