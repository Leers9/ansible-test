# !/usr/bin/env python
# -*- coding=utf-8 -*-
"""传入app类型取得相应日志的acess_log并且统计出一天当中的uri中的接口的调用方式和次数"""
import time, os, sys
import urllib2
import json
import re
import MySQLdb as mdb

reload(sys)
sys.setdefaultencoding('utf-8')
db_conn = mdb.connect('127.0.0.1','count','count_user','app_count')
cursor = db_conn.cursor()
app_name = ''
log_date = ''
NG_LOG_DIR = '/www/data/log/nginx/'
uris = []
ips = []
status_codes = []
ipc = dict()
url_inters = dict()

codes = {
			"200":0,"206":0,"301":0,"302":0,"304":0,"401":0,"403":0,"404":0,"501":0,"502":0,"503":0,"504":0,}

def get_inters():
	with open("interface_uri.txt") as f:
		inters = f.readlines()
		for inter1 in inters:
			inter = inter1.strip("\n")
			url_inters[inter] = 0
			for uri in uris:
				if re.search(inter,uri,re.IGNORECASE):
					url_inters[inter] = url_inters[inter] + 1
	print url_inters
	return url_inters

def save_inter_data():
	c_timestamp = time.time()
	inter_table = app_name + "_" + 'log_count_by_inter' + "_" + year + "_" + month + "_" + day 
	print "正在创建表结构" + inter_table
	try:
		c_inter_sql = "CREATE TABLE if not exists `"+ inter_table +"` (`id` int(11) NOT NULL AUTO_INCREMENT,`interface_name` varchar(100) NOT NULL,`c_time` int(11) NOT NULL,`count` int(11) NOT NULL,PRIMARY KEY (`id`)) ENGINE=InnoDB"
		print c_inter_sql
		cursor.execute(c_inter_sql)
		db_conn.commit()
		for inter,count in url_inters.items():
			i_sql = "insert into " + inter_table + "(interface_name,c_time,count) values('%s',%d,%d)" %(inter,c_timestamp,url_inters[inter])
			print i_sql
			cursor.execute(i_sql)
			db_conn.commit()
	except mdb.Error, e:
		print e
		print "数据保存错误!!"
		db_conn.close()

def get_log_time():
	c_timestamp = time.time()
	th_timestamp = c_timestamp - 2*3600*1000

def get_log_file():
	global app_name, log_date, NG_LOG_DIR
	print "请在命令行传入以下两个参数: %sapp项目名和查询的日期%slog_date(形如architecture 20161011) "%(app_name,log_date)
	
	try:
		app_name = sys.argv[1]
	except Exception, e:
		print "请传入app项目名称"
		print e
	try:
		log_date = sys.argv[2]
	except Exception, e:
		print e

	if log_date != '':
		global year, month, day, NG_LOG_DIR
		year = log_date[:4]
		month = log_date[4:6]
		day = log_date[6:8]
		NG_LOG_DIR = '/www/data/log/nginx/' + year + os.sep + month + os.sep
		log_file = NG_LOG_DIR + "upstream." + app_name + ".letiku.net_"  + log_date + ".log"
	else:
		year = time.strftime("%Y")
		month = time.strftime("%m")
		day = time.strftime("%d")
		log_file = NG_LOG_DIR + "upstream." + app_name + ".letiku.net"  + log_date + ".log"

	try:
		os.path.exists(log_file)
	except Exception, e:
		print "项目名称错误或日志文件不存在!"
	print log_file
	return log_file
	
	
def analyse_log():
	file = get_log_file()
	with open(file) as f:
		lines = f.readlines()
		for line in lines:
			uri = line.split(" ")[6]
			ip = line.split(" ")[0]
			s_code = line.split(" ")[8]
			status_codes.append(s_code)
			uris.append(uri)
			ips.append(ip)		

def count_uri():
	uris = get_uris()
	uris = list(set(uris))
	for uri in uris:
		print uri

def count_status_code():
	for code in status_codes:
		if codes.has_key(code):
			codes[code] = codes[code] + 1
			
def save_ip_data():
	t_ips = []
	for ip in ips:
		if ip not in t_ips:
			t_ips.append(ip)
			ipc[ip] = 0
		else:
			ipc[ip] = ipc[ip] + 1
	iptop_50 = sorted(ipc.iteritems(),key = lambda x:x[1], reverse=True)[:50]
	print iptop_50
	try:
		c_timestamp = time.time()
		db_conn.set_character_set('utf8')
		cursor.execute('SET NAMES utf8;') 
		cursor.execute('SET CHARACTER SET utf8;')
		cursor.execute('SET character_set_connection=utf8;')
   		ip_table = app_name + "_" + 'log_count_by_ip' + "_" + year + "_" + month + "_" + day     
		print "正在创建表结构" + ip_table
		c_ip_sql = "CREATE TABLE if not exists `"+ ip_table +"` (`id` int(100) NOT NULL AUTO_INCREMENT,`ip` varchar(100) NOT NULL,`c_time` int(100) NOT NULL,`count` int(100) NOT NULL,`comment` varchar(100), PRIMARY KEY (`id`)) ENGINE=InnoDB default charset=utf8;"
		cursor.execute(c_ip_sql)
		for ip in iptop_50:
			i_ip_sql = "insert into " + ip_table + "(ip,c_time,count,comment) values('%s',%d,%d,'%s')" %(ip[0],c_timestamp,ip[1],check_ip_location(ip[0]).encode())
			cursor.execute(i_ip_sql)
        	db_conn.commit()
	except mdb.Error, e:
			print "ip数据保存失败！！"
			print e
			db_conn.close()

def check_ip_location(ip):
	ip_inter_url = 'http://ip.taobao.com/service/getIpInfo.php?ip='
	try:
		response = urllib2.urlopen(ip_inter_url + ip, timeout=5)
		result = response.readlines()
		data = json.loads(result[0])
		return "%15s: %s-%s-%s-%s" % (ip,data['data']['country'],data['data']['isp'],data['data']['region'],data['data']['city'])
	except:
		return "%15s: timeout" %ip
	
if __name__ == "__main__":
	analyse_log()
	get_inters()
	#save_inter_data()
	#save_ip_data()

