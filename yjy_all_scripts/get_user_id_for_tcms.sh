#!/usr/bin/env bash
## 查询中医综合的指定用户的user_id
nicknames=`cat /root/scripts/nickname.txt`
echo $nicknames
#for nn in $nicknames
#do
#	user_id=`mysqdump "select user_id from yjy_tcms.yjy_user_login where nickname='$nn'" -uroot -pothers_app89` 
#mysqldump -uroot -pothers_app89 yjy_tcms yjy_user_login --where "(user_id,nickname) in (select user_id from yjy_tcms.yjy_user_login where nickname in $nicknames)'" > /root/scripts/res.sql
mysqldump -uroot -pp89 yjy_tcms yjy_user_login --where " nickname in ($nicknames)" --no-create-info > /root/scripts/res.sql
#	echo -e $nn"\t"$user_id
#done
