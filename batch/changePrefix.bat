@echo off & SetLocal EnableExtensions EnableDelayedExpansion

REM Jason Gourley
REM Windows Batch Rename File Prefix

REM CLA 1 == Current Prefix
REM CLA 2 == New Prefix
REM CLA 3 == Delimeter
REM CLA 4 == "-s" for sub-directories

if "%1" == "" (
	ECHO Missing File Name Arguements
	CALL :batchInfo
	GOTO :EOF
	)

if "%2" == "" (
	ECHO Missing Second Name Arguement
	CALL :batchInfo
	GOTO :EOF
	)

if "%3" == "" (
	ECHO Missing Delimeter Arguement	
	CALL :batchInfo
	GOTO :EOF
	)

ECHO Replacing Prefix "%1%3" with "%2%3"
	
if "%4"  == "-s" (
	ECHO In all subfolders
	REM replace sub directories
	CALL :subDirectories %1 %2 %3
	REM replace root directory	
	)

CALL :replaceNames %1 %2 %3
GOTO :EOF
	
:replaceNames
	For /F "tokens=1* delims=%3" %%I IN ('dir /a-d /b') DO (
	IF %%I == %1 (rename "%%~I_%%~J" "%2_%%~J"))
	EXIT /B

:batchInfo
	ECHO "batchPrefix.bat oldPrefix newPrefix delimeter"
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
