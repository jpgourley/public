@echo off & SetLocal EnableExtensions EnableDelayedExpansion

REM Jason Gourley
REM Batch Rename File Prefix


if "%1" == "" (
	echo Missing File Name Arguements
	echo "batchPrefix.bat oldPrefix newPrefix delimeter"
	echo Add "-s" as the final argument for all subfolders
	exit /b
)

if "%2" == "" (
	echo Missing Second Name Arguement
	echo "batchPrefix.bat oldPrefix newPrefix delimeter"
	echo Add "-s" as the final argument for all subfolders
	exit /b
)

if "%3" == "" (
	echo Missing Delimeter Arguement
	echo "batchPrefix.bat oldPrefix newPrefix delimeter"
	echo Add "-s" as the final argument for all subfolders
	exit /b
)

if "%4"  == "-s" (
	
	echo Replacing Prefix "%1"%3 with "%2"%3 in all subfolders
	FOR /d %%x IN (*) DO (
		For /F "tokens=1* delims=%3" %%I IN ('dir /a-d /b') DO (
			if %%I == %1 (rename "%%~I_%%~J" "%2_%%~J")
		)
		pushd %%x
		For /F "tokens=1* delims=%3" %%I IN ('dir /a-d /b') DO (
			if %%I == %1 (rename "%%~I_%%~J" "%2_%%~J")
		)
		popd
	)
	exit /b
)

echo Replacing Prefix "%1"%3 with "%2"%3
For /F "tokens=1* delims=%3" %%I IN ('dir /a-d /b') DO (
	if %%I == %1 (rename "%%~I_%%~J" "%2_%%~J")
)
