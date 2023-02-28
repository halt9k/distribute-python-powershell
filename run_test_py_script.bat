REM don't close cmd
if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )

REM "-ExecutionPolicy Bypass" tries to surpress standard powershell ExecutionPolicy restriction
powershell -ExecutionPolicy Bypass ".\src\run_py_script.ps1 test\test_main.py"