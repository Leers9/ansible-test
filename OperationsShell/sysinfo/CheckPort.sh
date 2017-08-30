#!/bin/bash

. ./function.inc

if [ $# -ne 1 ]
then
{
	echo "Need input the port"
	exit 0;
}
fi

isListen=`Listening $1`

if [ $isListen -eq 1 ]
then
{
    echo "The port is listening"
}
else
{
    echo "The port is not listening"
}
fi
