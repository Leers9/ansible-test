#!/usr/bin/python
#coding=utf-8

import threading,subprocess
from time import ctime,sleep,time
import Queue
import sys

queue=Queue.Queue()

class ThreadUrl(threading.Thread):
  def __init__(self,queue):
    threading.Thread.__init__(self)
    self.queue=queue

  def run(self):
    while True:
      host=self.queue.get()
      ret=subprocess.call('ping -c 1 -W 1 '+host,shell=True,stdout=open('/dev/null','w'))
      if ret:
        print "%s is down" % host
      else:
        print "%s is up" % host
      self.queue.task_done()

def main():
  for i in range(100):
    t=ThreadUrl(queue)
    t.setDaemon(True)
    t.start()
  for host in b:
    queue.put(host)
  queue.join()

'''
a=[]
with open('ip.txt') as f:
  for line in f.readlines():
    a.append(line.split()[0])
  #print a
'''

b=[sys.argv[1]+str(x) for x in range(1,254)] #ping 192.168.3 网段
start=time()
main()
print "Elasped Time:%s" % (time()-start)

#t2=threading.Thread(target=move,args=('fff',))
#threads.append(t2)

'''
for i in a:
  print ctime()
  ping(i)
  sleep(1)

if __name__ == '__main__':
  for t in range(len(a)):
    #t.setDaemon(True)
    threads[t].start()
    #t.join()
  print "All over %s" % ctime()
'''
