#!/usr/bin/env bash
# -*- 导出视频业务到线上沙盒服务器
video_dbs=(tcmsq yjy_tcms yjy_zhongyizonghe yjy_xiyizhiyeyishi yjy_xiyizonghe)
for db in ${video_dbs[@]}
do
	mysqldump --database $db -uroot -pabcxxx123 > /$db.sql
done
