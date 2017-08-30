#!/bin/bash
#one key install LAMP or LNMP scripts; apply to apache 2.4.x,mysql 5.6.x,nginx 1.6.x;

. /etc/init.d/functions

#check the results of the command execution

function check_ok(){
  if [ $? -eq 0 ]
   then
     continue
  else
     echo "please check error"
     exit
  fi
}

function yum_update(){
 #set yum repos
 echo "===update yum repos,it will take serval mintinues==="
 yum install wget -y
 mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
 wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo &>/dev/null
 wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo &>/dev/null
 yum clean all &>/dev/null
 yum makecache &>/dev/null
 check_ok
 action  "yum repos update is ok" /bin/true
}

function yum_depend(){
   #install dependencies packages
   yum install wget gcc gcc-c++ make re2c curl curl-devel libxml2 libxml2-devel libjpeg libjpeg-devel libpng libpng-devel libmcrypt libmcrypt-devel zlib zlib-devel openssl openssl-devel freetype freetype-devel gd gd-devel perl perl-devel ncurses ncurses-devel bison bison-devel libtool gettext gettext-devel cmake bzip2 bzip2-devel pcre pcre-devel -y
}

function install_mysql(){
 echo "mysql5.6.25 will be installed,please be patient"
 cd /usr/local/src
 tar -zxf mysql-5.6.25.tar.gz
 cd mysql-5.6.25
 cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data/mysql -DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock -DSYSCONFDIR=/etc -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
 check_ok
 make && make install
 check_ok
  
 useradd -M -s /sbin/nologin mysql
 mkdir -p /data/mysql
 chown -R mysql:mysql /data/mysql/
 chown -R mysql:mysql /usr/local/mysql/
 check_ok
 cd /usr/local/mysql/scripts/
 ./mysql_install_db --basedir=/usr/local/mysql/ --datadir=/data/mysql/ --user=mysql
 check_ok
 /bin/cp /usr/local/mysql/my.cnf /etc/my.cnf
 sed -i '/^\[mysqld\]$/a\user = mysql\ndatadir = /data/mysql\ndefault_storage_engine = InnoDB\n' /etc/my.cnf
 check_ok
  
 cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
 sed -i 's#^datadir=#datadir=/data/mysql#' /etc/init.d/mysqld
 sed -i 's#^basedir=#basedir=/usr/local/mysql#' /etc/init.d/mysqld
 service mysqld start
 chkconfig --add mysqld
 chkconfig mysqld on
 check_ok
  
 iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
 /etc/init.d/iptables save
 check_ok
 echo "export PATH=$PATH:/usr/local/mysql/bin" >>/etc/profile
 source /etc/profile
 check_ok
}

function install_apache(){
 echo "apache2.4.7 will be installed,please be patient"
 cd /usr/local/src
 wget http://mirrors.cnnic.cn/apache/apr/apr-1.5.2.tar.gz
 wget http://mirrors.cnnic.cn/apache/apr/apr-util-1.5.4.tar.gz
 check_ok
 tar zxf apr-1.5.2.tar.gz
 cd apr-1.5.2
 ./configure --prefix=/usr/local/apr
 check_ok
 make && make install
 check_ok
  
 cd /usr/local/src
 tar zxf apr-util-1.5.4.tar.gz
 cd apr-util-1.5.4
 ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
 check_ok
 make && make install
 check_ok
  
 cd /usr/local/src
 tar zxf httpd-2.4.7.tar.gz
 /bin/cp -r apr-1.5.2 /usr/local/src/httpd-2.4.7/srclib/apr
 /bin/cp -r apr-util-1.5.4 /usr/local/src/httpd-2.4.7/srclib/apr-util
 cd httpd-2.4.7
 ./configure --prefix=/usr/local/apache2 --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util/ --with-pcre --enable-mods-shared=most --enable-so --with-included-apr
 check_ok
 make && make install
 check_ok
  
 echo "export PATH=$PATH:/usr/local/apache2/bin" >>/etc/profile
 source /etc/profile
 check_ok
  
 iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
 /etc/init.d/iptables save
 check_ok
 /usr/local/apache2/bin/apachectl
 check_ok
}

function install_php(){
 echo "php5.6.8 will be installed,please be patient"
 cd /usr/local/src
 tar zxf php-5.6.8.tar.gz
 cd php-5.6.8
 ./configure   --prefix=/usr/local/php   --with-apxs2=/usr/local/apache2/bin/apxs   --with-config-file-path=/usr/local/php/etc   --with-mysql=/usr/local/mysql   --with-libxml-dir   --with-gd   --with-jpeg-dir   --with-png-dir   --with-freetype-dir   --with-iconv-dir   --with-zlib-dir   --with-bz2   --with-openssl   --with-mcrypt   --enable-soap   --enable-gd-native-ttf   --enable-mbstring   --enable-sockets   --enable-exif   --disable-ipv6
 check_ok
 make && make install
 check_ok
  
 cp /usr/local/src/php-5.6.8/php.ini-production /usr/local/php/etc/php.ini
 sed -i 's#^;date.timezone =#date.timezone=Asia/Shanghai#' /usr/local/php/etc/php.ini
 check_ok
  
}

function set_lamp(){
 sed -i '/AddType application\/x-gzip .gz .tgz/a\    AddType application/x-httpd-php .php\n' /usr/local/apache2/conf/httpd.conf
 sed -i 's#index.html#index.html index.php#' /usr/local/apache2/conf/httpd.conf
 sed -i '/#ServerName www.example.com:80/a\ServerName localhost:80\n' /usr/local/apache2/conf/httpd.conf
 check_ok
cat >>/usr/local/apache2/htdocs/test.php<<EOF
<?php
echo "PHP is OK\n";
?>
EOF

 /usr/local/apache2/bin/apachectl graceful
 check_ok
 curl localhost/test.php
 check_ok
 action "LAMP is install success" /bin/true
}

function install_phpfpm(){
 echo "php5.6.8 will be installed,please be patient"
 useradd -s /sbin/nologin php-fpm
 cd /usr/local/src
 tar zxf php-5.6.8.tar.gz
 cd php-5.6.8
 ./configure --prefix=/usr/local/php-fpm --with-config-file-path=/usr/local/php-fpm/etc --enable-fpm --with-fpm-user=php-fpm --with-fpm-group=php-fpm --with-mysql=mysqlnd  --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd --with-libxml-dir --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-iconv-dir --with-zlib-dir --with-mcrypt --enable-soap --enable-gd-native-ttf --enable-ftp --enable-exif --disable-ipv6 --with-pear --with-curl --enable-bcmath --enable-mbstring --enable-sockets --with-gettext
 check_ok
 make && make install
 check_ok
  
 cp /usr/local/src/php-5.6.8/php.ini-production /usr/local/php-fpm/etc/php.ini
 sed -i 's#^;date.timezone =#date.timezone=Asia/Shanghai#' /usr/local/php-fpm/etc/php.ini
 cd /usr/local/php-fpm/etc/
 mv php-fpm.conf.default php-fpm.conf
 check_ok
  
 cp /usr/local/src/php-5.6.8/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
 chmod 755 /etc/init.d/php-fpm
 chkconfig --add php-fpm
 chkconfig php-fpm on
 service php-fpm start
 check_ok
}

function install_nginx(){
 echo "nginx1.6.2 will be installed,please be patient"
 cd /usr/local/src
 tar zxf nginx-1.6.2.tar.gz
 cd nginx-1.6.2
 ./configure --prefix=/usr/local/nginx --with-pcre --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module
 check_ok
 make && make install
 check_ok
  
 /usr/local/nginx/sbin/nginx
 check_ok
}

function set_lnmp(){
 sed -i '56a\location ~ \.php$ {\n\    root           html;\n\    fastcgi_pass   127.0.0.1:9000;\n\    fastcgi_index  index.php;\n\    fastcgi_param  SCRIPT_FILENAME  /usr/local/nginx/html$fastcgi_script_name;\n\    include        fastcgi_params;\n\}\n' /usr/local/nginx/conf/nginx.conf
 /usr/local/nginx/sbin/nginx -s reload
 check_ok
 echo -e '<?php\n echo "nginx and PHP is OK";\n?>\n' >/usr/local/nginx/html/index.php
 curl localhost/index.php
 check_ok
 action "LNMP is install success" /bin/true
}

function install_lamp(){
 echo "apache 2.4.7 mysql 5.6.24 php5.6.8 will be installed"
 echo "===update yum repos and install dependecies packages,it will take serval mintinues==="
 yum_update
 check_ok
 yum_depend
 check_ok
 install_mysql
 check_ok
 install_apache
 check_ok
 install_php
 check_ok
 set_lamp
}

function install_lnmp(){
 echo "nginx1.6.2 mysql 5.6.24 php5.6.8 will be installed"
 echo "===update yum repos and install dependecies packages,it will take serval mintinues==="
 yum_update
 check_ok
 yum_depend
 check_ok
 install_mysql
 check_ok
 install_phpfpm
 check_ok
 install_nginx
 check_ok
 set_lnmp
}

cat <<EOF
    1:[install LAMP]
    2:[install LNMP]
    3:[exit]
EOF
read -t 10 -p "please input the num you want:" input
case ${input} in
 1)
 install_lamp
 ;;
 2)
 install_lnmp
 ;;
 3)
 exit
 ;;
 *)
 printf "You must input only in {1|2|3}\n"
esac
