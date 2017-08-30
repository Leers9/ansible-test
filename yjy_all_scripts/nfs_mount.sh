#! /usr/bin/env bash
# 自动挂载nfs并做软连接
webroot_dir=/www/web
nfs_server_dir=/www/image_link
client_link_dir=/www/images
nfs_server=10.47.138.152
date=`date +%Y_%m_%d`

# 8个后端webapp (不包含score,因为score项目暂时没有图片)
apps=(passport tcms xiyizhiyeyishi xiyizhulizyys tmcsq tiku political kouqiangzyys)

# 检查nfs的指定用户www的权限
check_user=`cat /etc/passwd | grep www | awk -F":" '{print $3"\n",$4}'| grep 502 | wc -l`
if [ $check_user -eq 2 ];then
	echo "用户id号合法"
else
	echo "请检查passwd和group文件的www的uid和gid号是否为502"
	exit
fi


for app in ${apps[@]}
# 建立9个挂载目录
do
	mkdir -p $client_link_dir/$app/Uploads
	if [ $? -eq 0 ];then 
		echo "正在挂载"$app项目
		mount -o nolock -t nfs  $nfs_server:$nfs_server_dir/$app/Uploads/  $client_link_dir/$app/Uploads
		# 创建软连接
		if [  -d $webroot_dir/$app.letiku.net/Uploads ];then
			# 初次挂载使用
			 cd $webroot_dir/$app.letiku.net && mv Uploads Uploads_$date
			# 创建软连接
			ln -s $client_link_dir/$app/Uploads $webroot_dir/$app.letiku.net/ && chown -R www:www ./Uploads*
		fi
		if [ $? -eq 0 ];then
			echo $app"项目成功挂载!!!"
		fi
	fi
	mount -o nolock 10.47.138.152:/www/image_link/tcmsq/Uploads/ /www/images/tcmsq/Uploads
done

