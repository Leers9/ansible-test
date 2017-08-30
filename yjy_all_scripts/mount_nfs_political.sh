mount -t nfs 10.46.164.56:/www/web/file/political.letiku.net /www/web/file/political.letiku.net/
if [ $? -eq 0 ];then
	echo -e "挂载成功！"
else
	echo "挂载失败";
fi
