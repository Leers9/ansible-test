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
NG_LOG_DIR = '/www/logs/nginx/'
uris = []
ips = []
status_and_uri = {}
status_codes = []
ipc = dict()
req_times=[]
url_inters = dict()
bug_uris = []
distinct_bug_uri = []
uri_bytes = []
uri_bytes_and_req_times=[]
uri_all = []
user_agents_android = []
user_agents_ios = []

codes = {
			"200":0,"206":0,"301":0,"302":0,"304":0,"401":0,"403":0,"404":0,"501":0,"502":0,"503":0,"504":0}
error_codes = ['401','403','404','501','502','503','505','504','506']

# 保存每日的bugaccesslog中的数据
def get_inters():
	with open("interface_uri.txt") as f:
		inters = f.readlines()
		for inter1 in inters:
			inter = inter1.strip("\n")
			url_inters[inter] = dict()
			url_inters[inter]['req_byte'] = 0
			url_inters[inter]['count'] = 0
			url_inters[inter]['req_time'] = 0
			url_inters[inter]['error_code_count'] = 0
			#url_inters[inter]['req_byte'] = []
			for uri in uri_all:
				#print uri
				if re.search(inter,uri[0],re.IGNORECASE):
					url_inters[inter]['count'] = url_inters[inter]['count'] + 1
					url_inters[inter]['req_time'] = uri[2]+'s'
					if uri[3] in error_codes:
						url_inters[inter]['error_code_count'] = url_inters[inter]['error_code_count'] + 1
					if int(uri[1]) > url_inters[inter]['req_byte']:
						url_inters[inter]['req_byte'] = uri[1]+'b'
			
	#print url_inters
	return url_inters
# 从json格式中循环保存接口URI,response字节数,请求的request时长,访问该接口最多的独立ip,访问该接口的设备来源，以及访问该接口的5x或4x错误http状态码
def save_inters_data():
		try:
			urt_table = app_name + '_uri_and_req_time' + '_' + year + '_' + month + '_' + day
			c_urt_sql = "CREATE TABLE if not exists`" + urt_table +"`(`id` int(11) NOT NULL AUTO_INCREMENT,`interface` varchar(100) NOT NULL,`byte` varchar(100) NOT NULL,`count` varchar(100) not null,`req_time` varchar(100) NOT NULL, `error_code_count` int not null,PRIMARY KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=utf8"
			print c_urt_sql
			db_conn.ping(True)
			cursor.execute(c_urt_sql)
			db_conn.commit()
			for inter,inter_d in url_inters.items():
				#print inter,inter_d
				i_urt_sql = "insert into " + urt_table + "(interface,byte,count,req_time,error_code_count)values('%s','%s','%s','%s',%d)"%(inter,inter_d['req_byte'],inter_d['count'],inter_d['req_time'],inter_d['error_code_count'])
				print i_urt_sql
				cursor.execute(i_urt_sql)
				db_conn.commit()
		except mdb.Error, e:
			print e
			print "数据保存失败!"
			db_conn.close()
		
#按app类型和时间创建数据表存入重点接口的名称
def save_inter_data():
	c_timestamp = time.time()
	inter_table = app_name + "_" + 'log_count_by_inter' + "_" + year + "_" + month + "_" + day 
	print "正在创建表结构" + inter_table
	try:
		c_inter_sql = "CREATE TABLE if not exists `"+ inter_table +"` (`id` int(11) NOT NULL AUTO_INCREMENT,`interface_name` varchar(100) NOT NULL,`c_time` int(11) NOT NULL,`count` int(11) NOT NULL,PRIMARY KEY (`id`)) ENGINE=InnoDB"
		print c_inter_sql
		db_conn.ping(True)
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

# 资源函数
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
		NG_LOG_DIR = '/www/logs/nginx/' + year + os.sep + month + os.sep
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

# 资源解析函数 	
def analyse_log():
	file = get_log_file()
	with open(file) as f:
		lines = f.readlines()
		for line in lines:
			uri = line.split(" ")[6]
			ip = line.split(" ")[0]
			s_code = line.split(" ")[8]
			byte = line.split(" ")[9]
			user_agent = line.split(" ")[-7:-4]
			#if user_agent 
			#print user_agent
			req_time = line.split(" ")[-1].strip("\n").strip('"')
			req_times.append(req_times)
			uri_bytes.append((uri,byte))
			uri_bytes_and_req_times.append(((uri,byte),req_time))
			uri_all.append((uri,byte,req_time,s_code,user_agent,ip))
			status_codes.append(s_code)
			uris.append(uri)
			ips.append(ip)
			if s_code in error_codes:
				bug_uris.append((s_code,uri))

# 功能函数:将日志中的访问接口和5x等状态码整合存入数据库				
def save_bug_uris():
	try:
		db_conn.set_character_set('utf8')
		cursor.execute('SET NAMES utf8;') 
		cursor.execute('SET CHARACTER SET utf8;')
		cursor.execute('SET character_set_connection=utf8;')
		bug_table = app_name + "_" + year + "_" + month + "_" + day + "_bug_uris" 
		c_bug_sql = 'create table if not exists `' + bug_table + '`(`id` int(11) not null, `inter` varchar(100) not null, `error_codes` varchar(100) not null, primary key(`id`))engine=innodb default charset=utf8'
		print c_bug_sql
		cursor.execute(c_bug_sql)
		db_conn.commit()
		for bug_uri in bug_uris:
			print type(bug_uri[0]),type(bug_uri[1])
			i_bug_sql = "insert into " + bug_table + "(error_codes,uri) values('%s','%s')" %(bug_uri[0],bug_uri[1])
			print i_bug_sql
			cursor.execute(i_bug_sql)
			db_conn.commit()
	except mdb.Error, e:
		print e
		db_conn.close()

def count_status_code():
	for code in status_codes:
		if codes.has_key(code):
			codes[code] = codes[code] + 1

# 功能函数:保存接口访问次数最多的前50ip信息数据			
def save_ip_data():
	t_ips = []
	for ip in ips:
		if ip not in t_ips:
			t_ips.append(ip)
			ipc[ip] = 0
		else:
			ipc[ip] = ipc[ip] + 1
	iptop_50 = sorted(ipc.iteritems(),key = lambda x:x[1], reverse=True)[:50]
	#print iptop_50
	try:
		c_timestamp = time.time()
		db_conn.set_character_set('utf8')
		cursor.execute('SET NAMES utf8;') 
		cursor.execute('SET CHARACTER SET utf8;')
		cursor.execute('SET character_set_connection=utf8;')
		db_conn.ping(True)
   		ip_table = app_name + "_" + 'log_count_by_ip' + "_" + year + "_" + month + "_" + day     
		print "正在创建表结构" + ip_table
		c_ip_sql = "CREATE TABLE if not exists `"+ ip_table +"` (`id` int(100) NOT NULL AUTO_INCREMENT,`ip` varchar(100) NOT NULL,`c_time` int(100) NOT NULL,`count` int(100) NOT NULL,`comment` varchar(100), PRIMARY KEY (`id`)) ENGINE=InnoDB default charset=utf8;"
		cursor.execute(c_ip_sql)
		for ip in iptop_50:
			i_ip_sql = "insert into " + ip_table + "(ip,c_time,count,comment) values('%s',%d,%d,'%s')" %(ip[0],c_timestamp,ip[1],check_ip_location(ip[0]).encode())
			db_conn.ping(True)
			cursor.execute(i_ip_sql)
        	db_conn.commit()
	except mdb.Error, e:
			print "ip数据保存失败！！"
			print e
			db_conn.close()

# 功能函数: ip地址号码归属地查询
def check_ip_location(ip):
	ip_inter_url = 'http://ip.taobao.com/service/getIpInfo.php?ip='
	try:
		response = urllib2.urlopen(ip_inter_url + ip, timeout=5)
		result = response.readlines()
		db_conn.ping(True)
		data = json.loads(result[0])
		return "%15s: %s-%s-%s-%s" % (ip,data['data']['country'],data['data']['isp'],data['data']['region'],data['data']['city'])
	except:
		return "%15s: 未知" %ip
	
if __name__ == "__main__":
	analyse_log()
	get_inters()
	save_inters_data()
	save_ip_data()
	count_status_code()
