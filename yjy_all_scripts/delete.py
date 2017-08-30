#! /usr/bin/env python
# -*- coding:utf-8 -*-
""" 
	将转发器每天的接口访问量入库
"""
import requests
import re,time
import os,sys
import MySQLdb as mdb

reload(sys)
sys.setdefaultencoding('utf-8')
db_conn = mdb.connect('localhost','root','abcxxx123','yjy_kouqiangzyys',unix_socket='/tmp/mysql.sock')
cursor = db_conn.cursor()

def main():
	# 插入sql值
	try:
			sql = "show tables;"
			#print sql
			cursor.execute(sql)
			data = cursor.fetchall()
			for d in data:
				sql1 = "truncate table %s;"%(d)
				print sql1
				cursor.execute(sql1)
				db_conn.commit()
				#sys.exit(1)
	except mdb.Error, e:
		print e

if __name__ == '__main__':
	main()
