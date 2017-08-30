#! /usr/bin/env bash
# scp图片数据用于存储挂载
apps=(tiku passport tcms xiyizhiyeyishi political tcmsq xiyizhulizyys score)

for app in ${apps[@]}
do
	scp -rp -P 2012 /www/web/$app.letiku.net/Uploads root@10.47.138.152:/www/app_images/$app/
	echo 完成===$app===uploads图片复制 
done
