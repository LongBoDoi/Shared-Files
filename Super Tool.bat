@echo off
setlocal EnableDelayedExpansion
chcp 65001

net session >nul 2>&1
if %errorlevel% equ 0 (
	cls
) else (
	cls
	echo Vui lòng chạy lại ứng dụng bằng quyền Administrator.
	pause
	exit
)

taskkill /IM "CUKCUK.exe" /T /F
taskkill /IM "MISA CUKCUK.VN Server.exe" /T /F
taskkill /IM "MISA.QLNH.SERVER.SERVICE.exe" /T /F
taskkill /IM "System Idle Process" /T /F
cls

sc query CUKCUKServerEnterprise > nul 2>&1
if %errorlevel% equ 0 (
	net stop CUKCUKServerEnterprise
	sc delete CUKCUKServerEnterprise
) else (
	echo Không tìm thấy Service CUKCUKServerEnterprise
)

sc query MISASendKitchenService > nul 2>&1
if %errorlevel% equ 0 (
	net stop MISASendKitchenService
	sc delete MISASendKitchenService
) else (
	echo Không tìm thấy Service MISASendKitchenService
)

set "sqlcmd_command=sqlcmd -S ".\MISACUKCUKVN" -U "sa" -P "abcABC123" -Q "DECLARE @dbName NVARCHAR(MAX); DECLARE @sql NVARCHAR(MAX); DECLARE cursorDB CURSOR FOR SELECT name FROM master.dbo.sysdatabases WHERE name LIKE 'CUKCUKENTERPRISE_%%'; OPEN cursorDB FETCH NEXT FROM cursorDB INTO @dbName; WHILE @@FETCH_STATUS = 0 BEGIN SET @sql = 'ALTER DATABASE [' + @dbName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE ' + @dbName + ';'; EXEC sp_executesql @sql; FETCH NEXT FROM cursorDB INTO @dbName; END CLOSE cursorDB; DEALLOCATE cursorDB;" -h -1 -W"

for /f "delims=" %%i in ('%sqlcmd_command%') do (
    echo %%i
)
