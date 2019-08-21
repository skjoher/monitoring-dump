<# : batch script
@echo off
setlocal
cd %~dp0
powershell -executionpolicy bypass -Command "Invoke-Expression $([System.IO.File]::ReadAllText('%~f0'))"
endlocal
goto:eof
#>
#powershell 2 not soupport ConvertTo-JSON ..... writing ConvertTo-JSON
#get the dir size and convert out into json
function Escape-JSONString($str){
       if ($str -eq $null) {return ""}
       $str = $str.ToString().Replace('"','\"').Replace('\','\\').Replace("`n",'\n').Replace("`r",'\r').Replace("`t",'\t')
       return $str;
}

$nl = [Environment]::NewLine

function ConvertTo-JSON($maxDepth = 4,$forceArray = $false) {
       begin {
              $data = @()
       }
       process{
              $data += $_
       }

       end{

              if ($data.length -eq 1 -and $forceArray -eq $false) {
                     $value = $data[0]
              } else {
                     $value = $data
              }

              if ($value -eq $null) {
                     return "null"
              }



              $dataType = $value.GetType().Name

              switch -regex ($dataType) {
                   'String'  {
                                  return  "`"{0}`"" -f (Escape-JSONString $value )
                           }
                   '(System\.)?DateTime'  {return  "`"{0:yyyy-MM-dd}T{0:HH:mm:ss}`"" -f $value}
                   'Int32|Double' {return  "$value"}
                           'Boolean' {return  "$value".ToLower()}
                   '(System\.)?Object\[\]' { # array

                                  if ($maxDepth -le 0){return "`"$value`""}

                                  $jsonResult = ''
                                  foreach($elem in $value){
                                         #if ($elem -eq $null) {continue}
                                         if ($jsonResult.Length -gt 0) {$jsonResult +=', '}
                                         $jsonResult += ($elem | ConvertTo-JSON -maxDepth ($maxDepth -1))
                                  }
                                  return "[" + $jsonResult + "]"
                   }
                           '(System\.)?Hashtable' { # hashtable
                                  $jsonResult = ''
                                  foreach($key in $value.Keys){
                                         if ($jsonResult.Length -gt 0) {$jsonResult +=', '}
                                         $jsonResult +=
@"
       "{0}": {1}
"@ -f $key , ($value[$key] | ConvertTo-JSON -maxDepth ($maxDepth -1) )
                                  }
                                  return "{" + $jsonResult + "}"
                           }
                   default { #object
                                  if ($maxDepth -le 0){return  "`"{0}`"" -f (Escape-JSONString $value)}

                                  return "{" + $nl +
                                         (($value | Get-Member -MemberType *property | % {
@"
       "{0}": {1}
"@ -f $_.Name , ($value.($_.Name) | ConvertTo-JSON -maxDepth ($maxDepth -1) )

                                  }) -join ', '+$nl) + $nl + "}"
                     }
              }
       }
}


#"a" | ConvertTo-JSON
Get-ChildItem 'C:\Users\appuser\AppData\Local\Temp' -recurse  | Measure-Object -property length -sum | ConvertTo-JSON
