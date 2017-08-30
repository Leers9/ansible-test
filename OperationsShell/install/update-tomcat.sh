#!/bin/bash
#$1 tomcat_version $2 tomcat_JAVA_HOME #调用当前shell时需要传入的参数 第一个tomcat版本 这里配置的是7 和8版本，第二个参数是JAVA_HOME
set-e#出错即停止
#update_tomcat() $1=$WD $2=$TOMCAT_V #这个方法需要传的参数
#copy_tomcat() $1=$WD $2=$TOMCAT_V $3=TOMCAT_PROC_PORT
#TOMCAT_PROC_PORT => 对应关系: process_name shutdown_port http1.1_port AJP_port
WORKDIR="/tmp/soft" #tomcat 的输出路径
if [ $# -gt 0 ];then ＃判断当前方法的传值的数量如果是大于0，赋值给n
n=$1
else
read-p"tomcat 大版本号[7\8]:"n ＃读取控制台输入的值，这里就是获取一个tomcat版本号
fi
JAVA_HOME="$2"
JRE_HOME="$3"
DATE=$(date -I) ＃获取一个日期。
WD=$WORKDIR/$DATE
#svn 的用户名密码，为方便tomcat原始版本管理，我把原始版本的tomcat放在svn上。
USER=admin
PASSWD=123456
TOMCAT_DIR=$WORKDIR/$DATE
#TOMCAT_NAME=`ls $TOMCAT_DIR`
REPOS=/repos ＃从svn上check out出来之后先放在这个目录。
TOMCAT_REPOS=/repos/tomcat$n
＃下面三种内存配置是我的环境中需要的三种内存配置
COMMON_OPTS="JAVA_OPTS='-Xms1024M -Xmx1024m -XX:MaxNewSize=128m -XX:MaxPermSize=256m -XX:PermSize=128M'"
MEM_ORDER_ERP_OPTS="JAVA_OPTS='-Xms2048M -Xmx2048m -XX:MaxNewSize=128m -XX:MaxPermSize=256m -XX:PermSize=128M'"
SHOP_OPTS="JAVA_OPTS='-Xms512M -Xmx512m -XX:MaxNewSize=128m -XX:MaxPermSize=256m -XX:PermSize=128M'"
#TOMCAT_PROC_PORT=(base erp ext mem order pos sys wd) 下面我定义了一个数组，解释下 例如base-8100-8101-8183 这个就是一个tomcat的进程以及三个端口的参数，后面会用awk截取出来
TOMCAT_PROC_PORT=(base-8100-8101-8183erp-8102-8103-8186mem-8106-8107-8187order-8108-8109-8185pos-8110-8111-8188sys-8112-8113-8181wd-8114-8115-8190shop-8116-8117-8189vm-8118-8119-8182extdata-8120-8121-8184)
update_tomcat() {
cd $1 ＃切换目录，目录为调用该方法的第一个参数 然后解压，删除tomcat中没用的文件夹或者文件
tar -zxf apache-tomcat-$2.tar.gz
rm -rf $1/apache-tomcat-$2/{LICENSE,NOTICE,RELEASE-NOTES,RUNNING.txt}
rm -rf apache-tomcat-$2/webapps/*
rm -rf ./*.tar.gz
}
copy_tomcat() {
cd $1
local array=$3
for i in ${array[*]}
do
proc=`echo $i |awk -F"-" '{print $1}'` ＃这里是分别一次是获取进程名，用于将不同的tomcat进程修改成对应服务的进程名，tomcat三个端口
shut_port=`echo $i |awk-F"-" '{print $2}'`
http_port=`echo $i |awk-F"-" '{print $4}'`
ajp_port=`echo $i |awk -F"-" '{print $3}'`
cp -rf apache-tomcat-$2$proc-tomcat
#update process
sed -i "s/java$/$proc-tomcat/" $proc-tomcat/bin/setclasspath.sh
#update port 更新tomcat端口 三个端口 ajp端口 http端口 shutdown端口
sed -i "s/8005/$shut_port/g" $proc-tomcat/conf/server.xml
sed -i "s/8009/$ajp_port/g" $proc-tomcat/conf/server.xml
sed -i "s/8080/$http_port/g" $proc-tomcat/conf/server.xml
sed -i "1aexport $JAVA_HOME" $proc-tomcat/bin/setclasspath.sh ＃指定位置插入对应字符串
sed-i "2aexport $JRE_HOME"$proc-tomcat/bin/setclasspath.sh
#update charset 编码设置
if [ $n -eq 7 ];then
sed -i "73s#/>#URIEncoding=\"UTF-8\"&#g" $proc-tomcat/conf/server.xml ＃指定位置并在对应位置后面追加编码
elif [ $n -eq 8 ];then＃这里判断tomcat版本
sed -i "71s#/>#URIEncoding=\"UTF-8\" &#g" $proc-tomcat/conf/server.xml
#update JAVA_OPS 更新jvm内存配置
if [ $proc='erp' -o $proc='mem' -o $proc='order' ];then #判断指定的服务内存设置不同大小
echo "mem-tomcat/erp-tomcat/order-tomcat set JAVA_OPTS is 2048M:"$MEM_ORDER_ERP_OPTS
sed -i "279a$MEM_ORDER_ERP_OPTS" $proc-tomcat/bin/catalina.sh
elif [[ $proc='shop' ]];then
echo "shop-tomcat set JAVA_OPTS is 512M:==>" $SHOP_OPTS
sed -i "279a$SHOP_OPTS" $proc-tomcat/bin/catalina.sh
else
echo "other app mem:" $COMMON_OPTS
sed -i "279a$COMMON_OPTS" $proc-tomcat/bin/catalina.sh
fi
else
sed -i "71,73s#/>#URIEncoding=\"UTF-8\" &#g" $proc-tomcat/conf/server.xml
fi
done
rm -rf apache-tomcat-$2*
}
＃压缩tomcat的方法
tar_tomcat(){
cd $TOMCAT_DIR
for tar_tomcat in $(ls ./)
do
tar -zcf $tar_tomcat.tar.gz $tar_tomcat
rm -rf $tar_tomcat
done
}
if [ ! -d $TOMCAT_REPOS ];then ＃判断版本库存不存在，不存在创建一个
mkdir -p $TOMCAT_REPOS
fi
echo $DATE
if[ ! -d $WORKDIR ];then
mkdir -p $WORKDIR
fi
cd $WORKDIR
if [ ! -d $DATE ];then
mkdir $DATE
echo $DATE > $WORKDIR/record
fi
TOMCAT_NAME=`ls $TOMCAT_DIR`
cd $REPOS
if [ $(ls -al $TOMCAT_REPOS | grep svn|wc -l) -eq 0 ];then ＃从svn傻姑娘check out 或者 update
svn co http://192.168.0.91/repos/soft/tomcat$n--username=$USER--password=$PASSWD
else
#svn update http://192.168.0.91/repos/soft/tomcat$n --username=$USER --password=$PASSWD
cd tomcat$n
svn update
fi
if [ $? -eq 0 ];then
cd $WORKDIR/$DATE
line=`ls $TOMCAT_REPOS | sed 's/.tar.gz//'`
TOMCAT_V=${line:14:6} ＃截取tomcat版本号
rm -rf apache-tomcat-*
cp -f $TOMCAT_REPOS/apache-tomcat-$TOMCAT_V.tar.gz $WD
＃方法调用
update_tomcat $WD $TOMCAT_V
copy_tomcat $WD $TOMCAT_V" ${TOMCAT_PROC_PORT[*]}"
tar_tomcat $WD
fi
cd $WORKDIR
rm -rf latest
cp -rf $DATE latest
