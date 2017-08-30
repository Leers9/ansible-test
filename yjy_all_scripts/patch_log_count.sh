#! /usr/bin/env bash
#! 每日定时执行记录前一天接口和ip和状态的数据到数据库供app查询"""
PY_EXE_DIR='/root/scripts/count_uri_by_log.py'
app_name=(pay tcms central pam nursing xiyizhiyeyishi shop)
year=`date +%Y`
month=`date +%m`
month=(08 09 10)
today=`date +%d`
days=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
yearstoday=`echo "($today - 1)" | bc`
a=0
for app in ${app_name[@]}
	do
	for mon in ${month[@]}
    	do
			for d in ${days[@]}
				do
            	echo "正在统计记录"$app $year$mon$d "日志"
            	/usr/bin/python $PY_EXE_DIR $app $year$mon$d
    			done
		done
	done
