#! /usr/bin/env bash
# 自动挂载nfs并做软连接
webroot_dir=/www/web

# 8个后端webapp (不包含score,因为score项目暂时没有图片)
apps=(passport tcms xiyizhiyeyishi xiyizhulizyys tcmsq tiku political score kouqiangzyys)
for app in ${apps[@]}
# 建立8个挂载目录
do
	cd $webroot_dir/$app.letiku.net/
	a=`find ./ -name Runtime`
	for i in $a
	do
		rm -rf $i/*
		chown -R www:www $i
	done
done

