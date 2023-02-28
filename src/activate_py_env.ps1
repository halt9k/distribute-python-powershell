# include
. .\src\utils.ps1


function Try-Activate-PythonEnviroment ([string]$env_path, [bool]$activate)
	{
	INFO 'Trying to activate' $env_path
		
    $activation_cmd = Join-Path $env_path $ENV_ACTIVATION_CMD
    $exists = Test-Path -Path $activation_cmd

    if (-not $activate)
        { 
		INFO 'Environment activation script exists:' $exists
		return $exists 
		}

	Assert $exists "Environment not found. Possibly install script was not used. "

    & $activation_cmd

	
    return $True
	}
