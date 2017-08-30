#! /usr/bin/env bash
# 导出全库的各表的数据
db_host=10.27.32.72
db_user=yjy_bak
conn=_
db_password=YJy@back123
back_dir=/www/backup_every_table
mkdir -p $back_dir
cur_time=`date +%Y%m%d%H%M%S`
all_dbs=(letiku mysql recite user_answer_sub user_note_sub xiyizonghe yjy_ucenter)
cd $back_dir
for((i=0;i<${#all_dbs[@]};i++));
do
tables=`mysql -u$db_user -p$db_password -h $db_host -e "show tables;" ${all_dbs[$i]}`
	for table in ${tables[@]}
	do
		if [[ ! $table =~ 'Table' ]];then
			mysqldump -u$db_user -p$db_password -h $db_host ${all_dbs[$i]} $table --default-character-set=utf8  > ./$cur_time$conn${all_dbs[$i]}$conn$table.sql
			echo "正在备份数据" ${all_dbs[$i]} "中的 "$table "表"
		fi
	done
	tar -zcvf ./$cur_time$conn${all_dbs[$i]}$connall$connsql.tar.gz ./*.sql
	rm -rf ./*.sql
done
# 保留3天每一天一次备份
find ./ -mtime +2 | xargs rm -rf
