# /usr/bin/env bash
# 定时后台所有web_from 211
date_dir=`date +%Y%m%d`
# 211 临时web目录,如果直接scp会复制upload目录，先建立临时目录，然后将临时目录中的uplaod删除再scp
mkdir -p /www/backend_program/$date_dir
scp -rp -P 2282 root@10.45.37.167:/web_copy_temp/$date_dir/all_web_$date_dir.tar.gz /www/backend_program/$date_dir

