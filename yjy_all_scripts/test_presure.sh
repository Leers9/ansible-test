#! /usr/bin/env bash
#！压力测试

# http://tiku.letiku.net:8026/index.php/Operation/TmpNote/get_batch      批量获取笔记
#get_note_batch=http://tiku.letiku.net:8026/index.php/Operation/TmpNote/get_batch

# http://tiku.letiku.net:8026/index.php/Operation/TmpNote/post_batch    批量提交笔记
#post_note_batch=http://tiku.letiku.net:8026/index.php/Operation/TmpNote/post_batch

# http://tiku.letiku.net:8026/index.php/Operation/TmpAnswer/get_batch      批量获取答题记录
#get_answer_batch=http://tiku.letiku.net:8026/index.php/Operation/TmpAnswer/get_batch 

# http://tiku.letiku.net:8026/index.php/Operation/TmpAnswer/post_batch   批量提交记录
#post_answer_batch=http://tiku.letiku.net:8026/index.php/Operation/TmpAnswer/post_batch

#urls=($get_note_batch $post_note_batch $get_answer_batch $post_answer_batch)
#n_steps=(10 100 500 800 1000 1200 2000 5000 6000 7000 8000 9000 9500 10000)
#n_steps=(5000 6000 8000 10000)
#c_steps=(10 100 500 800 1000 1200 2000 5000 6000 7000 8000 9000 9500 10000)
#split=c_
#d=`date +%Y%m%d`
# 记录该脚本执行的pid
echo $$ > /root/scripts/pid.txt
# 执行php答题记录和笔记分表脚本
cd /www/web/slave.tiku.letiku.net/
#php cron.php Home/TikuScript/delete_all_table
php cron.php Home/TikuScript/my_script
#php cron.php Home/TikuScript/reame_tables

## 补充临时数据 ####
#patch_sqls=`ls /tmp/sub_log/`
#for sql in $patch_sqls
#do
#	mysql -uroot -h 10.27.32.72 -ptemp@root2016 < $sql
#done

#if [ $? -eq 0 ];then
#	echo "临时数据导入成功!" >> /root/scripts/pid.txt
#fi

if [ $? -eq 0 ];then
	echo "分库分表脚本执行完成!" >> /root/scripts/pid.txt
fi

# svn up 分库分表后104的代码数据库连接
#svn up /www/web/slave.tiku.letiku.net/Application/Operation/Controller/NoteController.class.php
#svn up /www/web/slave.tiku.letiku.net/Application/Operation/Controller/AnswerController.class.php


# svn up 分库分表后66的代码数据库连接
#ssh -p 2012 root@10.51.79.194 'svn up /www/web/slave.tiku.letiku.net/Application/Operation/Controller/NoteController.class.php'
#ssh -p 2012 root@10.51.79.194 'svn up /www/web/slave.tiku.letiku.net/Application/Operation/Controller/AnswerController.class.php'

### 记录脚本日志 ###
#if [ $? -eq 0 ];then
#	echo "代码更新完成!" >> /root/scripts/pid.txt
#fi
# 测试结果文本文件存放目录
#if [ ! -d /tmp/$d ];then
#	mkdir -p /tmp/$d
#fi

# 测试
#for n_step in ${n_steps[@]}
#do
#	for c_step in ${c_steps[@]}
#	do
#		if [ $c_step -lt $n_step ];then 
#			for url in ${urls[@]}
#			do	
#				u=`echo $url | awk -F"/" '{print $6_$7}'`
#				echo  " 正在测试链接 " $url  " 请求数 " $n_step " 并发数: " $c_step
#				ab -n $n_step -k -c $c_step $url > /tmp/$d/ab_n$n_step$split$c_step$u.txt 2>&1 
#			done
#		fi
#	done
#done 
