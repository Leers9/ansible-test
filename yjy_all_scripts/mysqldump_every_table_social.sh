#! /usr/bin/env bash
# 导出全库的各表的前50条数据
db_host=10.24.203.239
db_user=yjy_bak
conn=_
db_password=YJy@back123
back_dir=/www/backup/tables_very_social
mkdir -p $back_dir
cur_time=`date +%Y%m%d%H%M%S`
all_dbs=(yjy_edu yjy_human yjy_justice yjy_lawmaster yjy_pharmic yjy_psychology yjy_xiyizhiyeyishi yjy_xiyizonghe yjy_zhiyeyishi yjy_zhongyizonghe zjy_political)
cd $back_dir
for((i=0;i<${#all_dbs[@]};i++));
do
tables=`mysql -u$db_user -p$db_password -h $db_host -e "show tables;" ${all_dbs[$i]}`
	for table in ${tables[@]}
	do
		if [[ ! $table =~ 'Table' ]];then
			mysqldump -h $db_host -u$db_user -p$db_password  ${all_dbs[$i]} $table --default-character-set=utf8  > ./$cur_time$conn${all_dbs[$i]}$conn$table.sql
			echo "正在备份数据" ${all_dbs[$i]} "中的 "$table "表"
		fi
	done
	tar -zcvf ./$cur_time$conn${all_dbs[$i]}$connall$connsql.tar.gz ./*.sql
	rm -rf ./*.sql
done
# 保留1天每一天一次备份
find ./ -mtime +1 | xargs rm -rf
