#! /usr/bin/env bash
# 统计内存使用率命令行

# 显示前20内存使用率
echo "top 20 mem processes :"
ps aux | sort -k 4 -r | head -20

# 统计总使用内存
actually_mem=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
total_use_mem=`ps aux | sort -k 4 -r | awk '{if($4!="0.0"){print $4}}' | awk 'BEGIN{a=0}{a+=$1}END{print a*10/1000}'`
total_use_mem_rate=`ps aux | sort -k 4 -r | awk '{if($4!="0.0"){print $4}}' | awk 'BEGIN{a=0}{a+=$1}END{print a"%"}'`
actually_use_mem=$(echo "$actually_mem/1024*$total_use_mem"|bc)
#actually_use_mem=$(awk 'BEGIN{print $actually_mem/1024*$total_use_mem_rate}')
echo "物理内存总使用率:" $total_use_mem_rate 
echo "实际使用m:" $actually_use_mem "MB"

