$PY_ENV_FOLDER = '.\py_env'
$TMP_FOLDER = '.\tmp'

$PY_BIN_FOLDER = '.\py_bin'
$PYTHON_LAUNCHER_EXE = "python"
$ENVIROMENT_ACTIVATION_CMD = "Scripts\Activate.ps1"

# include
. .\env\utils.ps1


# if portable, this dir exists and must be in path
$env:Path += $PY_BIN_FOLDER

function Try-Activate-PythonEnviroment ([string]$env_path, [bool]$activate)
	{
	Write-Host "Trying to activate $env_path"
		
    $activation_cmd = Join-Path $env_path $ENVIROMENT_ACTIVATION_CMD
    $exists = Test-Path -Path $activation_cmd

    if (-not $activate)
        { 
		Write-Host "Environment activation script exists: $exists"
		return $exists 
		}

	Assert $exists "Environment not found. Possibly install script was not used. "

    & $activation_cmd

	
    return $True
	}
