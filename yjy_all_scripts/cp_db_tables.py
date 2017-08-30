#! /usr/bin/env python
# -*- coding:utf8 -*-
import os,sys
#! /usr/bin/env python
# -*- coding:utf8 -*-
import MySQLdb as mdb 
conn=mdb.connect(host="localhost",user='root',passwd='abcxxx123',db='tcmsq',unix_socket='/tmp/mysql.sock')
cursor=conn.cursor()

try:
			sql="select id,media_url from yjy_im_chat where media_url like '%_aes%'"
			cursor.execute(sql)
			rs = cursor.fetchall()
			ids = [r[0] for r in rs]
			urls = [r[1].replace('aes_','').replace('_aes','') for r in rs]
			for id in range(0,len(ids)):
				sql1 = "update yjy_im_chat set media_url='%s' where id=%d;"%(urls[id],ids[id])
				print sql1
				#r1 = cursor.execute(sql1)
				#print r1
except:         
    conn.commit()
    conn.rollback()
conn.close()
