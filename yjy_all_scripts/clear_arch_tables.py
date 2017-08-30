#!/usr/bin/env	python
# -*- coding=utf8 -*-
"""clear the mysql database yjy_archtecture tables in aa.txt"""
import	MySQLdb as mdb 
db_conn = mdb.connect("localhost","root","HEkgDDZZ","yjy_human")
cursor = db_conn.cursor()
with open("/root/scripts/clear_human_sql.tables") as f:
	tables = f.readlines()
	print tables
	try:
		for table in tables:
			tb = table.strip()
			print tb
			sql = """TRUNCATE TABLE """+ tb
			cursor.execute(sql)
			data = cursor.fetchall()
			print data
			sql1 = """select * from """+ tb
			cursor.execute(sql1)
			data1 = cursor.fetchall()
			print data1
	except mdb.Error, e:
		print e
db_conn.close()
