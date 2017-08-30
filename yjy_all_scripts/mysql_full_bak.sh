# !/usr/bin/env bash
# mysqldump 将指定的数据库备份到本机上
# 3组dbip
dbips=(10.27.32.72 10.26.171.89 10.46.164.56)
yesterday=`date -d yesterday +%Y_%m_%d`
#today=`date +%Y_%m_%d`
bak_user=yjy_bak
bak_pass=YJy@back123
con=_
# 备份路径在本机的路径
bak_dir=/www/backup/mysql

# db1主从组库
db_72=(letiku user_answer_sub user_note_sub xiyizonghe examapi examapp mysql)

# db2除西综以外的组库
db_89=(xiyizhiyeyishi yjy_score yjy_tcms yjy_xiyizhulizyys yjy_zabbix yjy_zhongyizyys zjy_political)

# db3支付组库
db_56=(yjy_central letiku.net mysql)

mkdir -p $bak_dir/$yesterday
cd $bak_dir/$yesterday
# 备份db1组
for db1 in ${db_72[@]}
do
	mysqldump -u$bak_user -p$bak_pass -h ${dbips[0]} --database $db1 --default-character-set=utf8 > $db1$con$yesterday.sql
	tar -zcf  $db1$con$yesterday.sql.tar.gz $db1$con$yesterday.sql
	rm -rf $db1$con$yesterday.sql
done

# db2组备份
for db2 in ${db_89[@]}
do
	mysqldump -u$bak_user -p$bak_pass -h ${dbips[1]} --database $db2 --default-character-set=utf8 > $db2$con$yesterday.sql
	tar -zcf  $db2$con$yesterday.sql.tar.gz $db2$con$yesterday.sql
	rm -rf $db2$con$yesterday.sql
done


# db3组备份
for db3 in ${db_56[@]}
do
	mysqldump -u$bak_user -p$bak_pass -h ${dbips[2]} --database $db3 --default-character-set=utf8 > $db3$con$yesterday.sql
	tar -zcf  $db3$con$yesterday.sql.tar.gz $db3$con$yesterday.sql
	rm -rf $db3$con$yesterday.sql
done

# 删除7天以前的备份
find $bak_dir -mtime +3 -name "*.*" -exec rm -rf {} \;
