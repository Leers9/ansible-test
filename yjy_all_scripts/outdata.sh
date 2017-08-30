#! /bin/bash
# 将mysql中的定点信息统计导出到excel
app_name=(passport political tiku justice api)
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
				echo "正在导出"$app $year$mon$a$day "日志数据"
				echo "select * into outfile '/tmp/$app$year$mon($day)_interface.xls' from $app_log_count_by_inter_$year_$mon_$day"
			fi
		done
	done
done
