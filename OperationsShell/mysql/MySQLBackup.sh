#bin/bash
USERNAME=mysqlbackup
PASSWORD=backupmysql
DATE=`date +%Y-%m-%d`
OLDDATE='date +%Y-%m-%d -d '20 days'`
MYSQL=/usr/local/mysql/bin/mysql
MYSQLDUMP=/usr/local/mysql/bin/mysqldump
MYSQLADMIN=/usr/local/mysql/bin/mysqladmin
SOCKET=/tmp/mysql.sock
BACKDIR=/data/backup/db
[ -d ${BACKUPDIR} ] || mkdir -p &{BACKUPDIR}
[ -d ${BACKUPDIR}/${OLDATE} ] || rm -rf ${BACKUPDIR}/${OLDDATE}
for DBNAME in mysql test report
do
    ${MYSQLDIR} --opt -u${USERNAME} -p${PASSWORD} -S ${SOCKET} ${DBNAME} | gzip > ${BACKUPDIR}/${DATE}/${DBNAME}-backup-${DATE} .sql.gz
    echo "${DBNAME} has been backup successful"
    /bin/sleep 5
done
HOST=192.168.1.2
FTP_USERNAME=dbmysql
FTP_PASSWORD=mysqldb
cd ${BACKDIR}/${DATE}
ftp -i -n -v << !
open ${HOST}
user ${FTP_USERNAME} ${FTP_PASSWORD}
bin
cd ${FTPOLDDATE}
mdelete *
cd ..
rmdir ${FTPOLDDATE}
mkdir ${DATE}
cd ${DATE}
mput *
bye
!
