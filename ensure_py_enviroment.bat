// don't close cmd on error
if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )

// "-ExecutionPolicy Bypass" tries to surpress standard powershell restriction
powershell -ExecutionPolicy Bypass .\env\ensure_enviroment.ps1