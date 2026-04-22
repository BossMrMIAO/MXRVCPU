@echo off
rem 解决中文乱码
chcp 65001 > nul  

rem ========== 新增：强制杀死所有Questasim进程 ==========
taskkill /f /im vsim.exe > nul 2>&1
taskkill /f /im vlog.exe > nul 2>&1
taskkill /f /im questasim.exe > nul 2>&1
rem ========== 清理旧文件 ==========
del /f /q wave.vcd vsim.wlf transcript sim.log > nul 2>&1
rmdir /s /q work > nul 2>&1

rem 你的顶层模块名
set TOP_MODULE=rv_core_test_tb  
set WAVE_FILE=wave.wlf
set LOG_FILE=sim.log

echo ========================================
echo 开始编译RTL代码...
echo ========================================
rem 编译RTL（-work指定库，-sv支持SystemVerilog，-incdir指定include路径）
vlog -work work -sv -f ./filelist/inc.f -f ./filelist/hdl.f -f ./filelist/hvl.f
if %errorlevel% neq 0 (
    echo 编译失败！查看日志 %LOG_FILE%
    pause
    exit /b 1
)

echo ========================================
echo 开始仿真...
echo ========================================
rem 启动仿真（-voptargs=+acc禁用优化，-wlf指定波形文件，-l指定日志）
vsim -novopt work.%TOP_MODULE% -wlf %WAVE_FILE% -l %LOG_FILE%
if %errorlevel% neq 0 (
    echo 仿真启动失败！查看日志 %LOG_FILE%
    pause
    exit /b 1
)



echo ========================================
echo 加载波形并启动仿真...
echo ========================================
rem 执行TCL指令：加载波形文件+运行仿真+打开波形窗口
do wave.do
run -all  rem 运行所有仿真时间
view wave  rem 打开波形窗口

echo 仿真完成！波形文件：%WAVE_FILE%
pause