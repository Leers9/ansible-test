#! /usr/bin/env bash
# 为新的视频项目生成配置文件并创建所需要的日志目录临时目录以及存储目录等。。。
# author:史怡国
# 20170227

# 起始判断
project=$1
if [ ! $# -eq 1 ];then
	echo "请输入1个正确的项目名称"
	exit 1
fi

# 配置函数
make_new_config(){
	if [ ! -f /root/shell/config.ini_$project ];then
		cp /root/shell/config.ini /root/shell/config.ini"_"$project
	else
		echo "有重复的配置文件,请检查！"
		exit 1
	fi
	today=`date +%Y%m%d`
	sed -i "s/demo/$project/g" /root/shell/config.ini"_"$project
	sed -i "2s/$project/$project\/$today/g" /root/shell/config.ini"_"$project
	if [ $? -eq 0 ];then
		echo "恭喜,文件生成成功，即将生成目录"
	fi
	all_config_dirs=`cat /root/shell/config.ini_$project | awk -F"=" '{print $2}' | grep -v "^$" | grep -v "^http" | grep -v "^720"`
	
	for dir in $all_config_dirs
	do
		mkdir -p $dir
	done
	
	if [ $? -eq 0 ];then
		echo "恭喜,配置文件修改成功！！"
	fi
}
make_new_config
