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
    des=`GetDes $PID`

    echo "The number of des is $des"

    if [ $des -gt 900 ]
    then
    {
         echo "The number of des is larger than 900"
    }
    else
    {
        echo "The number of des sis normal"
    }
    fi
}
fi

