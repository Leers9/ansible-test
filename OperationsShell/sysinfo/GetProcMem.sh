#!/bin/bash

. ./function.inc

if [ $# -ne 2 ]
then
{
	echo "Need the user name and process parameters"
	exit 0;
}
fi

PID=`GetPID $1 $2`

if [ "-$PID" == "-" ]
then
{
    echo "The process is not found"
}
else
{
    mem=`GetMem $PID`

    echo "The usage of memory is $mem M"

    if [ $mem -gt 1600 ]
    then
    {
         echo "The usage of memory is larger than 1.6G"
    }
    else
    {
        echo "The usage of memory is normal"
    }
    fi
}
fi
