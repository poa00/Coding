REM ------------------------------------------------------------
REM
REM	cmd - IF, ELSE (conditionals in batch files)
REM
REM ------------------------------------------------------------


REM
REM General syntax
REM

If (condition) (do_something) ELSE (do_something_else)


REM ------------------------------------------------------------
REM
REM	Example(s)
REM


REM Example - IF EQUAL
If a==b (ECHO 1) ELSE (ECHO 0)
0   REM Value output by command


REM Example - IF EQUAL
If a==a (ECHO 1) ELSE (ECHO 0)
1   REM Value output by command


REM Example - IF EQUAL + BLOCKS OF CODE WITHIN CONDITIONAL ACTIONS
IF 0==1 (

ECHO 1
ECHO 2
ECHO 3

) ELSE (

ECHO -1
ECHO -2
ECHO -3

)


REM ------------------------------------------------------------
REM
REM Create directory (if it doesn't already exist)
REM

SET "DIRNAME=C:\temp\"
IF NOT EXIST "%DIRNAME%" MKDIR "%DIRNAME%"


REM ------------------------------------------------------------
REM
REM Get the current timestamp in a format with a static character length
REM

SET hour=%time:~0,2%
REM  \*/*\   Datetime with underscores (no spaces, for filenames etc.)
SET dt_underscores_1d_hour=%date:~0,4%-%date:~5,2%-%date:~8,2%_0%time:~1,1%-%time:~3,2%-%time:~6,2% 
SET dt_underscores_2d_hour=%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
if "%hour:~0,1%" == " " (SET dt_spaces=%dt_underscores_1d_hour%) else (SET dt_spaces=%dt_underscores_2d_hour%)
REM  \*/*\   Datetime with spaces, for cleaner viewing
SET dt_spaces_1d_hour=%date:~0,4%-%date:~5,2%-%date:~8,2%T0%time:~1,1%:%time:~3,2%:%time:~6,2% 
SET dt_spaces_2d_hour=%date:~0,4%-%date:~5,2%-%date:~8,2%T%time:~0,2%:%time:~3,2%:%time:~6,2%
if "%hour:~0,1%" == " " (SET dt_spaces=%dt_spaces_1d_hour%) else (SET dt_spaces=%dt_spaces_2d_hour%)
ECHO [%dt_spaces%] CURRENT COMMAND RUNNING ON PC [%hostname%] AS USER [%username%]

ECHO hour = [ %hour% ]
ECHO dt_underscores_1d_hour = [ %dt_underscores_1d_hour% ]
ECHO dt_underscores_2d_hour = [ %dt_underscores_2d_hour% ]
ECHO dt_spaces_1d_hour = [ %dt_spaces_1d_hour% ]
ECHO dt_spaces_2d_hour = [ %dt_spaces_2d_hour% ]


REM ------------------------------------------------------------
REM
REM REG ADD - AutoEndTasks (disable 'This App is Preventing Shutdown or Restart' screen on reboot-shutdown)
REM

IF 1==1 (
  @ECHO OFF
  ECHO.
  ECHO.
  SET KeyName=HKCU\Control Panel\Desktop
  SET ValueName=AutoEndTasks
  SET DataType=REG_SZ
  SET DataValue=1
  REM Note: Use  [ %%a ] if running from within a batch script
  REM Note: Use  [  %a ] if running directly in a CMD terminal
  FOR /F "tokens=* USEBACKQ" %a IN (
  `REG QUERY "%KeyName%" /v "AutoEndTasks" /t "%DataType%" /f "%DataValue%"`
  ) DO (
    SET QUERY_KEY_VAL=%a
  )
  SET ARE_REGEDITS_NEEDED=%QUERY_KEY_VAL:End of search: 1 match(es) found.=NO_REGEDITS_ARE_NEEDED%
  IF "%ARE_REGEDITS_NEEDED%"=="NO_REGEDITS_ARE_NEEDED" (
    ECHO %KeyName%
    ECHO   %ValueName% ^(%DataType%^) - No update^(s^) required - property is already set to "%DataValue%"^
  ) ELSE (
    ECHO %KeyName%
    ECHO   %ValueName% ^(%DataType%^) - Setting to "%DataValue%" ...
    REM REG ADD "%KeyName%" /v "%ValueName%" /t "%DataType%" /d "%DataValue%" /f
  )
  ECHO.
  @ECHO ON
)


REM ------------------------------------------------------------
REM
REM Citation(s)
REM
REM   www.tutorialspoint.com  |  "Batch Script - If/else Statement"  |  https://www.tutorialspoint.com/batch_script/batch_script_if_else_statement.htm
REM
REM ------------------------------------------------------------