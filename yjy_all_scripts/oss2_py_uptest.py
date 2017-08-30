#! /usr/bin/env python
#! -*- coding:utf8 -*-
""" aliyujn oss2 python sdk 上传测试测试!!"""
from __future__ import print_function
import oss2
import os,sys

# 初始化oss登录验证
auth = oss2.Auth('LTAIYj7b9Fm1rrH2', '6rWkgQX8yiIDrOY70vcy19EUuHvjW2')

# bucket地区服务对象,可用于线上该地区的bucket列表
#service = oss2.Service(auth,'oss-cn-beijing-internal.aliyuncs.com')

# 所有app模考bucket
#html_bucket = oss2.Bucket(auth, 'oss-cn-beijing-internal.aliyuncs.com', 'mock')

# 所有app图片bucket
imgs_bucket = oss2.Bucket(auth, 'oss-cn-shanghai-internal.aliyuncs.com', 'yijiaoyuan-img')

# 获取oss的版本控制
#print([b.name for b in oss2.BucketIterator(service)])

# 获取bucket的权限控制
#print(imgs_bucket.get_bucket_acl().acl)

###############################
##     以上是初始化程序      ## 
##---------------------------##            
##   以下是oss bucket操作    ##
###############################

# 本地资源路径初始化
apps = ('api.yijiaoyuan.net','passport.letiku.net','score.letiku.net','tcms.letiku.net','tcmsq.letiku.net','tiku.letiku.net','www.letiku.net','xiyizhiyeyishi.letiku.net','xiyizhulizyys.letiku.net','yijiaoyuan.letiku.net','yjy.yijiaoyuan.net')

uploads_dirs = ['/www/web/' + 'test.' + app + '/Uploads' for app in apps]
imgs_bucket_dirs = []
imgs_bucket_files = []
local_res_files= []

# 获取bucket上的文件和目录资源,因为bucket上没有文件夹的概念
def get_res_on_bucket():
	for obj in oss2.ObjectIterator(imgs_bucket,delimiter="/"):
		if obj.is_prefix():
			imgs_bucket_dirs.append(obj)
			print('directory:' + obj.key)
		else:
			print('file:' + obj.key)
			imgs_bucket_files.append(obj)

# 获取要上传的图片的本地res的所有文件的绝对路径
# 文件归类
def getLocalFiles(dir):
    if os.path.exists(dir):
        for res in os.listdir(dir):
            ab_dir = dir+os.sep+res
            #res_uri = ab_dir[ab_dir.find('Uploads'):]
            if os.path.isfile(ab_dir):
               # print(res_uri)
               #if res_uri.endswith('.jpg') or res_uri.endswith('.png'):
                if ab_dir.endswith('.jpg') or ab_dir.endswith('.png'):
                    local_res_files.append(ab_dir)
            if os.path.isdir(ab_dir):
                getLocalFiles(ab_dir)

# 上传文件
def putFileToBucket():
    for file in local_res_files:
        # key: bucket上的名称
        key = file[file.find('Uploads'):]
        result = imgs_bucket.put_object_from_file(key,file,progress_callback=percentage)
        print(result)

# 起始程序
def start(dir):
	for dir in uploads_dirs:
            getLocalFiles(dir)

# 进度条功能
def percentage(consumed_bytes, total_bytes):
	if total_bytes:
		rate = int(100* (float(consumed_bytes)) / (float(total_bytes)))
		print ('\r{0}%'.format(rate),end='')
		sys.stdout.flush()

if __name__ == "__main__":
	#get_res_on_bucket()
	start(uploads_dirs)
        #print(local_res_files)
        putFileToBucket()
