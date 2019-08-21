<# : batch script
@echo off
setlocal
cd %~dp0
powershell -executionpolicy bypass -Command "Invoke-Expression $([System.IO.File]::ReadAllText('%~f0'))"
endlocal
goto:eof
#>
# here write your powershell commands...
Get-ChildItem C:\\Users\\Administrator\\AppData\\Local\\Temp -recurse  | Measure-Object -property length -sum | ConvertTo-json
