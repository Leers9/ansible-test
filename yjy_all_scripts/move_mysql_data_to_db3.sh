#! /usr/bin/env bash
#! 迁移mysql下的整个data文件到db3上
#des_host=10.26.171.89
port=2012
#pass=Yjy@Db123!@#

#/etc/init.d/mysqld stop
#killall mysqld
if [ $? -eq 0 ];then
	ssh  -p $port root@$des_host  "rm -rf /data/* && ls -al /data/"
fi
if [ $? -eq 0 ];then
	scp -rp -P $port /data/* root@$des_host:/data/
fi
if [ $? -eq 0 ];then
	echo "复制完成！！"
	ssh  -p $port root@$des_host  "/etc/init.d/mysqld start"
fi
if [ $? -eq 0 ];then
	scp -rp -P $port /data/* root@$des_host:/data/
fi

