# ------------------------------------------------------------
# 
# 
#    PowerShell.exe -File "${Home}\Documents\GitHub\Coding\prtg\Custom Sensors\EXEXML\get-openhardwaremonitor-readings.ps1"
# 
# 
# ------------------------------------------------------------
#
# PRTG - Parse CSV logs output from "Open Hardware Monitor (e.g. OHW)" (system health monitoring software)
#
# ------------------------------------------------------------
#
# STEP 1) Setup Open Hardware Monitor (OHW)
#  > Download from URL:  https://openhardwaremonitor.org/downloads/
#   > Place OHW's downloaded files into directory "C:\ISO\OpenHardwareMonitor\" (modifiable, below - see variable "$Logfile_Dirname")
#
# ------------------------------------------------------------
#
# STEP 2) Setting-up CSV logging in OHW:
#  > Run OHW
#   > Select "Options" (top)
#    > Select "Log Sensors" (will have a checkmark next to it if actively logging to CSV)
#
# ------------------------------------------------------------
#
# STEP 3) Setup a Scheduled Task to run OpenHardwareMonitor.exe at startup
#
# ------------------------------------------------------------
#
# STEP 4) Setup a Scheduled Task to run this PowerShell script at startup, and repeating every minute
#
# ------------------------------------------------------------
#
# STEP 5) Create a new PRTG Sensor with type "EXE/Script Advanced" which runs a batch file in "../EXE/*.bat" (which target only one of the many sensors' output TXT files, shown below)
#
# ------------------------------------------------------------

$Benchmark = New-Object System.Diagnostics.Stopwatch;
$Benchmark.Reset(); <# Reuse same benchmark/stopwatch object by resetting it #>
$Benchmark.Start();

# ------------------------------------------------------------
#
# Get the Temperature, fan speeds, etc. through Dell's oproprietary config but nt on the 730...Openhardware"'s  OpenHardwareMonitor's logfile (second line is column title, third row is values)
#

$Logfile_Dirname = "C:\ISO\OpenHardwareMonitor";
$Logfile_FullPath = "${Logfile_Dirname}\OpenHardwareMonitorLog-$(Get-Date -UFormat '%Y-%m-%d').csv";

# ------------------------------------------------------------

$Logfile_Basename = "${Logfile_Dirname}\OHW-Current";

$Logfile_Clock_CPU_Core = "${Logfile_Basename}-Clock-CPU-Core";
$Logfile_Clock_GPU_Core = "${Logfile_Basename}-Clock-GPU-Core";
$Logfile_Clock_GPU_Mem = "${Logfile_Basename}-Clock-GPU-Mem";
$Logfile_Clock_GPU_Shad = "${Logfile_Basename}-Clock-GPU-Shad";

$Logfile_FanSpeed_CHA = "${Logfile_Basename}-Fan-Chassis";
$Logfile_FanSpeed_PMP = "${Logfile_Basename}-Fan-Pump";
$Logfile_FanSpeed_RAD = "${Logfile_Basename}-Fan-Radiator";
$Logfile_FanSpeed_SSD = "${Logfile_Basename}-Fan-SSD";

$Logfile_FanPercentage_CHA = "${Logfile_Basename}-FanPercentage-Chassis";
$Logfile_FanPercentage_PMP = "${Logfile_Basename}-FanPercentage-Pump";
$Logfile_FanPercentage_RAD = "${Logfile_Basename}-FanPercentage-Radiator";
$Logfile_FanPercentage_SSD = "${Logfile_Basename}-FanPercentage-SSD";

$Logfile_Load_CPU = "${Logfile_Basename}-Load-CPU";
$Logfile_Load_GPU = "${Logfile_Basename}-Load-GPU";
$Logfile_Load_GPU_Memory = "${Logfile_Basename}-Load-GPU-Memory";

$Logfile_Power_CPU = "${Logfile_Basename}-Power-CPU";
$Logfile_Power_GPU = "${Logfile_Basename}-Power-GPU";

$Logfile_RunDuration = "${Logfile_Basename}-RunDuration";

$Logfile_Temperature_CPU = "${Logfile_Basename}-Temp-CPU";
$Logfile_Temperature_GPU = "${Logfile_Basename}-Temp-GPU";
$Logfile_Temperature_SSD = "${Logfile_Basename}-Temp-SSD";
$Logfile_Temperature_T_SENSOR = "${Logfile_Basename}-Temp-T_SENSOR";

$Logfile_Time_Range = "${Logfile_Basename}-Time";

# $Logfile_XmlOutput_All = "${Logfile_Basename}-All.xml";

# ------------------------------------------------------------

# NVIDIA offers a free EXE utility named "NVIDIA System Management Interface (SMI)" which allows for command-line parameters to specify intended output
$Exe_NVidiaSMI = "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe";

# $CsvHeadersArr = @('Time', 'Fan Control #1', 'Fan Control #2', 'Fan Control #3', 'Fan Control #4', 'Fan Control #5', 'Fan Control #6', 'Fan Control #7', 'CPU VCore', 'Voltage #2', 'AVCC', '3VCC', 'Voltage #5', 'Voltage #6', 'Voltage #7', '3VSB', 'VBAT', 'VTT', 'Voltage #11', 'Voltage #12', 'Voltage #13', 'Voltage #14', 'Voltage #15', 'Temperature #1', 'Temperature #2', 'Temperature #3', 'Temperature #4', 'Temperature #5', 'Temperature #6', 'Fan #1', 'Fan #2', 'Fan #4', 'Fan #6', 'CPU Core #1', 'CPU Core #2', 'CPU Core #3', 'CPU Core #4', 'CPU Core #5', 'CPU Core #6', 'CPU Total', 'CPU Package', 'Bus Speed', 'CPU Core #1', 'CPU Core #2', 'CPU Core #3', 'CPU Core #4', 'CPU Core #5', 'CPU Core #6', 'CPU Package', 'CPU CCD #1', 'CPU Core #1', 'CPU Core #2', 'CPU Core #3', 'CPU Core #4', 'CPU Core #5', 'CPU Core #6', 'CPU Cores', 'Memory', 'Used Memory', 'Available Memory', 'GPU Core', 'GPU Core', 'GPU Memory', 'GPU Shader', 'GPU Core', 'GPU Frame Buffer', 'GPU Video Engine', 'GPU Bus Interface', 'GPU Fan', 'GPU', 'GPU Memory Total', 'GPU Memory Used', 'GPU Memory Free', 'GPU Memory', 'GPU Power', 'GPU PCIE Rx', 'GPU PCIE Tx', 'Used Space');

$Clock_CPU_Core = @{Avg="";Max="";Min="";};
$Clock_GPU_Core = @{Avg="";Max="";Min="";};
$Clock_GPU_Mem = @{Avg="";Max="";Min="";};
$Clock_GPU_Shad = @{Avg="";Max="";Min="";};

$GPU_Memory_Load = @{Avg="";Max="";Min="";};

$Load_CPU = @{Avg="";Max="";Min="";};
$Load_GPU = @{Avg="";Max="";Min="";};

$Speed_FAN_PMP = @{Avg="";Max="";Min="";};
$Speed_FAN_PMP_PRC = @{Avg="";Max="";Min="";};
$Speed_FAN_RAD = @{Avg="";Max="";Min="";};
$Speed_FAN_RAD_PRC = @{Avg="";Max="";Min="";};
$Speed_FAN_SSD = @{Avg="";Max="";Min="";};
$Speed_FAN_SSD_PRC = @{Avg="";Max="";Min="";};
$Speed_FAN_CHA = @{Avg="";Max="";Min="";};
$Speed_FAN_CHA_PRC = @{Avg="";Max="";Min="";};

$Power_CPU = @{Avg="";Max="";Min="";};
$Power_GPU = @{Avg="";Max="";Min="";};

$Temp_CPU = @{Avg="";Max="";Min="";};
$Temp_GPU = @{Avg="";Max="";Min="";};
$Temp_SSD = @{Avg="";Max="";Min="";};
$Temp_T_SENSOR = @{Avg="";Max="";Min="";};

$Time_Range = @{Avg="";Max="";Min="";};

# $XmlFooter = "</prtg>";
# $XmlHeader = "<?xml version=`"1.0`" encoding=`"Windows-1252`" ?>`n<prtg>";
# $XmlOutput_Array_All = @();

$Sensor_ErrorMessage="ERROR - Open Hardware Monitor reading returned a null or empty value";

<# Make sure the OHW Logfile exists #>
If ((Test-Path -PathType "Leaf" -Path ("${Logfile_Fullpath}") -ErrorAction ("SilentlyContinue")) -Eq $False) {
	<# Remove any logged data from a previous run #>
	# Get-Item "${Logfile_Basename}*.txt" | Remove-Item -Force;

	<# End the current run #>
	# Exit 1;

	$Sensor_ErrorMessage="ERROR - Open Hardware Monitor logfile not found: ${Logfile_Fullpath}";

} Else {

	$RowCount_HeaderRows=(2);
	$RowCount_DataRows=(60);

	$LogContent_HeaderRows = (Get-Content -Path ("${Logfile_Fullpath}") -TotalCount (${RowCount_HeaderRows}));

	$CsvImport = @{};
	${CsvImport}["Descriptions"] = (@("$($LogContent_HeaderRows[1])").Split(","));
	${CsvImport}["Paths"] = (@("$($LogContent_HeaderRows[0])").Split(","));
	${CsvImport}["Paths"][0]="Time"; <# OHW leaves thefirst row's first column blank for whatever reason #>

	<# Avoid random bug where OHW doesn't grab the GPU correctly at logfile creation time, which combines with OHW matching the headers on an existing log's data after said bugged run, which truncates all future data which is in addition to an existing log's header columns (truncates GPU data if GPU data wasn't pulled at time of log creation) #>
	$RequiredPath="gpu";
	If (((${CsvImport}["Paths"] | Where-Object { "${_}" -Like "*${RequiredPath}*" }).Count) -Eq (0)) {
		$Dirname = [IO.Path]::GetDirectoryName("${Logfile_FullPath}");
		$Basename = [IO.Path]::GetFileNameWithoutExtension("${Logfile_FullPath}");
		$Extension = [IO.Path]::GetExtension("${Logfile_FullPath}");
		<# Remove any logged data from a previous run #>
		Get-Item "${Logfile_Basename}*.txt" | Remove-Item -Force;
		<# Rename the logfile - Allow OHW to recreate the logfile with updated headers (including (namely) missing gpu header columns) #>
		${Logfile_Renamed_MissingHeaders}=("${Dirname}\${Basename}_MISSING-[${RequiredPath}]-HEADERS_$(Get-Date -Format 'yyyyMMddTHHmmss.fff')${Extension}");
		Move-Item -Path ("${Logfile_FullPath}") -Destination ("${Logfile_Renamed_MissingHeaders}") -Force;
		<# End the current run #>
		Exit 1;
	}

	$LogContent_DataAndHeaderCheck=(Get-Content -Path ("${Logfile_Fullpath}") -Tail (${RowCount_DataRows}+${RowCount_HeaderRows}));
	$LogContent_DataRows=(${LogContent_DataAndHeaderCheck} | Select-Object -Last ((${LogContent_DataAndHeaderCheck}.Count)-${RowCount_HeaderRows}));

	$DataRows_SensorReadings=@();

	$GetCulture=(Get-Culture); <# Get the system's display format of items such as numbers #>


	For ($i=0; $i -LT ((${CsvImport}["Paths"]).Count); $i++) {

		$Each_HeaderPath=(${CsvImport}["Paths"][$i]);
		$Each_HeaderDescription=(${CsvImport}["Descriptions"][$i]);
		$Updated_HeaderDescription=("");

		# ------------------------------
		# OHW outputs descriptions which are non-unique - update them to be unique, instead
		# ------------------------------
		#
		# Mobo Readings
		#
		If (${Each_HeaderPath} -Match "lpc/.+/control/") {
			$Updated_HeaderDescription=("Mobo Fans (% PWM), ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "lpc/.+/fan/") {
			$Updated_HeaderDescription=("Mobo Fans (RPM), ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "lpc/.+/voltage/") {
			$Updated_HeaderDescription=("Mobo Voltages, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "lpc/.+/temperature/") {
			$Updated_HeaderDescription=("Mobo Temps, ${Each_HeaderDescription}");

		# ------------------------------
		#
		# Processor (CPU) Readings
		#
		} ElseIf (${Each_HeaderPath} -Match "cpu/.+/load/") {
			$Updated_HeaderDescription=("CPU Load, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "cpu/.+/power/") {
			$Updated_HeaderDescription=("CPU Power, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "cpu/.+/temperature/") {
			$Updated_HeaderDescription=("CPU Temps, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "cpu/.+/clock/") {
			$Updated_HeaderDescription=("CPU Clocks, ${Each_HeaderDescription}");

		# ------------------------------
		#
		# Memory (RAM) Readings
		#
		} ElseIf (${Each_HeaderPath} -Match "/ram/load/") {
			$Updated_HeaderDescription=("RAM Load, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "/ram/data/") {
			$Updated_HeaderDescription=("RAM Data, ${Each_HeaderDescription}");

		# ------------------------------
		#
		# Graphics Card (GPU) Readings
		#
		} ElseIf (${Each_HeaderPath} -Match "gpu/.+/temperature/") {
			$Updated_HeaderDescription=("GPU Temps, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "gpu/.+/clock/") {
			$Updated_HeaderDescription=("GPU Clocks, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "gpu/.+/control/") {
			$Updated_HeaderDescription=("GPU Fan (% PWM), ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "gpu/.+/fan/") {
			$Updated_HeaderDescription=("GPU Fan (RPM), ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "gpu/.+/smalldata/") {
			$Updated_HeaderDescription=("GPU Memory, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "gpu/.+/load/") {
			$Updated_HeaderDescription=("GPU Load, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "gpu/.+/power/") {
			$Updated_HeaderDescription=("GPU Power, ${Each_HeaderDescription}");

		} ElseIf (${Each_HeaderPath} -Match "gpu/.+/throughput/") {
			$Updated_HeaderDescription=("GPU Rx/Tx, ${Each_HeaderDescription}");

		# ------------------------------
		#
		# Storage Disk (HDD/SSD) Readings
		#
		} ElseIf (${Each_HeaderPath} -Match "hdd/.+/load/") {
			$Updated_HeaderDescription=("Disk Load, ${Each_HeaderDescription}");

		# ------------------------------
		}

		If ("${Updated_HeaderDescription}" -NE "") {
			${CsvImport}["Descriptions"][$i]=("${Updated_HeaderDescription}");
		}

	}

	For ($i_Row=-1; $i_Row -GE (-1 * ${LogContent_DataRows}.Count); $i_Row--) {
		<# Walk through the last minute's worth of sensor data stored in the CSV logfile #>
		$Each_DataRow=(${LogContent_DataRows}[$i_Row] -Split ",");
		$Each_Row_SensorReadings = @{"Time"=(${Each_DataRow}[0][0]);};
		For ($i_Column=0; $i_Column -LT (${CsvImport}["Paths"].Count); $i_Column++) {
			<# Walk through each column on each row #>
			$Each_StringValue=(${Each_DataRow}[${i_Column}] -Replace "`"", "");
			$Each_Value=0.0;
			If (${i_Column} -Eq 0) {
				<# Convert [String] to [DateTime] w/o throwing an error #>
				$Each_Value=(Get-Date -Date (${Each_StringValue}) -UFormat ("%s"));
			} Else {
				<# Convert [String] to [DateTime] w/o throwing an error #>
				If (([Decimal]::TryParse(${Each_StringValue}, [Globalization.NumberStyles]::Float, ${GetCulture}, [Ref]${Each_Value})) -Eq ($True)) {
					<# Do Nothing (String-to-Decimal conversion already performed in above "If" statement's conditional block #>
					}
			}
			<# Store each values into an object, push the object to an array (below), then calculate min/max later all-at-once #>
			${Each_Row_SensorReadings}.(${CsvImport}["Paths"][${i_Column}]) = (${Each_Value});
		}
		${DataRows_SensorReadings} += ${Each_Row_SensorReadings};
	}

	If ($False) {
		$Dirname_RevertTo = ((Get-Location).Path);
		$Dirname_NVidiaSMI = (Split-Path -Path ("${Exe_NVidiaSMI}") -Parent);
		Set-Location -Path ("${Dirname_NVidiaSMI}");
		$Load_GPU = (nvidia-smi.exe --query-gpu=utilization.gpu --format="csv,nounits,noheader" --id=0);
		# $Temp_GPU = (nvidia-smi.exe --query-gpu=temperature.gpu --format="csv,nounits,noheader" --id=0);
		Set-Location -Path ("${Dirname_RevertTo}");
	}

	<# Calculated output data based on latest input data #>
	For ($i_Column=0; $i_Column -LT ((${CsvImport}["Paths"]).Count); $i_Column++) {

		$Each_MinMaxAverage = (${DataRows_SensorReadings}.(${CsvImport}["Paths"][${i_Column}]) | Measure-Object -Average -Maximum -Minimum);

		$EachSensorReading_Obj = @{};
		# $Each_SensorPath = (${CsvImport}["Paths"][${i_Column}] -Replace "`"", "");
		$Each_SensorDescription = (${CsvImport}["Descriptions"][${i_Column}] -Replace "`"", "");

		$EachSensorReading_Obj["Average"] = (${Each_MinMaxAverage}.Average);
		$EachSensorReading_Obj["Maximum"] = (${Each_MinMaxAverage}.Maximum);
		$EachSensorReading_Obj["Minimum"] = (${Each_MinMaxAverage}.Minimum);
		
		$Each_Value = @{};
		${Each_Value}.Avg = (${Each_MinMaxAverage}.Average);
		${Each_Value}.Max = (${Each_MinMaxAverage}.Maximum);
		${Each_Value}.Min = (${Each_MinMaxAverage}.Minimum);

		# ------------------------------------------------------------

		# $Each_XmlOutput_Array = @();
		# $Each_XmlOutput_Array += "   <result>";
		# $Each_XmlOutput_Array += "       <Channel>${Each_SensorDescription}</Channel>";
		# $Each_XmlOutput_Array += "       <Value>$(${Each_Value}.Max)</Value>";
		# $Each_XmlOutput_Array += "       <Mode>Absolute</Mode>";
		# If (${Each_SensorPath} -Match "/temperature/") { # Use units of Degrees-Celsius (°C) for temperature readings
		# 	$Each_XmlOutput_Array += "       <Unit>Temperature</Unit>";
		# } ElseIf (${Each_SensorPath} -Match "/fan/") { # Use units of Rotations per Minute (RPM) for fans and liquid-cooling pumps
		# 	$Each_XmlOutput_Array += "       <Unit>Custom</Unit>";
		# 	$Each_XmlOutput_Array += "       <CustomUnit>RPM</CustomUnit>";
		# } ElseIf (${Each_SensorPath} -Match "/control/") { # Use units of Percentage of Max-Fan-Speed (% PWM) for fans and liquid-cooling pumps
		# 	$Each_XmlOutput_Array += "       <Unit>Custom</Unit>";
		# 	$Each_XmlOutput_Array += "       <CustomUnit>% PWM</CustomUnit>";
		# } ElseIf (${Each_SensorPath} -Match "/voltage/") { # Use units of Volts (V) for electric-pressure readings
		# 	$Each_XmlOutput_Array += "       <Unit>Custom</Unit>";
		# 	$Each_XmlOutput_Array += "       <CustomUnit>Volts</CustomUnit>";
		# }
		# $Each_XmlOutput_Array += "       <Float>1</Float>";
		# $Each_XmlOutput_Array += "       <ShowChart>0</ShowChart>";
		# $Each_XmlOutput_Array += "       <ShowTable>0</ShowTable>";
		# $Each_XmlOutput_Array += "   </result>";

		# $XmlOutput_Array_All += $Each_XmlOutput_Array;

		@("Avg","Max","Min") | ForEach-Object {

			If (${Each_SensorDescription} -Eq "Time") {
				${Time_Range}.(${_}) = (Get-Date -Date ($((New-Object -Type DateTime -ArgumentList 1970,1,1,0,0,0,0).AddSeconds([Math]::Floor(${Each_Value}.(${_}))))) -UFormat ("%m/%d/%Y %H:%M:%S"));

			} ElseIf (${Each_SensorDescription} -Eq "CPU Clocks, CPU Core #1") {
				${Clock_CPU_Core}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "CPU Load, CPU Total") {
				${Load_CPU}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "CPU Power, CPU Cores") {
				${Power_CPU}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "CPU Temps, CPU Package") {
				${Temp_CPU}.(${_}) = (${Each_Value}.(${_}));


			} ElseIf (${Each_SensorDescription} -Eq "GPU Load, GPU Core") {
				${Load_GPU}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "GPU Power, GPU Power") {
				${Power_GPU}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "GPU Temps, GPU Core") {
				${Temp_GPU}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "GPU Load, GPU Memory") {
				${GPU_Memory_Load}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "GPU Clocks, GPU Core") {
				${Clock_GPU_Core}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "GPU Clocks, GPU Memory") {
				${Clock_GPU_Mem}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "GPU Clocks, GPU Shader") {
				${Clock_GPU_Shad}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Temps, Temperature #2") {
				${Temp_SSD}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Fans (RPM), Fan #1") {  <# Chassis Fan 1 #>
				${Speed_FAN_RAD}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Fans (% PWM), Fan Control #1") {  <# Chassis Fan 1 #>
				${Speed_FAN_RAD_PRC}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Fans (RPM), Fan #3") {  <# Chassis Fan 2 #>
				${Speed_FAN_CHA}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Fans (% PWM), Fan Control #3") {  <# Chassis Fan 2 #>
				${Speed_FAN_CHA_PRC}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Fans (RPM), Fan #4") {  <# Chassis Fan 3 #>
				${Speed_FAN_SSD}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Fans (% PWM), Fan Control #4") {  <# Chassis Fan 3 #>
				${Speed_FAN_SSD_PRC}.(${_}) = (${Each_Value}.(${_}));
				${Temp_T_SENSOR}.(${_}) = ([Double](${Each_Value}.(${_})) - [Double](40.00));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Fans (RPM), Fan #6") {  <# W_PUMP+ #>
				${Speed_FAN_PMP}.(${_}) = (${Each_Value}.(${_}));

			} ElseIf (${Each_SensorDescription} -Eq "Mobo Fans (% PWM), Fan Control #6") {  <# W_PUMP+ #>
				${Speed_FAN_PMP_PRC}.(${_}) = (${Each_Value}.(${_}));

			}

		}

	};

}

# Output the XML contents to output files (separated by-category, as well as one combined file)
# Write-Output (("${XmlHeader}")+("`n")+(${XmlOutput_Array_All} -join "`n")+("`n")+("${XmlFooter}")) | Out-File -NoNewline "${Logfile_XmlOutput_All}.xml";

@("Avg","Max","Min") | ForEach-Object {

	<# Output the sensor values to each of their individual log files (intended for simplified PRTG parsing via batch file using [ TYPE ... .txt ]) #>

	# ------------------------------

	# Time_Range
	If ([String]::IsNullOrEmpty(${Time_Range}.(${_}))) {
		Write-Output "$(${Time_Range}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Time_Range}-${_}.txt";
	} Else {
		Write-Output "$(${Time_Range}.${_}):OK" | Out-File -NoNewline "${Logfile_Time_Range}-${_}.txt";
	}

	# ------------------------------

	# CPU Load
	If ([String]::IsNullOrEmpty(${Load_CPU}.(${_}))) {
		Write-Output "$(${Load_CPU}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Load_CPU}-${_}.txt";
	} Else {
		Write-Output "$(${Load_CPU}.${_}):OK" | Out-File -NoNewline "${Logfile_Load_CPU}-${_}.txt";
	}

	# ------------------------------

	# CPU Power
	If ([String]::IsNullOrEmpty(${Power_CPU}.(${_}))) {
		Write-Output "$(${Power_CPU}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Power_CPU}-${_}.txt";
	} Else {
		Write-Output "$(${Power_CPU}.${_}):OK" | Out-File -NoNewline "${Logfile_Power_CPU}-${_}.txt";
	}

	# ------------------------------

	# GPU Load
	If ([String]::IsNullOrEmpty(${Load_GPU}.(${_}))) {
		Write-Output "$(${Load_GPU}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Load_GPU}-${_}.txt";
	} Else {
		Write-Output "$(${Load_GPU}.${_}):OK" | Out-File -NoNewline "${Logfile_Load_GPU}-${_}.txt";
	}
	# GPU Memory Load
	If ([String]::IsNullOrEmpty(${GPU_Memory_Load}.(${_}))) {
		Write-Output "$(${GPU_Memory_Load}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Load_GPU_Memory}-${_}.txt";
	} Else {
		Write-Output "$(${GPU_Memory_Load}.${_}):OK" | Out-File -NoNewline "${Logfile_Load_GPU_Memory}-${_}.txt";
	}

	# ------------------------------

	# GPU Power
	If ([String]::IsNullOrEmpty(${Power_GPU}.(${_}))) {
		Write-Output "$(${Power_GPU}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Power_GPU}-${_}.txt";
	} Else {
		Write-Output "$(${Power_GPU}.${_}):OK" | Out-File -NoNewline "${Logfile_Power_GPU}-${_}.txt";
	}

	# ------------------------------

	# CPU Temp
	If ([String]::IsNullOrEmpty(${Temp_CPU}.(${_}))) {
		Write-Output "$(${Temp_CPU}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Temperature_CPU}-${_}.txt";
	} Else {
		Write-Output "$(${Temp_CPU}.${_}):OK" | Out-File -NoNewline "${Logfile_Temperature_CPU}-${_}.txt";
	}
	# GPU Temp
	If ([String]::IsNullOrEmpty(${Temp_GPU}.(${_}))) {
		Write-Output "$(${Temp_GPU}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Temperature_GPU}-${_}.txt";
	} Else {
		Write-Output "$(${Temp_GPU}.${_}):OK" | Out-File -NoNewline "${Logfile_Temperature_GPU}-${_}.txt";
	}
	# SSD Temp
	If ([String]::IsNullOrEmpty(${Temp_SSD}.(${_}))) {
		Write-Output "$(${Temp_SSD}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Temperature_SSD}-${_}.txt";
	} Else {
		Write-Output "$(${Temp_SSD}.${_}):OK" | Out-File -NoNewline "${Logfile_Temperature_SSD}-${_}.txt";
	}
	# T_SENSOR Temp
	If ([String]::IsNullOrEmpty(${Temp_T_SENSOR}.(${_}))) {
		Write-Output "$(${Temp_T_SENSOR}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Temperature_T_SENSOR}-${_}.txt";
	} Else {
		Write-Output "$(${Temp_T_SENSOR}.${_}):OK" | Out-File -NoNewline "${Logfile_Temperature_T_SENSOR}-${_}.txt";
	}


	# ------------------------------

	# Frequency/Clock - CPU Temp
	If ([String]::IsNullOrEmpty(${Clock_CPU_Core}.(${_}))) {
		Write-Output "$(${Clock_CPU_Core}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Clock_CPU_Core}-${_}.txt";
	} Else {
		Write-Output "$(${Clock_CPU_Core}.${_}):OK" | Out-File -NoNewline "${Logfile_Clock_CPU_Core}-${_}.txt";
	}
	# Frequency/Clock - GPU Core
	If ([String]::IsNullOrEmpty(${Clock_GPU_Core}.(${_}))) {
		Write-Output "$(${Clock_GPU_Core}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Clock_GPU_Core}-${_}.txt";
	} Else {
		Write-Output "$(${Clock_GPU_Core}.${_}):OK" | Out-File -NoNewline "${Logfile_Clock_GPU_Core}-${_}.txt";
	}
	# Frequency/Clock - GPU Memory
	If ([String]::IsNullOrEmpty(${Clock_GPU_Mem}.(${_}))) {
		Write-Output "$(${Clock_GPU_Mem}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Clock_GPU_Mem}-${_}.txt";
	} Else {
		Write-Output "$(${Clock_GPU_Mem}.${_}):OK" | Out-File -NoNewline "${Logfile_Clock_GPU_Mem}-${_}.txt";
	}
	# Frequency/Clock - GPU Shader
	If ([String]::IsNullOrEmpty(${Clock_GPU_Shad}.(${_}))) {
		Write-Output "$(${Clock_GPU_Shad}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_Clock_GPU_Shad}-${_}.txt";
	} Else {
		Write-Output "$(${Clock_GPU_Shad}.${_}):OK" | Out-File -NoNewline "${Logfile_Clock_GPU_Shad}-${_}.txt";
	}


	# ------------------------------

	# Water-Pump Fan-Speed (RPM)  (W_PUMP+)
	If ([String]::IsNullOrEmpty(${Speed_FAN_PMP}.(${_}))) {
		Write-Output "$(${Speed_FAN_PMP}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_FanSpeed_PMP}-${_}.txt";
	} Else {
		Write-Output "$(${Speed_FAN_PMP}.${_}):OK" | Out-File -NoNewline "${Logfile_FanSpeed_PMP}-${_}.txt";
	}
	# Radiator Fan-Speed (RPM)  (CHA_FAN1)
	If ([String]::IsNullOrEmpty(${Speed_FAN_RAD}.(${_}))) {
		Write-Output "$(${Speed_FAN_RAD}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_FanSpeed_RAD}-${_}.txt";
	} Else {
		Write-Output "$(${Speed_FAN_RAD}.${_}):OK" | Out-File -NoNewline "${Logfile_FanSpeed_RAD}-${_}.txt";
	}
	# Chassis Fan-Speed (RPM)  (CHA_FAN2)
	If ([String]::IsNullOrEmpty(${Speed_FAN_CHA}.(${_}))) {
		Write-Output "$(${Speed_FAN_CHA}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_FanSpeed_CHA}-${_}.txt";
	} Else {
		Write-Output "$(${Speed_FAN_CHA}.${_}):OK" | Out-File -NoNewline "${Logfile_FanSpeed_CHA}-${_}.txt";
	}
	# SSD Fan-Speed (RPM)  (CHA_FAN3)
	If ([String]::IsNullOrEmpty(${Speed_FAN_SSD}.(${_}))) {
		Write-Output "$(${Speed_FAN_SSD}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_FanSpeed_SSD}-${_}.txt";
	} Else {
		Write-Output "$(${Speed_FAN_SSD}.${_}):OK" | Out-File -NoNewline "${Logfile_FanSpeed_SSD}-${_}.txt";
	}


	# ------------------------------

	# Water-Pump Fan-Speed (% Max)  (W_PUMP+)
	If ([String]::IsNullOrEmpty(${Speed_FAN_PMP_PRC}.(${_}))) {
		Write-Output "$(${Speed_FAN_PMP_PRC}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_FanPercentage_PMP}-${_}.txt";
	} Else {
		Write-Output "$(${Speed_FAN_PMP_PRC}.${_}):OK" | Out-File -NoNewline "${Logfile_FanPercentage_PMP}-${_}.txt";
	}
	# Radiator Fan-Speed (% Max)  (CHA_FAN1)
	If ([String]::IsNullOrEmpty(${Speed_FAN_RAD_PRC}.(${_}))) {
		Write-Output "$(${Speed_FAN_RAD_PRC}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_FanPercentage_RAD}-${_}.txt";
	} Else {
		Write-Output "$(${Speed_FAN_RAD_PRC}.${_}):OK" | Out-File -NoNewline "${Logfile_FanPercentage_RAD}-${_}.txt";
	}
	# Chassis Fan-Speed (% Max)  (CHA_FAN2)
	If ([String]::IsNullOrEmpty(${Speed_FAN_CHA_PRC}.(${_}))) {
		Write-Output "$(${Speed_FAN_CHA_PRC}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_FanPercentage_CHA}-${_}.txt";
	} Else {
		Write-Output "$(${Speed_FAN_CHA_PRC}.${_}):OK" | Out-File -NoNewline "${Logfile_FanPercentage_CHA}-${_}.txt";
	}
	# SSD Fan-Speed (% Max)  (CHA_FAN3)
	If ([String]::IsNullOrEmpty(${Speed_FAN_SSD_PRC}.(${_}))) {
		Write-Output "$(${Speed_FAN_SSD_PRC}.${_}):${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_FanPercentage_SSD}-${_}.txt";
	} Else {
		Write-Output "$(${Speed_FAN_SSD_PRC}.${_}):OK" | Out-File -NoNewline "${Logfile_FanPercentage_SSD}-${_}.txt";
	}


	# ------------------------------

}

# Benchmark (KEEP AS FINAL RUNTIME (e.g. keep at the very very end of this script)

$Benchmark.Stop();
$RunDuration=("$(${Benchmark}.Elapsed)");
If ([String]::IsNullOrEmpty(${RunDuration})) {
	Write-Output "${RunDuration}:${Sensor_ErrorMessage}" | Out-File -NoNewline "${Logfile_RunDuration}.txt";
} Else {
	Write-Output "${RunDuration}:OK" | Out-File -NoNewline "${Logfile_RunDuration}.txt";
}

# ------------------------------------------------------------
# 
# Citation(s)
#
#   community.spiceworks.com  |  "[SOLVED] Invalid Global Switch - wmic - Spiceworks General Support - Spiceworks"  |  https://community.spiceworks.com/topic/218342-invalid-global-switch-wmic
# 
#   docs.microsoft.com  |  "DateTime.ParseExact Method (System) | Microsoft Docs"  |  https://docs.microsoft.com/en-us/dotnet/api/system.datetime.parseexact?view=net-5.0
# 
#   docs.microsoft.com  |  "Get-Content"  |  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-5.1
# 
#   docs.microsoft.com  |  "Get-WmiObject"  |  https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1
# 
#   docs.microsoft.com  |  "wmic - Win32 apps | Microsoft Docs"  |  https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmic?redirectedfrom=MSDN
#
#   docs.microsoft.com  |  "WMIC switches: Windows Management Instrumentation (WMI); Scripting | Microsoft Docs"  |  https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc787035(v=ws.10)?redirectedfrom=MSDN
#
#   pastebin.com  |  "[Batch] calc - Pastebin.com"  |  https://pastebin.com/Kr35D3A4
#
#   pastebin.com  |  "[Batch] EXEXML/ohm-computer1.bat - Pastebin.com"  |  https://pastebin.com/V5dU1GSf
#
#   pastebin.com  |  "[Batch] ohm-computer1-hw - Pastebin.com"  |  https://pastebin.com/4GjHWeTn
#
#   pastebin.com  |  "[Batch] pingcheck - Pastebin.com"  |  https://pastebin.com/1ESd9Tv9
#
#   sites.google.com  |  "Example 2 (WMI/OHM) - Custom sensors for PRTG"  |  https://sites.google.com/site/prtghowto/example-2
#
#   stackoverflow.com  |  "How to convert string to decimal in powershell? - Stack Overflow"  |  https://stackoverflow.com/a/63631813
#
#   stackoverflow.com  |  "powershell max/first/aggregate functions - Stack Overflow"  |  https://stackoverflow.com/a/19170783
# 
#   www.paessler.com  |  "PRTG Manual: Custom Sensors"  |  https://www.paessler.com/manuals/prtg/custom_sensors
# 
# ------------------------------------------------------------
