function MSG ($type, $args_arr)
	{
	$msg = $args_arr -join ' '
	Write-Host ($type + ': ' + $msg)
	}


function INFO #$args
	{ MSG 'INFO' $args }


function WARN #$args
	{ MSG "`n WARN" $args }


function MSG_ERROR #$args
	{ MSG "`n ERROR" $args }



function Assert ([bool]$condition, [string]$msg)
	{
	if ($condition) 
		{ return }
		
	MSG_ERROR $msg
	Exit
	}


function Wait-UserInput 
	{
	INFO -NoNewLine 'Press any key to continue...';
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	}


function Detect-PowershellISE
	{
	return $host.name -like "*ISE*"
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
		INFO "Installer already downloaded. Delete manually to retry: $target_path"
		return
		}
	
	# wget $link -o $target_path
	# Set-ExecutionPolicy -ExecutionPolicy Bypass | RemoteSigned -Scope CurrentUser
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -Uri $link  -OutFile $target_path
	}


function Compare-Arrays ($arr1, $arr2)
	{
	return @(Compare-Object $content $replaced -SyncWindow 0).Length -eq 0
	}


function Replace-FileText ([string]$file_path, [string]$find, [string]$replace)
	{
	$content = Get-Content $file_path
	$replaced = $content.replace($find, $replace)
	
	if (-not (Compare-Arrays ($content, $replaced)))
		{
		Write-Host $file_path
		Set-Content $file_path $replaced 
		}
	}


