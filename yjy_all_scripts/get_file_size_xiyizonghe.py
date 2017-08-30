#! /usr/bin/env python
# -*- coding:utf8 -*-
import os,sys
#! /usr/bin/env python
# -*- coding:utf8 -*-
import MySQLdb as mdb 
conn=mdb.connect(host="localhost",user='root',passwd='abcxxx123',db='yjy_xiyizonghe',unix_socket='/tmp/mysql.sock')
cursor=conn.cursor()

def get_media_url_to_file():
	try:
		cursor.execute("select `id`,`name`,`media_url` from yjy_im_chat_aes where chapter_id=29 and media_url != '';")
		datas = cursor.fetchall()
		dates = []
		for data in datas:
			#server_url =  data[1].replace('http://media.yijiaoyuan.net:9999','/data/hls').replace('_aes','').replace('aes_','').replace('http://m1.letiku.net','/data/hls')
			#new_url = "/".join(data[1].split('/')[:-2]) + '/' + 'aes_' + data[1].split('/')[-2] + '/' + ''.join(data[1].split('/')[-1].split('.')[0]) + '_aes.m3u8' 
			date = data[2].split('/')[-3]
			orignal_media = date + '_' + str(dates.count(date)) + '.mp4'
			#print server_url
			#print orignal_media
			sql="update yjy_im_chat_aes set orignal_media = '%s' where id=%d;"%(orignal_media,data[0])
			print sql
		cursor.execute(sql)
	except mdb.Error,e:
		print e
		conn.rollback()
   		conn.close()

def patch_file_size_from_file():
	try:
		with open('/root/m_xz.txt') as f:
			c = f.readlines()
			for line in c:
				file_size = line.split('\t')[0].split('M')[0]
				media_url = line.split('\t')[1].replace('/data/hls','http://media.yijiaoyuan.net:9999')
				#print media_url
				new_url = "/".join(media_url.split('/')[:-2]) + '/' + 'aes_' + media_url.split('/')[-2] + '/' + ''.join(media_url.split('/')[-1].split('.')[0]) + '_aes.m3u8' 
				#print new_url
				
				sql = "update yjy_im_chat_aes set file_size='%s' where media_url='%s';"%(file_size,new_url.replace('_aes','').replace('aes_',''))
				print sql
		#cursor.execute(sql)
	except mdb.Error,e:
		print e
		conn.rollback()
		conn.close()

if __name__ == '__main__':
	get_media_url_to_file()
	#patch_file_size_from_file()
