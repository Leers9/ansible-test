#! /usr/bin/env python
# -*- coding:utf8 -*-
import MySQLdb as mdb
where_file='/root/shell/aes_ssl_media.txt'
out_sql='/root/shell/patch_file_size.sql'
field_file='/root/shell/aes_file_size.txt'
result_file='/root/shell/result.txt'
conn=mdb.connect("localhost",'root','abcxxx','yjy_xiyizhiyeyishi')
cursor=conn.cursor()
f1=open(out_sql,'a+')

with open(result_file) as f:
	for line in f:
		new_media_url = line.split("\t")[0]
		old_media_url=new_media_url.replace('aes_','')
		file_size = line.split("\t")[1].split('M')[0]
		update_media_url_sql="update yjy_im_chat_aes set media_url='%s' where media_url='%s'"%(new_media_url,old_media_url)
		update_file_size_sql="update yjy_im_chat_aes set file_size='%s' where media_url='%s'"%(file_size,new_media_url)
		try:
			print new_media_url,old_media_url
			#cursor.execute(update_media_url_sql)
			#conn.commit()	
			try:
				pass
				#cursor.execute(update_file_size_sql)
				#conn.commit()
			except:
				pass
				#conn.rollback()
				#f1.write(old_media_url)
				#f1.write('\n')
		except:
			pass
			#conn.rollback()
			#f1.write(file_size)
			#f1.write('\n')
		#conn.close()
#f1.close()
