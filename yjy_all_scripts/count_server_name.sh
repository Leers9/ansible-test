#!/bin/bash
EXEC=nginx
LOCAL_IPS=`ifconfig | grep "t a" | awk '{print $2}'| awk -F":" '{print $2}' | awk BEGIN{RS=EOF}'{if($NR!=NR){gsub(/\n/," ")};print}'`
which $EXEC
if [ ! $? -eq 0 ];then
	echo -e "\[033m 请确认是否安装了$EXEC\[0m";
	exit 1;
fi
EXEC_BIN=`which $EXEC`
BASE_HOME=`ls -l $EXEC_BIN | awk '{print $NF}'`
BIN_HOME=`echo ${BASE_HOME%%$EXEC}`
CONF_HOME=`cd $BIN_HOME && cd .. && pwd`/conf
server_nums=`grep -ir "server_name" $CONF_HOME | awk -F"server_name" '{print $2}' | uniq |  awk BEGIN{RS=EOF}'{gsub(/\n/," ");print}' | awk '{gsub(";"," ");print}' | awk '{print NF}' | uniq`
server_names=`grep -ir "server_name" $CONF_HOME | awk -F"server_name" '{print $2}' | uniq |  awk BEGIN{RS=EOF}'{gsub(/\n/," ");print}' | awk '{gsub(";"," ");print}'`
echo "一共发现$server_nums个域名"
### 将域名写入临时文件 ##
rm -rf /tmp/server_names.txt
for server in $server_names
do
	if [[ $server =~ "letiku.net" ]];then
		for ip in ${LOCAL_IPS[@]}
		do
			ping_rs=`ping -c 1 $server | sed -n '1p' | grep "$ip"`
			#echo $ping_rs
			if [ ! -z "$ping_rs" ];then	
				echo $server >> /tmp/server_names.txt
			fi
		done
	fi
done
local_server_num=`cat /tmp/server_names.txt | wc -l`
echo "属于本机的vhost一共有$local_server_num个"

