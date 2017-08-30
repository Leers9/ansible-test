#!/bin/bash

#线上操作记得改全局变量!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
####-------------------- 全局变量 -------------------------begin66####
export mysql_user=root
export mysql_pass='temp@root2016'
export mysql_host='10.27.32.72'

export redis_port='6389'

#-----远程数据库连接信息用于从letiku.net导出数据到letiku里面---104-# 
export remote_mysql_user=root
export remote_mysql_pass='CqdXsTPCzvs5R9zP'
export remote_mysql_host='10.46.164.56'

export web_root=/www/web/slave.tiku.letiku.net/
####---------------------- 全局变量 -------------------------end####

####------1.执行脚本删除上次生成的一百张分表----####
for ((i = 1;i<100;i++)); do
    {
        echo "drop table letiku.y_tmp_user_answer_${i};" | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host}

    }
done

####------------------------------------------------------------------------------------------------------------------####

####-------------------2.执行初始化数据之前删除之前的数据-------------------------------------####
#echo "drop table letiku.y_tmp_question;" | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host}

echo "drop table letiku.y_tmp_user_exam_1;" | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host}
echo "drop table letiku.y_tmp_user_exam_2;" | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host}

#echo "drop table letiku.y_tmp_chapter;" | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host}
#-----------------------------------------------------------------------------------------------#

#-------------------------------------------------------#
#执行文档2.1 至 2.2操作
#2.1初始化临时数据
#1）需要从104数据库letiku.net中将以下数据导出来
#题库与章节对应关系表  =>  y_tmp_question
#用户考试信息表 =>  y_tmp_user_exam_1  y_tmp_user_exam2
#章节与学拉对应关系表   => y_tmp_chapter
#2)  将临时表导入letiku

#------------------2.2暂停题库分析服务------------------#
#注：Todo:停止题库每分钟的分析脚本
#-------------------------------------------------------#  


#----------导出远程数据到本地，从letiku.net---------------------------------------------------------------------------------------------------#
mysqldump -h ${remote_mysql_host} -u ${remote_mysql_user} -p${remote_mysql_pass} letiku.net yjy_user_exam_1 >~/y_tmp_user_exam_1.sql
sed -i 's/yjy_user_exam_1/y_tmp_user_exam_1/' ~/y_tmp_user_exam_1.sql
mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku < ~/y_tmp_user_exam_1.sql > /dev/null

mysqldump -h ${remote_mysql_host} -u ${remote_mysql_user} -p${remote_mysql_pass} letiku.net yjy_user_exam_2 >~/y_tmp_user_exam_2.sql
sed -i 's/yjy_user_exam_2/y_tmp_user_exam_2/' ~/y_tmp_user_exam_2.sql
mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku < ~/y_tmp_user_exam_2.sql > /dev/null
#---------------------------------------------------------------------------------------------------------------------------------------------#



#3.执行第三大步之前删除之前的数据，尤其这一块，上次执行因为没删除数据太多导致更新时间过长
#删除上次分表数据，第一步已经操作过
#删除以前操作过的一些表，重新创建


#------调用php程序去删除一些以前操作过的表------#
cd ${web_root}
php cron.php Home/CronSta/deleteTables
#---------------------------------------------- #


#执行文档3.1至3.5
#3.1分表复制数据
#1）复制数据， 建立索引。
#----------------------------#
cd ${web_root}
php cron.php Home/CronSta/SyncOldData
#-------------------------------------#



#3.2对分表数据更新章节对应关系
#----------------------------#
cd ${web_root}
php cron.php Home/CronSta/SyncDataIndex
#--------------------------------#


#3.3根据章节/用户统计
#a)根据章节/用户进行分组统计到临时表 y_tmp_user_statistics
#--------------------------------------#
php cron.php Home/CronSta/SyncData
#---------------------------------------#


#b)对临时表数据进行二次统计
#执行以下sql
#----------------------------------------------------------------------------#
############echo "ALTER TABLE `y_tmp_user_statistics` ADD INDEX ( `user_id` , `chapter_id` );" | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host}########################
echo " insert into y_user_statistics (user_id, chapter_id, right_num,total_num)  SELECT user_id,chapter_id,sum(right_num) as right_num, sum(total_num) as total_num FROM y_tmp_user_statistics group by user_id,chapter_id " | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku

echo '插入表: y_user_statistics 来自:y_tmp_user_statistics'
#----------------------------------------------------------------------------#


#3.4更新用户考试信息与学科信息
#执行以下SQL
#--------------------------------------------------更新章节信息----------------------------------------#
echo "update y_user_statistics  us, y_tmp_chapter yc set us.subject_id = yc.parent_id where us.chapter_id = yc.chapter_id;"  | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku
echo '更改:y_user_statistics表的学科和章节信息 来自y_tmp_chapter表'


#-----------------------------更新用户信息-------------------------------#
#echo "update  y_user_statistics yu, y_tmp_user_exam_1 ye set yu.now_id=ye.now, yu.target_id=ye.target, yu.exam_time=from_unixtime(ye.exam_time, '%Y') where yu.user_id = ye.user_id;"  | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku
#以前本科院校改成目标院校 儿目标院校改成目标专业
echo "update  y_user_statistics yu, y_tmp_user_exam_1 ye set yu.now_id=ye.target, yu.target_id=ye.target_major, yu.exam_time=from_unixtime(ye.exam_time, '%Y') where yu.user_id = ye.user_id;"  | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku
echo '更新y_user_statistics用户信息来自y_tmp_user_exam_1'

echo "update  y_user_statistics yu, y_tmp_user_exam_2  ye set yu.now_id=ye.target, yu.target_id=ye.target_major, yu.exam_time=from_unixtime(ye.exam_time, '%Y') where yu.user_id = ye.user_id;"  | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku
echo '更新y_user_statistics用户信息来自y_tmp_user_exam_2'

#-----------------------------更新用户信息-------------------------------#



#3.5建立索引
#-----------------------------------执行以下SQL-------------------------------------#
echo " ALTER TABLE y_user_statistics ADD INDEX etsc ( exam_time, target_id , subject_id , chapter_id ) " | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku
echo " ALTER TABLE y_user_statistics ADD INDEX etsu ( exam_time, target_id  , subject_id ,   user_id ) " | mysql -u${mysql_user} -p${mysql_pass} -h${mysql_host} letiku
#------------------------------------------------------------------------------------------------------------#


#清空redis统计key 
redis-cli -p ${redis_port} keys "yjy_statis_user_*" | xargs redis-cli  -p ${redis_port} -i del

redis-cli -p ${redis_port}  keys "yjy_satisfy_index_*" | xargs redis-cli  -p ${redis_port} -i del

redis-cli -p ${redis_port}  keys "yjy_satisfy_right_*" | xargs redis-cli -p ${redis_port} -i  del

redis-cli -p ${redis_port}  keys "yjy_satisfy_total_*" | xargs redis-cli  -p ${redis_port} -i del

redis-cli -p ${redis_port}  keys "yjy_statis_count_*" | xargs redis-cli -p ${redis_port} -i del

redis-cli -p ${redis_port}  keys "*statis_rank_*" | xargs redis-cli -p ${redis_port}  -i del

redis-cli -p ${redis_port}  keys "*statis_zrank_*" | xargs redis-cli -p ${redis_port}  -i del

redis-cli -p ${redis_port}  keys "*statis_user_total_*" | xargs redis-cli -p ${redis_port} -i  del




#----------------3.6按章节统计---------------------#
#cd ${web_root}
#php cron.php Home/CronSta/syncStatisticsData
#--------------------------------------------------#

#---------------------------3.7按学科统计----------#
#cd ${web_root}
#php cron.php Home/CronSta/syncStatisticsData2
#--------------------------------------------------#

#---------------------------3.8按用户统计----------#
#cd ${web_root}
#php cron.php Home/CronSta/syncStatisticsData3
#--------------------------------------------------#

#----------------------3.9初始化排名到redis--------#
#cd ${web_root}
#php cron.php Home/CronSta/syncRedisData
#--------------------------------------------------#

#----------------------3.10更新TOP数据-------------#
#cd ${web_root}
#php cron.php Home/CronSta/syncTopData
#--------------------------------------------------#

#3.11后续操作
#清空临时表
#重命名数据库
#-------------注：3-6到3-11可以通过执行php cron.php Home/CronSta/syncDayData来自动完成。然后手动清空2.1-1中所建立的临时表和分表后的数据。----------#
cd ${web_root}
php cron.php Home/CronSta/syncDayData
#--------------------------------------------------------------------------------------------------------------------------------------------------#
#清除mysql中指定的一些表数据

#echo 






