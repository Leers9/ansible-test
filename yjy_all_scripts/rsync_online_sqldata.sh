#! /usr/bin/env bash
# 同步最新的表数据和表结构到测试环境
# author 史怡国
# 数据库名称数组
cp_dir=/www/rsync_mysql
year=`date +%Y`
mkdir -p $cp_dir
scp -rp -P 22 root@10.47.138.72:/www/backup/mysql/2017_02_16/* $cp_dir

# 数据sql文件路径数组
sql_files=`cd $cp_dir && ls`

# 数据库名称数组
db_names=`cd $cp_dir && ls | awk -F"_$year" '{print $1}'`

# 批量解压文件并导入恢复到数据库
for sqlfile in $sql_files
do
	echo -e "正在解压#####" $sqlfile "\n"
	sql_name=`tar -zxvf $cp_dir/$sqlfile -C $cp_dir`
	echo -e "正在将数据导入到测试库######" $sqlfile "\n"
	mysql -uroot -pyjy@2016_test --default-character-set=utf8 < $cp_dir/$sql_name
done

# 导入成功后将cp_dir下的数据删除
if [ $? -eq 0 ];then
	rm -rf $cp_dir/*
	echo -e "恭喜.  数据同步完成！！！"
fi
