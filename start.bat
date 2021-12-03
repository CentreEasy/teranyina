@echo off
set mnemonicOutput=""
set nodeK=""
cd "resources"

if not exist "node-key.txt" (
    frontier-template-node.exe purge-chain --chain teranyina.json -y
    subkey.exe generate-node-key > node-key.txt
    FOR /F "tokens=*" %%g IN ('subkey.exe generate') do (
        echo %%g|find "Secret phrase" >nul
        if not errorlevel 1 (
            echo %%g > mnemoricSeedOut.txt
            (for /f "tokens=2,* delims=`" %%a in (mnemoricSeedOut.txt) do echo %%a ) > mnemoricSeed.txt
            del mnemoricSeedOut.txt
        )
    )
    start /b startNode.bat
)

set /p nodeK=< node-key.txt
set /p mnemoricSeed=< mnemoricSeed.txt
echo %mnemoricSeed%
echo %nodeK%

frontier-template-node.exe key insert --chain teranyina.json --key-type aura --suri "%mnemoricSeed%"
frontier-template-node.exe key insert --chain teranyina.json --key-type gran --scheme Ed25519 --suri "%mnemoricSeed%"

rem hack encoding
start /b EXIT 0

frontier-template-node.exe --chain teranyina.json --validator --rpc-port 8334 --port 30333 --ws-port 9944 --node-key="%nodeK%" --rpc-methods=Unsafe --rpc-external --rpc-cors=all --ws-external --name teranyina --bootnodes /ip4/84.88.144.253/tcp/30333/p2p/12D3KooWL4orhdQao3iErVSGgruU9XkiwWKVZzjJutn1wKg44aAt
