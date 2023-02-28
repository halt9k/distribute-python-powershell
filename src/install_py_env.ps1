Cls
# Do not change scope
$ErrorActionPreference = "Stop"

# include
. .\src\paths.ps1
. .\src\utils.ps1
. .\src\activate_py_env


function Install-PythonSilently  ([string]$download_link, [string]$tmp_dir)
	{
	INFO "Downloading python installer"
	
	$exe_name = Split-Path $download_link -leaf	
	Ensure-Dir $tmp_dir
	$exe_path = Join-Path $tmp_dir $exe_name
	Download-File  $download_link $exe_path
	
	INFO "Installing python and launcher"
	# May easily fail with other params
	# 2>&1 | Out-String  used to wait until installer ends
	
	if (-not $IS_PORTABLE)
		{
		& $exe_path InstallAllUsers=1 AssociateFiles=0 InstallLauncherAllUsers=1 Include_launcher=1 /passive 2>&1 | Out-String
		}
	else
		{		
		Ensure-Dir $PY_BIN_FOLDER
		$BIN_FOLDER = Resolve-Path $PY_BIN_FOLDER
		& $exe_path TargetDir=$BIN_FOLDER Shortcuts=0 InstallAllUsers=1 AssociateFiles=0 InstallLauncherAllUsers=1 Include_launcher=1 /passive 2>&1 | Out-String	
		}	
	}


function Test-PythonLauncher
	{
	INFO "Testing launcher `n"
	
	# only w11 support tenary
	if ($IS_PORTABLE)
		{ $exe =  'python' }
	else
		{ $exe =  'py' }
	
	# test if launcher exists		
	if (-not (Get-Command $exe -errorAction SilentlyContinue)) 
		{ return $False }

	
	# test if python version > 3.0 activates;	
	# tricky to capture output, 
	# | Out-String works, but omits possibly important diagnostics
	# may work differently in PS ISE vs PS

	Try 		
		{
		if ($IS_PORTABLE)
			{ $output = & python -V | Out-String }
		else
			{ $output = & py -3 -V | Out-String }
		}
	Catch
		{ INFO "During launcher test: $output" }
	return [bool]$output
	}
	

function Ensure-Python ([string]$download_link, [string]$tmp_dir)
	{
	if (Test-PythonLauncher) 
		{
		INFO ("Launcher activated environment successfully.`n" +
			  "This usually means python is already correctly installed. `n")
		return 
		}
	else
		{
		WARN 'Proceed may install additional copy of python on your system and change PATH'

		$confirmation = Read-Host "Pyton or launcher is missing. Proceed with install? y/n"
		if ($confirmation -ne 'y') 
			{ return }
		}
	Install-PythonSilently $download_link $tmp_dir
	
	Assert (Test-PythonLauncher) ("Python launcher is missing. `n" +
		"Try to install manually from $PY_INSTALLER_DOWNLOAD_LINK `n" +
		"Ensure launcher option in python installer. `n")
	}


function Ensure-PythonEnviroment ([string]$env_path)
	{
	if (Try-Activate-PythonEnviroment $env_path $False) 
		{ return }

	INFO "Installing virtual enviroment in $env_path"
	if ($IS_PORTABLE)
		{
		python -m venv $env_path
		}
	else
		{
		# py -3 -m pip install virtualenv
		py -3 -m venv $env_path
		}

	Assert (Try-Activate-PythonEnviroment $env_path $False) (
		"Python environment creation failed. Try to run *.py script manually. ")
	}


function Make-EnvPortable ([string]$env_path)
	{
	$files =  Get-ChildItem -Include *.cfg, *.bat, *.ps1 -Recurse -File -Name
	$abs_env_path = Get-Location

	INFO 'Replacing ' $abs_env_path ' with . in files: '	

	# replace full path -> relative	
	foreach($file in $files)
		{
		Replace-FileText $file $abs_env_path '.'
		}
	
	}


function Install-Dependencies ([string]$env_path)
	{
	INFO "`n Installing additional python packages `n"
	
	if (Try-Activate-PythonEnviroment $env_path $True)
		{
		Assert (-not (Detect-PowershellISE)) (
			'Py env commands need PS instead of PS ISE')

		pip install pandas
		pip install xlwings
				
		deactivate
		}
		
	if ($IS_PORTABLE)
		{
		INFO "Trying to make enviroment portable with absolute -> relative paths `n"
		Make-EnvPortable $env_path 
		}
	}


function Main
	{
	INFO 'This script will try to detect or to install python enviroment.' 	
	INFO 'Trying to run as poratble:' $IS_PORTABLE

	Ensure-Python $PY_INSTALLER_DOWNLOAD_LINK $TMP_FOLDER
	Ensure-PythonEnviroment $PY_ENV_FOLDER
	Install-Dependencies $PY_ENV_FOLDER

	if ($IS_PORTABLE)
		{
		WARN ("To test portability, copy project folder to clean VM `n " +
			  "or uninstall py and python, ensure empty PATH, and rename project folder.")
		}
	else
		{
		INFO 'Environment ensured. You may close console now and try run_test_py_script.bat'
		}
	}


$IS_PORTABLE = $Args[0] -eq 'PortableInstall'
Main