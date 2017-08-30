#! /usr/bin/env python
# -*- coding:utf8 -*-
import os,sys
#! /usr/bin/env python
# -*- coding:utf8 -*-
import MySQLdb as mdb 
conn=mdb.connect(host="localhost",user='root',passwd='abcxxx123',db='yjy_zhongyizonghe',unix_socket='/tmp/mysql.sock')
cursor=conn.cursor()

try:
		with open('/root/ff2.txt') as f:
			c = f.readlines()
			for line in c:
				file_size = line.split('\t')[1].split('M')[0]
				media_url = line.split('\t')[0].replace('/data/hls','http://m1.letiku.net')
				new_url = "/".join(media_url.split('/')[:-2]) + '/' + 'aes_' + media_url.split('/')[-2] + '/' + ''.join(media_url.split('/')[-1].split('.')[0]) + '_aes.m3u8' 
				
				#print new_url
		#cursor.execute("select id,media_url,file_size from yjy_im_chat_aes_20170516 where media_url!=''")
		#cursor.execute("select id,media_url,file_size from yjy_im_chat_aes where media_url!='' and media_url not like '%_aes%'")
		#cursor.execute("select id,media_url from yjy_im_chat_aes where media_url!='' and file_size=''")
				sql = "update yjy_im_chat_aes set file_size='%s' where media_url='%s';"%(file_size,new_url)
				print sql
		#datas = cursor.fetchall()
		#for data in datas:
			#print data[1].replace('_aes','').replace('aes_','').replace('http://m1.letiku.net','/data/hls')
			#new_url = "/".join(data[1].split('/')[:-2]) + '/' + 'aes_' + data[1].split('/')[-2] + '/' + ''.join(data[1].split('/')[-1].split('.')[0]) + '_aes.m3u8' 
			#print new_url
			#sql="update yjy_im_chat_aes set media_url = '%s' where media_url='%s' and id=%d;"%(new_url,data[1],data[0])
			#print sql
		cursor.execute(sql)
except mdb.Error,e:
	print e
	conn.rollback()
   	conn.close()
	
