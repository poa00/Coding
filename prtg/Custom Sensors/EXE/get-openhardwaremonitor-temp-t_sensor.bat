@ECHO OFF
SET LOGFILE=C:\ISO\OpenHardwareMonitor\OHW-Current-Temp-T_SENSOR-Max.txt
IF NOT EXIST "%LOGFILE%" (
ECHO :File not found: %LOGFILE%
EXIT 2
) ELSE (
TYPE %LOGFILE%
FOR /F "tokens=* delims=: USEBACKQ" %%a IN ( `TYPE %LOGFILE% ^| FINDSTR "DOWN"` ) DO ( EXIT 2 )
EXIT 0
)