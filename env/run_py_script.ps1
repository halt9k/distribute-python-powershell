Cls
# Do not change scope
$ErrorActionPreference = "Stop"

# include
. .\env\activate_py_env.ps1


function Wait-UserInput 
	{
	Write-Host -NoNewLine 'Press any key to continue...';
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	}


function Run-PyScript ([string]$script_path)
	{
	if (Try-Activate-PythonEnviroment $PY_ENV_FOLDER $True)
		{
		Write-Host "Environment activated. Running script"
		
		py $script_path

		deactivate
		}
	else
		{
		Write-Host "Environment failed."
		}
	}
	
# $Args[0] path to script
Run-PyScript $Args[0]