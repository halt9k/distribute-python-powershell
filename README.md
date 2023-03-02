#  Distribute python with powershell

This powershell commands will help to run python script on the other PC (almost background install or even portable) if
- distributed py script requres non-defualt modules like Tkinter and pandas
- you distribute open-source on Windows which may not have python installed
- your end user wants easy run of scripts because too novice or too enlightened or your end user is auto/offline VM

Common problems with this scenario:
- even if end-user have python, libraries may be missing (pandas, etc)
- end-user may not be skilled enough to install python or may miss install options (for example, he may skip launcher, which is currently most fluent way)
- portable python is not officially supported  
  
### Usage:  
1) Place your script instead of ./test/*, modify Install-Dependencies in ./src/install_py_env.ps1  
#### with end-user download (<1MB):  
2) Copy whole folder to clean VM or test OS (skipping some files possible)  
2) Test creation of virtual environment and pip with install_py_env.bat
3) Test if script works run_test_py_script.bat  

#### or portable usage (experimental, >100MB):  
2) Test creation of portable virtual environment with install_portable_py.bat  
3) Copy whole folder including new large folders ./py_env and ./py_bin to clean VM or test OS (skipping some files possible)  
4) Test if script works run_test_py_script.bat  


