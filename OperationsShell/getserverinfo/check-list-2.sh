#!/bin/sh
[ -z $1 ] && echo "usage: sh check-list-2.sh iplist\" " && exit
for svrlist in `grep "^[^#]" $1`
do
echo -e "\033[35;2m>>Check [$svrlist]\033[0m"
remote=`echo $svrlist | awk -F : '{print $2}'`
ssh -q root@$remote "ps -ef | grep -i resin | grep -v grep" > /dev/null
if [ 0 -eq $? ]; then
echo -e " resin OK"
else
echo -e " resin \033[31;2mNO\033[0m"
fi
ssh -q root@$remote "ps -ef | grep httpd | grep -v grep" > /dev/null
if [ 0 -eq $? ]; then
echo -e " httpd OK"
else
echo -e " httpd \033[31;2mNO\033[0m"
fi
:<<REM
ssh -q root@$remote "ps -ef | grep -i mysql | grep -v grep" > /dev/null
if [ 0 -eq $? ]; then
echo -e " mysql OK"
else
echo -e " mysql \033[31;2mNO\033[0m"
fi
REM
ssh -q root@$remote "ps -ef | grep ruby | grep -v grep" > /dev/null
if [ 0 -eq $? ]; then
echo -e " ruby OK"
else
echo -e " ruby \033[31;2mNO\033[0m"
fi
ssh -q root@$remote "ps -ef|grep -i keeplive|grep -v grep" > /dev/null
if [ 0 -eq $? ]; then
echo -e " keeplive OK"
else
echo -e " keeplive \033[31;2mNO\033[0m"
fi
ssh -q root@$remote "ps -ef|grep -i screen|grep -v grep" > /dev/null
if [ 0 -eq $? ]; then
echo -e " screen OK"
else
echo -e " screen \033[31;2mNO\033[0m"
fi
done
