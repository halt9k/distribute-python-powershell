Cls
# Do not change scope
$ErrorActionPreference = "Stop"

# include
. .\env\py_environment.ps1


function Wait-UserInput 
	{
	Write-Host -NoNewLine 'Press any key to continue...';
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	}


function Run-PyScript
	{
	if (Try-Activate-PythonEnviroment $PY_ENV_FOLDER $True)
		{
		Write-Host "Environment activated. Running script"
		
		py src\main.py		

		deactivate
		}
	else
		{
		Write-Host "Environment failed."
		}
	}
	
Run-PyScript