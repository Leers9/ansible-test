#!/usr/bin/env  python
# -*- coding=utf8 -*-
"""clear the mysql database yjy_archtecture tables in aa.txt"""
import  MySQLdb as mdb
import os, sys

reload(sys)  
sys.setdefaultencoding('utf-8')
patch_dir = '/tmp/sub_log/'
#db_conn = mdb.connect("10.27.32.72","root","temp@root2016","user_note_sub",charset="utf8")
db_conn = mdb.connect(host='10.27.32.72', user='root',passwd='temp@root2016', db='user_note_sub', charset='utf8')
cursor = db_conn.cursor()
sql_files = os.listdir(patch_dir)

for file in sql_files:
	with open(patch_dir+file) as f:
			print f
			sql = ''.join(f.readlines()).encode()
			#print sql
			try:
				rows = cursor.execute(sql)
				db_conn.commit()
				data = cursor.fetchall()
				print rows
				cmd = 'mv ' + patch_dir + file + ' /tmp/sub_notes/'
				#cmd = 'rm -rf ' + patch_dir + file
				os.popen(cmd)
			except mdb.Error, e:
				db_conn.rollback()
				print e

db_conn.close()
#cursor.execute(sql)
#data = cursor.fetchall()
#print data
