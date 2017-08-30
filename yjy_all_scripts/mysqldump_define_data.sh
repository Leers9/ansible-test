#! /usr/bin/env bash
# 导出全库的各表的前50条数据
db_host=localhost
db_user=root
conn=_
db_password=otherxxs_app89
all_tables=(yjy_user_login yjy_user_0 yjy_user_oauth yjy_unlock)
all_dbs=(yjy_zhongyizyys yjy_tcms)
for((i=0;i<${#all_tables[@]};i++));
do
	for db in ${all_dbs[@]}
	do
	echo -e 正在导出表数据 $db " " ${all_tabless[$i]}
	mysqldump -u$db_user -p$db_password  $db ${all_tables[$i]} --default-character-set=utf8  > ./$db$conn${all_tables[$i]}$conn$table.sql
	done
done
tar -zcvf ./all.sql.tar.gz ./*.sql
rm -rf ./*.sql
