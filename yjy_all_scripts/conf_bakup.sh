# !/usr/bin/env bash
# 程序配置文件备份
backup_dir=/www/data/backup/conf
save_days=7
yesterday=`date -d yesterday +%Y_%m_%d`
mkdir -p $bakup_dir
cd $backup_dir
zip -r nginx_conf$yesterday.zip /usr/local/nginx/conf
zip -r php_conf$yesterday.zip /usr/local/php/etc
# 删除七天以前的配置文件
find $backup_dir -mtime +$save_days -exec rm -rf {} \;
