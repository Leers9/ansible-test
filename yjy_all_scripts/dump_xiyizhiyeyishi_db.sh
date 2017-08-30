#! /bin/bash
db=xiyizhiyeyishi
mysqldump --database ${db} -h 10.46.164.56 -uroot -pCqdXsTPCzvs5R9zP > /www/data/backup/mysql/${db}.sql
