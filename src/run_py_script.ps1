Cls
# Do not change scope
$ErrorActionPreference = "Stop"

# include
. .\src\paths.ps1
. .\src\activate_py_env.ps1


function Run-PyScript ([string]$script_path)
	{
	if (Try-Activate-PythonEnviroment $PY_ENV_FOLDER $True)
		{
		INFO "Environment activated. Running script"
		
		if ($IS_PORTABLE)
			{ python $script_path }
		else
			{ py -3 $script_path }

		deactivate
		}
	else
		{
		INFO "Environment activation failed."
		}
	}


$IS_PORTABLE = Test-Path -Path $PY_ENV_FOLDER
INFO 'Trying to run as poratble:' $IS_PORTABLE
INFO 'Recieved script path to run:' $Args[0]
Run-PyScript $Args[0]