#! /usr/bin/env python
#! -*- coding:utf-8 -*- 
""" 每日报表统计:请求数,独立ip请求数,接口访问次数 """
import os, sys, time
import MySQLdb as mdb

db_conn = mdb.connect('127.0.0.1','count','count_user','app_count')
cursor = db_conn.cursor()
inters = []

# 从文本文件interfaces中获取资源数目interface接口列表
def get_inters():
	with open('/root/scripts/interface_uri.txt') as f:
		inters = f.read().split("\n")
	print inters
	try:
		db_conn.
	except mdb.Error, e:
		
	return inters

# 获取前一天的日志的uri的总的请求数 uri_count 
#def 
if __name__ == "__main__":
	get_inters()
