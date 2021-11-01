#!/bin/bash
# 该脚本文件所处路径
thisShellFilePath=$(cd "$(dirname "$0")";pwd)
# 需要删除的目录
dictionaries=`find $thisShellFilePath -type d \
              -name '.vscode' \
              -or -name 'build' \
              -or -name 'bin'`
# 如果不为空就删除
if [[ "$dictionaries" != '' ]];then
    oldIFS=$IFS
    IFS=$'\n'
    for dictionary in $dictionaries
    do
        # 输出删除了那些目录
        printf "delete : $dictionary\n"
        rm -rf $dictionary
    done
    IFS=$oldIFS
fi