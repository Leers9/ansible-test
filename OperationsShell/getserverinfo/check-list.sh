#!/bin/sh
for i in `cat iplist`
do
mysql=`ssh -A $i -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no "ps -ef | grep mysql | grep -v grep |wc -l"`
screen=`ssh -A $i -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no "ps -ef | grep -i screen | grep -v grep |wc -l"`
resin=`ssh -A $i -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no "ps -ef | grep resin | grep -v grep |wc -l"`
ruby=`ssh -A $i -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no "ps -ef | grep ruby | grep -v grep |wc -l"`
php=`ssh -A $i -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no "ps -ef | grep php | grep -v grep |wc -l"`
httpd=`ssh -A $i -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no "ps -ef | grep httpd | grep -v grep |wc -l"`
keeplive=`ssh -A $i -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no "ps -ef | grep keep | grep -v grep |wc -l"`
[ "$mysql" == "0" ] && [ "$screen" == "0" ] && [ "$resin" == "0" ] && [ "$ruby" == "0" ] && [ "$php" == "0" ] && [ "$httpd" == "0" ] && [ "$keeplive" == "0" ] && echo $i ok || echo $i bad >> /tmp/check_processlist.txt
done
