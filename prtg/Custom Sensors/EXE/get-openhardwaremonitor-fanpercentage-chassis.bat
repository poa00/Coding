@ECHO OFF
SET LOGFILE=C:\ISO\OpenHardwareMonitor\OHW-Current-FanPercentage-Chassis-Max.txt
IF NOT EXIST "%LOGFILE%" (
ECHO :DOWN
EXIT 1
) ELSE (
TYPE %LOGFILE%
FOR /F "tokens=* delims=: USEBACKQ" %%a IN ( `TYPE %LOGFILE% ^| FINDSTR "DOWN"` ) DO ( EXIT 1 )
EXIT 0
)