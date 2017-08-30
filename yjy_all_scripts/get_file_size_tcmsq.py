#! /usr/bin/env python
# -*- coding:utf8 -*-
import os,sys
#! /usr/bin/env python
# -*- coding:utf8 -*-
import MySQLdb as mdb 
conn=mdb.connect(host="localhost",user='root',passwd='abcxxx123',db='tcmsq',unix_socket='/tmp/mysql.sock')
cursor=conn.cursor()

def get_media_url_to_file():
	try:
		cursor.execute("select id,media_url,file_size from yjy_im_chat_aes where media_url!='';")
		datas = cursor.fetchall()
		for data in datas:
			server_url =  data[1].replace('http://media.yijiaoyuan.net:9999','/data/hls').replace('_aes','').replace('aes_','').replace('http://m1.letiku.net','/data/hls')
			#new_url = "/".join(data[1].split('/')[:-2]) + '/' + 'aes_' + data[1].split('/')[-2] + '/' + ''.join(data[1].split('/')[-1].split('.')[0]) + '_aes.m3u8' 
			print server_url
			#sql="update yjy_im_chat_aes set media_url = '%s' where media_url='%s' and id=%d;"%(new_url,data[1],data[0])
			#print sql
			#sys.exit(1)
		#cursor.execute(sql)
	except mdb.Error,e:
		print e
		conn.rollback()
   		conn.close()

def patch_file_size_from_file():
	try:
		with open('/root/xizong.txt') as f:
			c = f.readlines()
			for line in c:
				file_size = line.split('\t')[1].split('M')[0]
				media_url = line.split('\t')[0].replace('/data/hls','http://m1.letiku.net')
				new_url = "/".join(media_url.split('/')[:-2]) + '/' + 'aes_' + media_url.split('/')[-2] + '/' + ''.join(media_url.split('/')[-1].split('.')[0]) + '_aes.m3u8' 
				#print new_url
				
				sql = "update yjy_im_chat_aes set file_size='%s' where media_url='%s';"%(file_size,new_url)
				print sql
		#cursor.execute(sql)
	except mdb.Error,e:
		print e
		conn.rollback()
		conn.close()

if __name__ == '__main__':
	get_media_url_to_file()
	#patch_file_size_from_file()
