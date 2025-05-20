$PY_INSTALLER_DOWNLOAD_LINK = 'https://www.python.org/ftp/python/3.13.3/python-3.13.3-amd64.exe'

$TMP_FOLDER = '.\tmp'

$PY_BIN_FOLDER = '.\py_bin'
$PY_ENV_FOLDER = '.\py_env'
$ENV_ACTIVATION_CMD = "Scripts\Activate.ps1"



$IS_PORTABLE = $true
# this dir is used only for portable and may still not exist
# order important
$env:Path = $PY_BIN_FOLDER + ';' + $env:Path