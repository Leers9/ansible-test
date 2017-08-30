#! /usr/bin/env python
#! -*- coding:utf8 -*-
"""根据项目的日志统计app的pv"""
import MySQLdb as mdb
import os, sys

reload(sys)
sys.setdefaultencoding('utf-8')
db_conn = mdb.connect('127.0.0.1','count','count_user','app_count')
db_conn.ping(True)
cursor = db_conn.cursor()
app = ('pay', 'tcms', 'central', 'pam', 'nursing', 'xiyizhiyeyishi', 'shop')
app_name = ['upstream.' + a + '.letiku.net' for a in app]
days_f = [str(d) for d in range(10,32)]
days = [ '0' +str(d) for d in range(1,10)]
month = ('08', '09', '10')
ng_log_dir = '/www/logs/nginx'
log_files = []
day_pv = dict()

def get_log_files():
	for d in days_f:
		days.append(d)
	for d in days:
		for m in month:
			for app in app_name:
				#day_pv[app] = dict()
				log_file = ng_log_dir + os.sep + '2016' + os.sep + m + os.sep + app + '_' + '2016' + m + d + '.log'
				if os.path.exists(log_file):
					log_files.append(log_file)


def get_day_pv():
	for file in log_files:
		with open(file) as f:
			lines = f.readlines()
			appname = file[(file.find('.')+1):(file.find('letiku.net')-1)]
			if not day_pv.has_key(appname):
				day_pv[appname] = dict()
				day_pv[appname][file[-12:-4]] = len(lines)
			else:
				day_pv[appname][file[-12:-4]] = len(lines)
				

def save_day_pv():
	for dp_k, dp_v in day_pv.items():
		print dp_k, dp_v
		try:
			c_sql = "drop table if exists "+ dp_k+ ";CREATE TABLE `"+ dp_k +"_req_count` (`id` int(11) NOT NULL AUTO_INCREMENT,`appname` varchar(100) NOT NULL,`date` varchar(0) NOT NULL,`req_count` int(11) NOT NULL,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8"
			print c_sql
			cursor.execute(c_sql)
			db_conn.commit()
			for p_k, p_v in dp_v:
				i_sql = "insert into" + dp_k + "_req_count(appname,date,req_count) values (%s,%s,%d)" %(dp_k,p_k,p_v)
				print i_sql
				#cursor.execute(c_sql)
				#db_conn.commit()
		except mdb.Error, e:
			print e
			print "数据保存失败!"
			db_conn.close()


if __name__ == '__main__':
	get_log_files()
	get_day_pv()
	save_day_pv()
