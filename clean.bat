@echo off
::设置当前路径
set nowPath=%cd%
::进入该脚本路径
cd /d %~dp0
::循环查找.vs .vscode bin build目录
for /r /d %%i in (.vs .vscode bin build) do (
    ::判断目录是否存在，存在就输出并删除
    if exist %%i (
        echo delete : "%%i"
        rd /s /q "%%i"
    )
)
::cd还原回去原来的路径
cd /d %nowPath%