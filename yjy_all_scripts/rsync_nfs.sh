#!/bin/sh  
source=/www/app_images 
destination=root@10.47.138.72:/www/app_images 
  
inotifywait -mrq -e modify,delete,create,attrib $source | while read D E F  
    do  
        /usr/bin/rsync -ahvzt  $source $destination  
    done 
