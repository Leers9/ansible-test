#!/bin/bash

log_files_path="/www/logs/nginx/"

log_files_dir=${log_files_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")

log_files_name=(nginx_error socre.letiku.net tiku.letiku.net passport.letiku.net tcms.letiku.net xiyizhiyeyishi.letiku.net political.letiku.net tcmsq.letiku.net xiyizhulizyys.letiku.net)

save_days=30

mkdir -p $log_files_dir

log_files_num=${#log_files_name[@]}

for((i=0;i<$log_files_num;i++));do
mv ${log_files_path}${log_files_name[i]}.log ${log_files_dir}/${log_files_name[i]}_$(date -d "yesterday" +"%Y%m%d").log
#scp ${log_files_dir}/${log_files_name[i]}_$(date -d "yesterday" +"%Y%m%d").log root@10.45.10.188:/root/logs/
done

#delete 30 days ago nginx log files
#find $log_files_path -mtime +$save_days -exec rm -rf {} \; 

/etc/init.d/nginx reload
