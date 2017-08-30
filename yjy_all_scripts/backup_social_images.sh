# /usr/bin/env bash
# 定时圈子的web图片
date_dir=`date -d yesterday +%Y_%m_%d`
mkdir -p /www/social_images/$date_dir
scp -rp -P 2282 root@10.24.203.239:/www/web /www/social_images/$date_dir

if [ $? -eq 0 ];then
	cd /www/social_images/
	tar zcf /www/social_images/$date_dir-socail_images.tar.gz /www/social_images/$date_dir
	find /www/social_images/ -mtime +3 | xargs rm -rf 
fi
