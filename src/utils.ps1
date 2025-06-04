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


function Download-File([string]$url, [string]$target_path)
	{
	if (Test-Path -Path $target_path) 
		{
		INFO "Installer already downloaded. Delete manually to retry: $target_path"
		return
		}

	# from
	# https://github.com/freeload101/Java-Android-Magisk-Burp-Objection-Root-Emulator-Easy/blob/02da803c9395c69ef6d3795f65ae6fce0c28bfd6/JAMBOREE.ps1#L473
    "Downloading $url"
    $uri = New-Object "System.Uri" "$url"
    $request = [System.Net.HttpWebRequest]::Create($uri)
    $request.set_Timeout(15000) #15 second timeout
    $response = $request.GetResponse()
    $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
    $responseStream = $response.GetResponseStream()
    $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $target_path, Create
    $buffer = new-object byte[] 10KB
    $count = $responseStream.Read($buffer,0,$buffer.length)
    $downloadedBytes = $count
    while ($count -gt 0)
		{
        #[System.Console]::CursorLeft = 0
        #[System.Console]::Write("Downloaded {0}K of {1}K", [System.Math]::Floor($downloadedBytes/1024), $totalLength)
        $targetStream.Write($buffer, 0, $count)
        $count = $responseStream.Read($buffer,0,$buffer.length)
        $downloadedBytes = $downloadedBytes + $count
		}
    "Finished Download"
    $targetStream.Flush()
    $targetStream.Close()
    $targetStream.Dispose()
    $responseStream.Dispose()
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


