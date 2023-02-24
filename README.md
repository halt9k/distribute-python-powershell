# python-powershell-setup

Use case:
- you distribute python script which requres Tkinter and other dependencies
- your end user wants to see code transparently (no binary) and uses Windows and may not have python installed
- your end user wants easy 1-click run of script

Hinders:
- portable python have excessive size (200MB+) and prohibited by Tkinter license limitations
- even if end-user have python, he may lack libraries (pandas, etc)
- end user may not be able to select install options properly (for example, to skip py launcher)

This 1-click powershell installer supposed to ensure virtual environment and pip install.  
Dependencies are customised in ensure_enviroment.ps1 -> Install-Dependencies.
