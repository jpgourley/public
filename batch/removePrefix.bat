@echo off & SetLocal EnableExtensions EnableDelayedExpansion

REM Jason Gourley
REM Windows Batch Remove File Prefix

REM CLA 1 == Current Prefix
REM CLA 2 == Delimeter
REM CLA 3 == "-s" for sub-directories

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

ECHO Removing Prefix "%1"%2"
	
if "%4"  == "-s" (
	ECHO in all subfolders
	REM replace sub directories
	CALL :subDirectories %1 %2 %3
	REM replace root directory
	CALL :replaceNames %1 %2 %3
	EXIT /b
	)

CALL :replaceNames %1 %2 %3
GOTO :EOF
	
:replaceNames
	For /F "tokens=1* delims=%2" %%I IN ('dir /a-d /b *.%3') DO (
	IF %%I == %1 (rename "%%~I_%%~J" "%%~J")
	)
	EXIT /B

:batchInfo
	ECHO "removePrefix.bat Prefix Delimeter Extension"
	ECHO Add "-s" as the final argument for all subfolders
	EXIT /B

:subDirectories
	FOR /d %%x IN (*) DO (
		PUSHD %%x
		CALL :subDirectories %1 %2 %3
		CALL :replaceNames %1 %2 %3
		REM CALL :replaceNames %1 %2 %3
		POPD
	)
	EXIT /B
	
:EOF
