$cookievalue = get-content .\Cookie.txt
$cookie = New-Object system.net.cookie
$cookie.name="session"
$cookie.domain = "adventofcode.com"
$cookie.Value=$cookievalue
$websession = new-object Microsoft.PowerShell.Commands.WebRequestSession
$websession.cookies.add($cookie)
$inputdata = Invoke-RestMethod -Uri https://adventofcode.com/2020/day/12/input -Method GET -WebSession $websession
