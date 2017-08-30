#!/bin/bash

. ./function.inc

#Whether to monitor the disk space. 0: no,1: yes
IS_MO_SYS_SPACE=1
#Whether to detect the system CPU.0: no,1: yes
IS_MO_SYS_CPU=1
#Interval for monitoring the system: second
S_MO_CHK_INTERVAL=60
#Number of times for continuously monitoring the system.
S_MO_CHK_TIMES=3
#Maximum Usage of the system space
MAX_SYS_SPACE_USE=90
#Maximum CPU usage of the system.
MAX_SYS_CPU_USE=70

Host_Name=`hostname`
CheckDiskDir[0]="/dev"
CheckDiskDir[1]="/boot"


while true
do
{
    if [[ $IS_MO_SYS_SPACE -eq 1 ]]
    then
    {
        C=0
        for CheckDisk in ${CheckDiskDir[@]}
        do
        {
            CheckTime=$S_MO_CHK_TIMES
            while (( CheckTime > 0 ))
            do
            {
                DiskSpaceNum=`GetDiskSpc ${CheckDiskDir[$C]}`
                if [[ "-$DiskSpaceNum" = "-" ]]
                then
                {
                    echo "Diretory(${CheckDiskDir[$C]}) is not exist."
                    break
                }
                fi

                if [ $DiskSpaceNum -le $MAX_SYS_SPACE_USE ]
                then
                {
                    echo "Current DiskSpace[${CheckDiskDir[$C]}] is $DiskSpaceNum%."
                    break
                }
                fi

                echo "Current DiskSpace[${CheckDiskDir[$C]}] $DiskSpaceNum% is more than $MAX_SYS_SPACE_USE%."
                (( CheckTime = CheckTime - 1 ))

                if [ $CheckTime -eq 0 ]
                then
                {
                    echo "continue check $S_MO_CHK_TIMES times but DiskSpace[${CheckDiskDir[$C]}][$DiskSpaceNum%] is more than $MAX_SYS_SPACE_USE% yet." 
                    echo "Send Alarm about the DIsk Space"
                    break
                }
                fi

                sleep $S_MO_CHK_INTERVAL
            }
            done

            ((C+=1))
            continue;
        }
        done
    }
    fi

    if [[ $IS_MO_SYS_CPU -eq 1 ]]
    then
    {
        CheckTime=$S_MO_CHK_TIMES
        while (( CheckTime > 0 ))
        do
        {
            CpuNum=`GetSysCPU`
            if [ $CpuNum -le $MAX_SYS_CPU_USE ]
            then
            {
               echo "Current CPU $CpuNum%."
               break
            }
            fi

            echo "SYSCPU:Current CPU $CpuNum% is more than $MAX_SYS_CPU_USE%."
            (( CheckTime = CheckTime - 1 ))

            if [ $CheckTime -eq 0 ]
            then
            {
               echo "continue check $S_MO_CHK_TIMES times but SYSCPU[$CpuNum%] is more than $MAX_SYS_CPU_USE% yet."
               echo "Send Alarm about the system CPU"
               break
            }
            fi

            sleep $S_MO_CHK_INTERVAL
         }
         done
    }
    fi

    sleep $S_MO_CHK_INTERVAL
}
done
