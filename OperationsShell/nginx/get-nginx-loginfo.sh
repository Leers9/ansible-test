#!/bin/bash

if [ $# -eq 0 ]; then
   echo "Error: 请指定access.log文件！"
   exit 0
else
   LOG=$1
fi

if [ ! -f $1 ]; then
   echo "Error: 没有找到指定的access.log文件，请输入正确的路径！"
exit 0
fi

####################################################
echo "访问最多的 ip:"
echo "-------------------------------------------"
awk '{ print $1 }' $LOG | sort | uniq -c | sort -nr | head -10
echo
echo
####################################################
echo "在这个时候访问量最多:"
echo "--------------------------------------------"
awk '{ print $4 }' $LOG | cut -c 14-18 | sort | uniq -c | sort -nr | head -10
echo
echo
####################################################
echo "访问最多的页面:"
echo "--------------------------------------------"
awk '{print $11}' $LOG | sed 's/^.*\（.cn*\）\"/\`/g' | sort | uniq -c | sort -rn | head -10
echo
echo
####################################################
echo "在这个时候 这些ip访问最多:"
echo "--------------------------------------------"
awk '{ print $4 }' $LOG | cut -c 14-18 | sort -n | uniq -c | sort -nr | head -10 > timelog

for i in `awk '{ print $2 }' timelog`
do
   num=`grep $i timelog | awk '{ print $1 }'`
   echo " $i $num"
   ip=`grep $i $LOG | awk '{ print $1}' | sort -n | uniq -c | sort -nr | head -10`
   echo "$ip"
   echo
done
rm -f timelog
