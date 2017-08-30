#! /usr/bin/env bash
## 补充临时数据 ####
patch_sqls=`ls /tmp/sub_log/`
patch_dirs=/tmp/sub_log/
sqls=""

for sql in $patch_sqls
do
	echo `cat $patch_dirs$sql`";" >> /root/all.sql
done
	#echo $sql
    #mysql -uroot -h 10.27.32.72 -ptemp@root2016 user_note_sub <  $patch_dirs$sql
    mysql -uroot -h 10.27.32.72 -ptemp@root2016 user_note_sub < /root/all.sql
	if [ $? -eq 0 ];then
		mv $patch_dirs$sql /tmp/sub_notes/
	else
		echo "失败"
	fi

if [ $? -eq 0 ];then
    echo "临时数据导入成功!" >> /root/scripts/patch_pids.txt
fi
