#!/bin/bash

# use with command
#goaccess -f access.log

# nginx log format
#NCSA Combined Log Format

# export with html
goaccess -f access.log -p ~/.goaccessrc -a -m --hour-spec=min > report.html
