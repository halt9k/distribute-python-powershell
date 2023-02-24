function Assert ([bool]$condition, [string]$msg)
	{
	if ($condition) 
		{ return }
		
	Write-Host ""
	Write-Host "ERROR: $msg"
	Write-Host ""
	Exit
	}


function Ensure-Dir ([string]$dir_path)
	{
	if (Test-Path -Path $dir_path) 
		{ return }

	New-Item -ItemType Directory -Force -Path $dir_path
	}


function Download-File ([string]$link, [string]$target_path)
	{
	if (Test-Path -Path $target_path) 
		{
		Write-Host "Installer already downloaded. Delete manually to retry: $target_path"		
		return
		}
	
	# wget $link -o $target_path
	# Set-ExecutionPolicy -ExecutionPolicy Bypass | RemoteSigned -Scope CurrentUser
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -Uri $link  -OutFile $target_path
	}
