#! /usr/bin/env python
# -*- coding:utf8 -*-
import os,sys
import paramiko as pmk
#! /usr/bin/env python
# -*- coding:utf8 -*-
import MySQLdb as mdb 
conn=mdb.connect(host="localhost",user='root',passwd='abcxxx123',db='yjy_xiyizonghe',unix_socket='/tmp/mysql.sock')
cursor=conn.cursor()


def get_param(name):
	if name == 'liuzhongbao':
		chapter_id = '29'
	elif name == 'xuqi':
		chapter_id = '30'
	else:
		print "传参错误！"
		sys.exit(1)
	return [chapter_id,name]

def change_media_url(name):
	medias = []
	chapter_id = get_param(name)[0]
	try:
		cursor.execute("select `id`,`name`,`media_url` from yjy_im_chat_aes where chapter_id="+chapter_id+" and media_url != '';")
		datas = cursor.fetchall()
		dates = []
		for data in datas:
			date = data[2].split('/')[-3]
			original_media = date + '_' + str(dates.count(date)) + '.mp4'
			medias.append(original_media)
			sql="update yjy_im_chat_aes set original_media = '%s' where id=%d;"%(original_media,data[0])
			#print sql
			#cursor.execute(sql)
			conn.commit()
	except mdb.Error,e:
		print e
		conn.rollback()
   		conn.close()
	return medias

def change_file(name):
	name = get_param(name)[1]
	original_medias = change_media_url(name)
	print original_medias
	pmk.util.log_to_file('/tmp/syslogin.log')
	web_dir = '/data/original/zhibo/'
	ssh = pmk.SSHClient()
	ssh.load_system_host_keys()
	ssh.connect(hostname = '10.46.180.21',username = 'root',port=2282)
	for media in original_medias:
		media_date=media.split('_')[0]
		media_dir = web_dir + name + os.sep + media_date + os.sep
		stdin,stdout,stderr = ssh.exec_command('ls ' + media_dir)
		file=media_dir + stdout.read()
		new_file = media_dir + media
		c1 = 'mv ' + file.split('\n')[0] + ' ' + new_file
		stdin,stdout,stderr = ssh.exec_command(c1)
		print stdout.read()
	ssh.close()
	
	

if __name__ == '__main__':
	names = ['liuzhongbao','xuqi']
	for name in names:
		#change_media_url(name)
		change_file(name)
