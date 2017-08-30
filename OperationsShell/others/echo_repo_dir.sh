#!/bin/bash

#$1 error_pro.text path

text_path=$1
repo_path="/home/git/repositories/"

while read line1 line2 line3 line4 line5 line6 line7
do
    username_short="${line7:1:2}"
    username="${line7%%/*}"
    projectname="${line7##*/}"
    project_dir="$repo_path$username_short/${username##*\'}/${projectname%%\'*}"
    echo $project_dir >> errorpro.txt
done < $text_path
