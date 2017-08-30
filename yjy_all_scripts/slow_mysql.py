#! /usr/bin/env python
#! -*- coding:utf8 -*-
import json
file = '/www/data/mysql/var/slow-query.log'
contents = dict()
cost_times = []
top_100 = []
json_tops = dict()

def get_content():
	with open(file) as f:
		content = f.read().split("# User@Host:")
		for i in range(2,len(content)):
			query_time =  content[i][content[i].find("Query_time")+12:content[i].find("Lock_time")-2]
			query_id = content[i][content[i].find('Id:')+8:content[i].find('# Query')].strip("\n\r")
			#print "id:",query_id
			#print "时间:",query_time
			query_dbname = '未知';
			if "use" in content[i]:
				query_dbname = content[i][content[i].find("use")+4:content[i].find(';')]
			#print "查询的库名是:",query_dbname
			line = len(content[i].split(";"))
			#print line
			query_sql = content[i].split(";")[line-2].strip("\n")
			#print "sql语句:",query_sql
			cost_times.append((query_id,query_time,query_dbname,query_sql))
	top_100 = sorted(cost_times,key=lambda x:float(x[1]),reverse=True)[0:100]
	return top_100

def get_json_tops():
	top_100 = get_content()
	for t in range(1,len(top_100)):
		json_tops['第'+ str(t) +'耗时:']=dict()
		json_tops['第'+ str(t) +'耗时:']['客户端client:'] = top_100[t][0]
		json_tops['第'+ str(t) +'耗时:']['耗费时长:'] = top_100[t][1]
		json_tops['第'+ str(t) +'耗时:']['查询库名:'] = top_100[t][2]
		json_tops['第'+ str(t) +'耗时:']['sql语句:'] = top_100[t][3]
	print json.dumps(json_tops)
	return json_tops

if __name__ == '__main__':
	get_json_tops()

