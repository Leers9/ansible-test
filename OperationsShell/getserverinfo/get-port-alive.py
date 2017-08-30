#!/usr/bin/python
# encoding=utf-8
import os
import sys
import socket
 
def check_aliveness(ip, port):
  sk = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sk.settimeout(1)
  try:
    sk.connect((ip,port))
    print 'server %s %s service is OK!' %(ip,port)
    return True
  except Exception:
    print 'server %s %s service is NOT OK!' %(ip,port)
    return False
  finally:
    sk.close()
  return False
   
if __name__=='__main__':
  check_aliveness(sys.argv[1], int(sys.argv[2]))
