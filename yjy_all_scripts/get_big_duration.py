#!/usr/bin/env python
# -*- coding:utf8 -*-
# 查找时长大于10s的m3u8文件
import os,sys,commands

def get_m3u8_files():
	media_path='/data/hls'
	f_cmd='find ' + media_path + ' -name  "*.m3u8"'
	m3u8_files = (commands.getstatusoutput(f_cmd)[1]).split('\n')
	for file in m3u8_files:
		with open(file) as f:
			contents=f.readlines()
			for content in contents:
				if 'EXTINF' in content:
					duration = content.strip('\n').strip('\t').split(':')[1].strip(',')
					if int(float(duration)) > 25:
						#print duration
						print file
if __name__ == '__main__':
	get_m3u8_files()
