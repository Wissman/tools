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

read -p 'Entrez l adresse du correspondant : ' nom

while [[ $nb != 5 ]]
do
echo "----------------------------------------------------"
echo "(1) - Crypter Fichier"
echo "(2) - Decrypter Fichier"
echo "(3) - Importer une cle public"
echo "(4) - Exporter ma clé public"
echo "(5) - Exit"
read -p 'Entrez votre choix : ' nb

if test $nb -eq 1
then
read -p 'Entrer le fichier a crypter : ' encrypt
gpg2 --encrypt --sign --armor -r $nom $encrypt
elif test $nb -eq 2
then
read -p 'Entrer le fichier a decrypter : ' decrypt
gpg2 --decrypt-file $decrypt
elif test $nb -eq 3
then
read -p "Entrer l emplacement de la cle publique : " pub
gpg --import $pub
elif test $nb -eq 4
then
gpg --export --armor $nom
else
echo "Cest pas logique "
fi
done
