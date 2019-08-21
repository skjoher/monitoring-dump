<# : batch script
@echo off
setlocal
cd %~dp0
powershell -executionpolicy bypass -Command "Invoke-Expression $([System.IO.File]::ReadAllText('%~f0'))"
endlocal
goto:eof
#>
# here write your powershell commands...
$f = new-object System.IO.FileStream C:\Users\appuser\AppData\Local\Temp\test.dat, Create, ReadWrite
$f.SetLength(1MB)
$f.Close()
Get-ChildItem -Recurse 'C:\Users\appuser\AppData\Local\Temp' | Measure-Object -Property Length -Sum | ConvertTo-json
