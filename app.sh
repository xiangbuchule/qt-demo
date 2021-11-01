#!/bin/bash

# 程序
applicationName="$1"
# 程序最终文件夹
targetPath="$2"

# 当前命令所处路径
startPath=`pwd`
# 该脚本文件所处路径
thisShellFilePath=$(cd "$(dirname "$0")";pwd)

# 你需要发布的程序名称
if [[ "$applicationName" == '' ]] || [ ! -f "$applicationName" ];then
    printf "$applicationName is not a file\n"
    exit -1
else
    # 进入当前命令所处目录
    cd $startPath
    # 再进入程序目录
    cd $(dirname $applicationName)
    # 获取程序的绝对路径
    applicationPath=`pwd`
    application="$applicationPath/${applicationName##*/}"
fi

# 找到所有需要的库路径
deplist=$(ldd $application | awk '{if (match($3,"/")){printf("%s "),$3}}')

if [[ "$targetPath" == '' ]];then
    # 判断文件夹是否存在
    if [ ! -d "${thisShellFilePath}/target" ];then
        mkdir -p "${thisShellFilePath}/target"
    fi
    target="${thisShellFilePath}/target"
else
    # 判断文件夹是否存在
    if [ ! -d "$targetPath" ];then
        # 进入当前命令所处目录
        cd $startPath
        # 创建目录
        mkdir -p $targetPath
    fi
    # 首先进入当前命令所处目录
    cd $startPath
    # 再进入程序目录
    cd $targetPath
    target=`pwd`
fi

# 回去最开始的目录
cd $startPath

# 复制程序
cp $application $target
# 复制依赖的库
cp $deplist $target