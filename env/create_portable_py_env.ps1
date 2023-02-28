Cls
# Do not change scope
$ErrorActionPreference = "Stop"

# include
. .\env\utils.ps1
. .\env\activate_py_env

Write-Host 'This script will try to verify of install python enviroment automatically.'

$PY_INSTALLER_DOWNLOAD_LINK = 'https://www.python.org/ftp/python/3.11.1/python-3.11.1-amd64.exe'

function Install-PythonSilently  ([string]$download_link, [string]$tmp_dir)
	{
	Write-Host "Downloading python installer"
	
	$exe_name = Split-Path $download_link -leaf	
	Ensure-Dir $tmp_dir
	$exe_path = Join-Path $tmp_dir $exe_name
	Download-File  $download_link $exe_path
	
	Write-Host "Installing python and launcher"
	# May easily fail with other params
	# 2>&1 | Out-String  used to wait until installer ends	
	
	Ensure-Dir $PY_BIN_FOLDER
	$BIN_FOLDER = Resolve-Path $PY_BIN_FOLDER
	& $exe_path TargetDir=$BIN_FOLDER Shortcuts=0 InstallAllUsers=1 AssociateFiles=0 InstallLauncherAllUsers=1 Include_launcher=1 /passive 2>&1 | Out-String	
	}


function Test-PythonLauncher
	{
	Write-Host "Testing launcher"
	
    # test if launcher exists
	if (-not (Get-Command $PYTHON_LAUNCHER_EXE -errorAction SilentlyContinue)) 
		{ return $False }

    # test if python version > 3.0 activates;	
	# tricky to capture output, 
	# | Out-String works, but omits possibly important diagnostics
	Try 
		{ $output = & $PYTHON_LAUNCHER_EXE -3 -V | Out-String }
	Catch
		{ Write-Host "During launcher test: $output" }
	return [bool]$output
	}
	

function Ensure-Python ([string]$download_link, [string]$tmp_dir)
	{
	if (Test-PythonLauncher) 
		{ 
		Write-Host "Launcher activated environment successfully. This usually means python is already correctly installed."
		return 
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

	Write-Host "Installing virtual enviroment in $env_path"
    & $PYTHON_LAUNCHER_EXE -3 -m pip install virtualenv
	& $PYTHON_LAUNCHER_EXE -3 -m venv $env_path

	Assert (Try-Activate-PythonEnviroment $env_path $False) (
		"Python environment creation failed. Try to run *.py script manually. ")
	}


function Install-Dependencies  ([string]$env_path)
	{
	Write-Host "Installing additional python packages"
	
	if (Try-Activate-PythonEnviroment $env_path $True)
		{		
		pip install pandas
		pip install xlwings

		deactivate
		}
	}


Ensure-Python $PY_INSTALLER_DOWNLOAD_LINK $TMP_FOLDER
Ensure-PythonEnviroment $PY_ENV_FOLDER
Install-Dependencies $PY_ENV_FOLDER


