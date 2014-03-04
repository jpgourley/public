@echo off & SetLocal EnableExtensions EnableDelayedExpansion

REM Jason Gourley
REM Windows Batch Rename File Prefix

REM CLA 1 == Prefix to Add
REM CLA 2 == Delimeter
REM CLA 3 == Extension
REM CLA 4 == "-s" for sub-directories

if "%1" == "" (
	ECHO Missing Prefix Name Arguement
	CALL :batchInfo
	GOTO :EOF
	)

if "%2" == "" (
	ECHO Missing Delimeter Arguement
	CALL :batchInfo
	GOTO :EOF
	)

if "%3" == "" (
	ECHO Missing Extension Arguement
	CALL :batchInfo
	GOTO :EOF
	)	
	
if "%4"  == "-s" (
	ECHO Adding Prefix "%1%2" to ".%3" files in all subfolders
	REM replace sub directories
	CALL :subDirectories %1 %2 %3
	REM replace root directory
	CALL :replaceNames %1 %2 %3
	GOTO :EOF
	)
	
ECHO Adding Prefix "%1%2" to ".%3" files
CALL :replaceNames %1 %2 %3
GOTO :EOF
	
:replaceNames
	For /F "delims=" %%I IN ('dir /b /a-d *.%3') DO (
		RENAME "%%~I" "%1%2%%~I"
	)
	EXIT /B

:batchInfo
	ECHO "addPrefix.bat addPrefix delimeter extension"
	ECHO Add "-s" as the final argument for all subfolders
	EXIT /B

:subDirectories
	FOR /d %%x IN (*) DO (
		PUSHD %%x
		CALL :subDirectories %1 %2 %3
		CALL :replaceNames %1 %2 %3
		POPD
	)
	EXIT /B
	
:EOF
