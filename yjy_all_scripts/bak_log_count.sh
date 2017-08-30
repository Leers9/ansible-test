#! /usr/bin/env bash
#! 每日定时执行记录前一天接口和ip和状态的数据到数据库供app查询"""
PY_EXE_DIR='/root/scripts/count_uri_by_log.py'
app_name=(pay tcms central pam nursing xiyizhiyeyishi shop)
year=`date +%Y`
month=(08 09 10)
a=0
for day in `seq 1 31`
do
	for app in ${app_name[@]}
	do
		for mon in ${month[@]}
		do
			if [ $day -lt 9 ];then
				echo "正在统计记录"$app $year$mon$a$day "日志"
				/usr/bin/python $PY_EXE_DIR $app $year$mon$a$day
			else
				echo "正在统计记录"$app $year$mon$day "日志"
				/usr/bin/python $PY_EXE_DIR $app $year$mon$day
			fi
		done
	done
done
