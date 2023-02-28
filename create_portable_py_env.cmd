REM don't close cmd on error
if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )

REM "-ExecutionPolicy Bypass" tries to surpress standard powershell restriction
powershell -ExecutionPolicy Bypass .\env\create_portable_py_env.ps1