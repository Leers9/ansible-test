#!/bin/bash
###$1表示svnurl#####

###判断传入的参数#####
if [ -z $1 ] || [ $# -gt 1 ];then
	echo "必须有且仅有1个传入脚本svnrul参数！！！";
	exit 1
fi

WEB_DIR=/www/web
SVN_URL=$1
MYSQL_PORT=`netstat -antp | grep mysqld | grep 0.0.0.0 |awk '{print $4}' | awk -F":" '{print $2}'`
PROJECT_NAME=`echo $SVN_URL | awk -F"/" 'BEGIN{p=1}{for(p;p<=NF;p++){if($p=="examapi"){print $(p+1)}}}'`
DB_USER1=`echo $PROJECT_NAME | awk -F"." '{print $1}'`
LOCAL_IP=`ifconfig | grep "t a" | awk '{if(NR=="1")print $2}' | awk -F":" '{print $2}'`
SVN_VERSION=`cd $WEB_DIR/$PROJECT_NAME/$CONFIG_PHP && svn info | grep "Revision"`
CONFIG_PHP=$WEB_DIR/$PROJECT_NAME/Application/Common/Conf/config.php
REDIS_PORT1=`netstat -antp | grep redis | grep 0.0.0.0 | awk '{print $4}' | awk -F":" '{print $2}'`
CONFIG_LINES=(DB_HOST DB_NAME DB_USER DB_PWD DB_PORT DATA_CACHE_TYPE REDIS_HOST REDIS_PORT)
CACHE_DIRS=`find $WEB_DIR/$PROJECT_NAME -type d -name Runtime`
CRON_DIR=/tools/cron
SYNC_LOG_DIR=/www/sync
PHP_BIN=`which php`
CRON_SH_FILE=$CRON_DIR/"$DB_USER1"_post_batch.sh
CRON_FILE=/var/spool/cron/root
PRO_CRON="*/1 * * * * /bin/bash $CRON_SH_FILE"
NGINX_EXEC_DIR=/usr/local/nginx/sbin
NGINX_VHOST_DIR=/usr/local/nginx/conf/vhost
NEW_VHOST=$NGINX_VHOST_DIR/$DB_USER1.letiku.net.conf
NEW_VHOST_UPSTREAM=$NGINX_VHOST_DIR/upstream.$DB_USER1.letiku.net.conf
MYSQL_PWD=123456
###svn checkout ###
function svn_checkout(){
	if [ ! -d $WEB_DIR ];then
		echo -e "\033[31m  请检查是否存在目录$WEB_DIR\033[0m";
		exit 1
	elif [ ! -d $WEB_DIR/$PROJECT_NAME ];then
		echo -e "\033[31m 程序路径不存在\033[0m";
		echo -e "\033[32m 即将创建该程序目录\033[0m";
		mkdir -p $WEB_DIR/$PROJECT_NAME
	elif [ -d $WEB_DIR/$PROJECT_NAME ];then
		echo -e "\033[31m 已经存在目录该程序目录\033[0m";
		rm -rf $WEB_DIR/$PROJECT_NAME;
		mkdir -p $WEB_DIR/$PROJECT_NAME;
		echo -e "\033[32m 新的程序目录创建成功\033[0m";
	fi

	if [ $? -eq 0 ];then
		svn co  $SVN_URL $WEB_DIR/$PROJECT_NAME  -q --username shiyiguo --password shiyiguo << EOF
p
yes
p 
yes
EOF
	fi
		
	if [ $? -eq 0 ];then
		echo -e "\033[32m 更新成功！！ \033[0m"
		echo -e "\033[32m 当前版本号：！$SVN_VERSION \033[0m"
	else
		echo -e "\033[31m 更新失败！！ \033[0m"
		exit 1;
	fi
}

###修改程序的配置文件config.php#######
modfy_config_php(){
	if [ ! -f $CONFIG_PHP ];then
		echo -e "\033[31m 文件位置错误!!!\033[0m";
		exit 1;
	else
		for config in ${CONFIG_LINES[*]}
		do
			line=`cat $CONFIG_PHP |grep -n "$config" | awk -F":" '{print $1}'`
			echo -e "\033[33m 正在修改第$line行 \033[0m";
			case "$config" in
				DB_HOST)
					sed -ir ''$line's/.*/\t'"'DB_HOST'"' =>  '"'$LOCAL_IP'"',/g' $CONFIG_PHP;;
				DB_NAME)
					sed -ir ''$line's/.*/\t'"'DB_NAME'"' =>  '"'yjy_$DB_USER1'"',/g' $CONFIG_PHP;;
				DB_USER)
					sed -ir ''$line's/.*/\t'"'DB_USER'"' =>  '"'$DB_USER1'"',/g' $CONFIG_PHP;;
				DB_PWD)
					sed -ir ''$line's/.*/\t'"'DB_PWD'"' =>  '"'#GI4qfo7xK11'"',/g' $CONFIG_PHP;;
				DB_PORT)
					sed -ir ''$line's/.*/\t'"'DB_PORT'"' =>  '"'$MYSQL_PORT'"',/g' $CONFIG_PHP;;
				DATA_CACHE_TYPE)
					sed -ir ''$line's/.*/\t'"'DATA_CACHE_TYPE'"' => '"'redis'"',/g' $CONFIG_PHP;;
				REDIS_HOST)
					sed -ir ''$line's/.*/\t'"'REDIS_HOST'"' => '"'127.0.0.1'"',/g' $CONFIG_PHP;;
				REDIS_PORT)
					sed -ir ''$line's/.*/\t'"'REDIS_PORT'"' => '"'$REDIS_PORT1'"',/g' $CONFIG_PHP;;
			esac
		done
		
	fi
	if [ $? -eq 0 ];then
		echo -e "\033[32m config.php 修改完成！！ \033[0m";
	else
		echo -e "\033[31m config.php 修改失败！！ \033[0m";
		exit 1;
	fi	
}
###清除程序缓存######
clear_ThinkPhp_cache(){
	echo -e "\033[33m 开始删除程序缓存目录！！ \033[0m";
	
	for cache in $CACHE_DIRS
	do
		echo -e "\033[33m 正在删除缓存目录$cache/* \033[0m";
		rm -rf $cache/*
		if [ $? -eq 0 ];then
			echo -e "\033[32m 目录Runtime下的缓存文件清理完毕！！！ \033[0m";
			echo -e "\033[33m 正在修改Runtime目录权限！！！ \033[0m";
			chown -R www:www $cache
		else
			echo -e "\033[31m 执行缓存删除出错！！ \033[0m";
			exit 1;
		fi	
	done

	if [ $? -eq 0 ];then
		chown -R www:www $WEB_DIR/$PROJECT_NAME/Uploads
		echo -e "\033[32m cache 和 权限 配置完成！！ \033[0m";
	else
		echo -e "\033[31m cache 和 权限 配置失败！！ \033[0m";
		exit 1;
	fi	
	
}
####定时答题计划任务添加####
add_cron(){
	echo -e "\033[33m 开始添加答题记录定时任务！！ \033[0m";
	
	if [ ! -d $CRON_DIR ];then
		echo -e "\033[31m 没有发现答题同步脚本目录！！ \033[0m";
		mkdir -p $CRON_DIR
		echo -e "\033[32m 成功创建答题同步脚本目录！！ \033[0m";
	elif [ ! -d $SYNC_LOG_DIR ];then
		echo -e "\033[31m 没有发现答题同步日志记录目录！！ \033[0m";
		mkdir -p $SYNC_LOG_DIR
		echo -e "\033[32m 成功创建答题同步日志记录目录！！ \033[0m";
	fi
	
	if [ $? -eq 0 ];then
		echo -e "\033[32m 正在写入计划任务脚本！！ \033[0m";
		echo -e "#!/bin/bash\n $PHP_BIN  $WEB_DIR/$PROJECT_NAME/cron.php Home/Cron/syncAnswer >> $SYNC_LOG_DIR/"$DB_USER1"_cron"$(date +"%Y%m%d")".log" > $CRON_SH_FILE
		chmod +x $CRON_SH_FILE
		echo -e "\033[32m 脚本写入完成，正在测试计划任务脚本！！ \033[0m";
		/bin/bash $CRON_SH_FILE
		if [ $? -eq 0 ];then
			echo -e "\033[32m 测试成功！！ \033[0m";
			echo -e "\033[33m 正在添加到crontab！！ \033[0m";
			echo "$PRO_CRON"  >> $CRON_FILE
			check_cron=`crontab -l | grep $CRON_SH_FILE | wc -l`
			if [ `echo $check_cron | bc`  -gt 0 ];then
				echo -e "\033[32m 已成功添加到crontab！！ \033[0m";
			else
				echo -e "\033[31m 添加到crontab失败了！！ \033[0m";
				exit 1;
			fi 
		else
			echo -e "\033[31m 任务脚本测试失败！！ \033[0m";
			echo -e "\033[31m 请检查cron.php是否提交svn \033[0m";		
		fi
	fi
}
####nginx vhost 域名添加####
add_nginx_vhost(){
	echo "###########正在配置nginx  vhost############"

	if [ -f $NEW_VHOST ];then
        	echo -e "\033[31m 已经存在$NEW_VHOST的文件，现在将它删除！\033[0m"
       		rm -rf $NEW_HOST
        	if [ $? -eq 0 ];then
                	echo -e "\033[32m 删除成功！！\n正在生成新文件\033[0m"
      		fi  
	elif [ -f $NEW_HOST_UPSTREAM ];then
        	echo -e "\033[31m 已经存在$NEW_VHOST_UPSTREAM的文件，现在将它删除！\033[0m"
        	rm -rf $NEW_VHOST_UPSTREAM
        	if [ $? -eq 0 ];then
                	echo -e "\033[32m 删除成功！！\n正在生成新文件\033[0m"
        	fi  
    
	fi

	cp $NGINX_VHOST_DIR/upstream.arch.letiku.net.conf $NEW_VHOST_UPSTREAM
	cp $NGINX_VHOST_DIR/arch.letiku.net.conf $NEW_VHOST

#####修改配置文件######
	if [ $? -eq 0 ];then
        sed -ir 's/arch/'$DB_USER1'/g' $NEW_VHOST_UPSTREAM
        sed -ir 's/arch/'$DB_USER1'/g' $NEW_VHOST
	fi

	find $NGINX_VHOST_DIR -name "*r" |xargs rm -rf 
	if [ $? -eq 0 ];then
        	echo -e "\033[33m 正在检测配置文件写法正确性！！\033[0m";
		$NGINX_EXEC_DIR/nginx -t
	fi 
####显示结果#####
	if [ $? -eq 0 ];then
        	echo -e "\033[32m vhost配置成功！！    \033[0m";
	else
        	echo -e "\033[31m  vhost配置失败！！！ \033[0m";
		echo -e "\033[31m !!!!请检查配置文件错误!!! \033[0m"
		exit 1;
	fi
}

config_mysql(){
	echo -e "\033[33m#########开始配置程序的mysql相关！！#########\033[0m"
	flag=0
	while [ $flag -eq 0 ]
	do
		read -p "请输入从测试库导入的sql文件在本服务器的存放路径:" SQL_PATH
		read -p "请输入从清除sql cache的sql文件在本服务器的存放路径:" SQL_CACHE_PATH
		if [ -z $SQL_PATH ] || [ ! -f $SQL_PATH ] || [ ${SQL_PATH##*.} != "sql"  ];then
			echo "测试库倒入的sql文件不正确请重新输入！！";
		elif [ -z $SQL_CACHE_PATH ] || [ ! -f $SQL_CACHE_PATH ] || [ ${SQL_CACHE_PATH##*.} != "sql"  ];then
			echo "sql缓冲文件不正确请重新输入！！";
		else
			flag=1
		fi
	done
	mysql -uroot -p"$MYSQL_PWD"  <  $SQL_PATH
###开始清理sql cache #####
	if [ $? -eq 0 ];then
		sed -ir 's/arch/'$DB_USER1'/g' $SQL_CACHE_PATH && sed -ir 's/10.26.99.141/'$LOCAL_IP'/g' $SQL_CACHE_PATH && mysql -uroot -p"$MYSQL_PWD"  yjy_"$DB_USER1" < $SQL_CACHE_PATH
	fi
	if [ $? -eq 0 ];then
        	echo -e "\033[32m mysql配置成功！！    \033[0m";
	else
        	echo -e "\033[31m mysql配置失败！！    \033[0m";
		exit 1
	fi
}
main(){
	add_nginx_vhost
	sleep 1
	echo "#########开始svn程序！！#########"
	svn_checkout
	echo "#########即将修改程序配置！！#########"
	sleep 1
	modfy_config_php
	sleep 1
	clear_ThinkPhp_cache
	sleep 1
	add_cron
	#config_mysql
	if [ $? -eq 0 ];then
		sleep 1
		echo -e "\033[33m所有配置都已经配置完毕,即将重新启动nginx服务！！\033[0m"
		$NGINX_EXEC_DIR/nginx -s reload
		if [ $? -eq 0 ];then
			echo -e "\033[32mCongratulations !!!!nginx启动成功！！\033[0m"
		else
			echo -e "\033[31mCongratulations !!!!nginx启动失败！！\033[0m"
			
			
		fi
	fi
}
main

