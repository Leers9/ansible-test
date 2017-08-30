#!/bin/sh
ROOT_DIR="/opt/software/"
DATE=`date +%Y%m%d`
alias cp='cp'
LOG="${ROOT_DIR}${DATE}_log"
[ ! -d /data/ ] && echo -e "\E[1;31m THERE IS NO '/data' \E[0m"| tee -a $LOG && exit 1
[ ! -d /opt/software ] && echo -e "\E[1;31m THERE IS NO '/opt/software' \E[0m" | tee -a $LOG && exit 1
echo "[$DATE --- START INSTALL LOCAL ]" | tee -a $LOG
function install_apache(){
cd ${ROOT_DIR};
tar -zxf httpd-2.2.11.tar.gz ;
cd httpd-2.2.11 ; ./configure --prefix=/usr/local/apache --enable-so --enable-rewrite -with-mpm=prefork --enable-ssl > $ROOT_DIR/apaconfig.log 2>&1 && echo -e "\E[1;32mConfigure HTTP OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mERROR: Configure HTTP ERROR ..... \E[0m" | tee -a $LOG ;
echo -e "\E[1;31m ready to make httpd ................... \E[0m"
sleep 5 ;
make clean > /dev/null 2>&1 && make > $ROOT_DIR/apamake.log 2>&1 && make install >> $ROOT_DIR/apamake.log 2>&1 && echo -e "\E[1;32mInstall HTTP OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mERROR:Install HTTP Error ..... \E[0m" |tee -a $LOG ;
mkdir -p /data/logs
mkdir -p /data/www
cp ${ROOT_DIR}config/index.php /data/www/
cp ${ROOT_DIR}config/httpd.conf /usr/local/apache/conf/
cp ${ROOT_DIR}config/httpd-vhosts.conf /usr/local/apache/conf/extra/
echo -e "\E[1;31m[Function] install_apache OK \n\E[0m" | tee -a $LOG
}
function install_rsync(){
cp -a ${ROOT_DIR}config/rsyncd.conf /etc/rsyncd.conf ;
cp -a ${ROOT_DIR}config/rsync.passwd /etc/rsync.passwd ;
chmod 600 /etc/rsync.passwd ;
rsync --daemon;
count=`ps -efw | grep rsync | grep -v grep | wc -l`
if [ "$count" == "1" ]; then
echo -e "\E[1;32mRsync Start OK ..... \E[0m" | tee -a $LOG
else
echo -e "\E[1;31mERROR: Rsync Start Error ...EXIT.. \E[0m" | tee -a $LOG && exit 1;
fi
echo -e "\E[1;31m[Function] install_rsync OK \n\E[0m" | tee -a $LOG
}
function install_cronolog(){
cd ${ROOT_DIR};
tar xzf cronolog-1.6.2.tar.gz && cd cronolog-1.6.2 && ./configure > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && echo -e "\E[1;32mCronolog Install Done ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mERROR:Cronolog Install Error ..... \E[0m" | tee -a $LOG;
echo -e "\E[1;31m[Function] install_cronolog OK \n\E[0m" | tee -a $LOG
}
function install_php_depend(){
cd ${ROOT_DIR};
tar xzf gettext-0.17.tar.gz && cd gettext-0.17 && ./configure > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && echo -e "\E[1;32mInstall GETTEXT OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mInstall GETTEXT ERROR ..... \E[0m" | tee -a $LOG
cd ${ROOT_DIR};
tar xzf gd-2.0.35.tar.gz && cd gd-2.0.35 && ./configure > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 ; ./configure > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && echo -e "\E[1;32mInstall GD OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mInstall GD ERROR ..... \E[0m" | tee -a $LOG
cd ${ROOT_DIR};
tar xzf libmcrypt-2.5.7.tar.gz && cd libmcrypt-2.5.7 && ./configure > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && echo -e "\E[1;32mInstall libmcrypt OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mInstall libmcrypt ERROR ..... \E[0m" |tee -a $LOG
cd ${ROOT_DIR};
mkdir -p /usr/local/man/man1/
tar xzf jpegsrc.v6b.tar.gz && cd jpeg-6b && ./configure > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && echo -e "\E[1;32mInstall Jpeg OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mInstall Jpeg ERROR ..... \E[0m"| tee -a $LOG
cd ${ROOT_DIR};
tar xjf libpng-1.2.10.tar.bz2 && cd libpng-1.2.10 ;./configure > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && echo -e "\E[1;32mInstall Libpng OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mInstall Libpng ERROR ..... \E[0m" | tee -a $LOG ;
ln -s /usr/lib64/libjpeg.so.62.0.0 /usr/lib/libjpeg.so
echo -e "\E[1;31m[Function] install_php_depend OK \n\E[0m" | tee -a $LOG
}
function install_php(){
cd ${ROOT_DIR};
tar -zxf php-5.2.6.tar.gz ; cp -r ${ROOT_DIR}jpeg-6b/* /opt/software/php-5.2.6/ext/gd/libgd/ ; cd php-5.2.6 ; ./configure --prefix=/usr/local/php --with-mysql --with-apxs2=/usr/local/apache/bin/apxs --with-openssl --with-curl --enable-xml --with-mcrypt --with-ttf --enable-magic-quotes --enable-fastcgi --enable-mbstring --with-iconv --enable-mbstring --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --enable-sysvsem > ${ROOT_DIR}phpconfig.log 2>&1 && echo -e "\E[1;32mConfigure PHP OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mERROR: Configure PHP ERROR ..... \E[0m" |tee -a $LOG;
sleep 5;
make > $ROOT_DIR/phpmake.log 2>&1 && make install > $ROOT_DIR/phpmake.log 2>&1 && echo -e "\E[1;32mPHP Install OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mERROR:PHP Install ERROR ..... \E[0m" | tee -a $LOG;
mkdir /usr/local/php/ext
cp -a ${ROOT_DIR}config/php.ini /usr/local/php/lib/ ;
echo -e "\E[1;31m[Function] install_php OK \n \E[0m" | tee -a $LOG
}
function install_php_memcached(){
cd ${ROOT_DIR};
[ -d "/usr/local/php" ] && tar xzf memcache-2.2.3.tgz && cd memcache-2.2.3 && /usr/local/php/bin/phpize > /dev/null 2>&1 && ./configure -enable-memcache -with-php-config=/usr/local/php/bin/php-config -with-zlib-dir > /dev/null 2>&1 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && echo -e "\E[1;32mPHP_memcached Install OK ..... \E[0m" | tee -a $LOG || echo -e "\E[1;31mPHP_memcached Install ERROR ..... \E[0m" | tee -a $LOG;
cp /usr/local/php/lib/php/extensions/no-debug-non-zts/* /usr/local/php/ext/
echo -e "\E[1;31m[Function] install_php_memcached OK \n\E[0m" | tee -a $LOG
}
install_apache
install_rsync
install_cronolog
install_php_depend
install_php
install_php_memcached
