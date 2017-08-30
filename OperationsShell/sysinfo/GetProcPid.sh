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
      echo "The process does not exist."
}
else
{
      echo "The process exist."
	  echo "It's id is $PID"
}
fi

