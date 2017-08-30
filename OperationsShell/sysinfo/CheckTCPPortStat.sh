#!/bin/bash

. ./function.inc

if [ $# -ne 1 ]
then
{
	echo "Need input the port"
	exit 0;
}
fi

output=`Chech_Tcp_Server_Port_Stat $1`

echo $output
