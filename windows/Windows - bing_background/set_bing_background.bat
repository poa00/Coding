@ECHO OFF
SETLOCAL enabledelayedexpansion

REM SET DEBUG_STEP_WAIT_SECONDS=5

SET THIS_DIR_SLASH=%~dp0
SET WINDOWS_SCRIPT_HOST=%SYSTEMROOT%\System32\wscript.exe
SET TSTAMP_COMPACT=%date:~-4%%date:~4,2%%date:~7,2%-%time:~0,2%%time:~3,2%%time:~6,2%

SET FILEPATH_EXE=%THIS_DIR_SLASH%runtime\BingBackground.exe
SET FILEPATH_INVIS=%TEMP%\invisible.vbs
REM SET CONTENTS_INVIS=CreateObject^("Wscript.Shell"^).Run """" ^& WScript.Arguments^(0^) ^& """", 0, False>%FILEPATH_INVIS%

IF NOT EXIST %FILEPATH_INVIS% (
	IF DEFINED DEBUG_STEP_WAIT_SECONDS (
		ECHO.
		ECHO  Creating file: %FILEPATH_INVIS%
		TIMEOUT /T %DEBUG_STEP_WAIT_SECONDS%
	)
	ECHO CreateObject^("Wscript.Shell"^).Run """" ^& WScript.Arguments^(0^) ^& """", 0, False>%FILEPATH_INVIS%
) ELSE (
	IF DEFINED DEBUG_STEP_WAIT_SECONDS (
		ECHO.
		ECHO  Skipped file creation ^(already exists^): %FILEPATH_INVIS%
		TIMEOUT /T %DEBUG_STEP_WAIT_SECONDS%
	)
)

IF NOT DEFINED DEBUG_STEP_WAIT_SECONDS (
	START /WAIT %WINDOWS_SCRIPT_HOST% "%FILEPATH_INVIS%" "%FILEPATH_EXE%"
) ELSE (
	ECHO.
	ECHO  Skipped runtime: "%FILEPATH_EXE%"
	TIMEOUT /T %DEBUG_STEP_WAIT_SECONDS%
)

IF DEFINED DEBUG_STEP_WAIT_SECONDS (
	ECHO.
	ECHO  Exiting
	TIMEOUT /T %DEBUG_STEP_WAIT_SECONDS%
)
EXIT
