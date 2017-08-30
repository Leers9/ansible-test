#! /usr/bin/env bash
# 导出全库的各表的前50条数据
db_host=localhost
db_user=root
conn=_
db_password=others_app89
all_dbs=(all_web_data_history xiyizhiyeyishi yjy_kouqiangzyys yjy_score yjy_tcms yjy_ucenter yjy_xiyizhulizyys yjy_zabbix yjy_zhongyizyys zjy_political)
#all_dbs=(letiku letiku.net qas user_answer_sub user_note_sub xiyizonghe yjy_architecture yjy_central yjy_editor yjy_edu_exam yjy_human yjy_justice yjy_lawmaster yjy_nursing yjy_pclive yjy_pharmic yjy_psychology yjy_servant xiyizhiyeyishi yjy_tcms yjy_xiyizhulizyys yjy_zhongyizyys zjy_political)
#dbs=`mysql -u$db_user -h $db_host -p$db_password -e " show databases "`
#all_dbs=`echo $dbs | awk '{for(i=1;i<=NF;i++)if($i!="Database"&&$i!="information_schema"&&$i!="mysql"&&$i!="performance_schema"){print $i}}'`
#echo $all_dbs
#exit
for((i=0;i<${#all_dbs[@]};i++));
do
	all_tables[$i]=`mysql -u$db_user -h $db_host -p$db_password --database ${all_dbs[$i]} -e " show tables"` 
	tables=`echo ${all_tables[$i]} | cut -d" " -f2-`
	for table in ${tables[@]}
	do
	echo -e 正在导出表数据 ${all_dbs[$i]}$table 
	#mysqldump -u$db_user -p$db_password ${all_dbs[$i]} $table --no-data --default-character-set=utf8  > ./${all_dbs[$i]}.sql
	mysqldump -u$db_user -h $db_host  -p$db_password ${all_dbs[$i]} $table --default-character-set=utf8 --where "1=1 limit 100" > ./${all_dbs[$i]}$conn$table.sql
	sed -i "2c CREATE DATABASE /*!32312 IF NOT EXISTS*/ ${all_dbs[$i]} /*!40100 DEFAULT CHARACTER SET utf8 */;use ${all_dbs[$i]};" ./${all_dbs[$i]}$conn$table.sql
	done
done
tar -zcvf ./all_72.sql.tar.gz ./*.sql
rm -rf ./*.sql
