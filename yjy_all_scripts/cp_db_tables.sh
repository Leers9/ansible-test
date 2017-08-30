# !/bin/bash
# 批量复制表到新库
tables=`mysql -e "use yjy_xiyizonghe;show tables" -uroot -pabcxxx123`
for table in ${tables[@]}
do
	c_sql=`mysql -e "use yjy_kouqiangzyys;show create table yjy_xiyizonghe.$table"  -uroot -pabcxxx123 | awk -F"|" '{print $3}'`
	echo $c_sql
	#mysql -e "use yjy_kouqiangzyys;$c_sql"  -uroot -pabcxxx123
	
done
