mount -t nfs 10.46.164.56:/www/web/file/slave.xiyizhiyeyishi.letiku.net /www/web/file/slave.xiyizhiyeyishi.letiku.net
if [ $? -eq 0 ];then
	echo -e "挂载成功！！"
elif
	echo "挂载失败！！"
fi
