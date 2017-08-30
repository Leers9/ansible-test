#! /usr/bin/env bash
#! 每日定时执行记录前一天接口和ip和状态的数据到数据库供app查询"""
PY_EXE_DIR='/root/scripts/count_uri_by_log.py'
app_name=(pay tcms central pam nursing xiyizhiyeyishi shop)
year=`date +%Y`
month=`date +%m`
today=`date +%d`
yearstoday=`echo "($today - 1)" | bc`
a=0
for app in ${app_name[@]}
    do
        if [ $yearstoday -lt 9 ];then
            echo "正在统计记录"$app $year$month$a$yearstoday "日志"
            /usr/bin/python $PY_EXE_DIR $app $year$month$a$yearstoday
        else
            echo "正在统计记录"$app $year$month$yearstoday "日志"
            /usr/bin/python $PY_EXE_DIR $app $year$month$yearstoday
        fi
    done
