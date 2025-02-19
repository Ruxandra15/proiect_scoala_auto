#!/bin/bash
initial_dir=$(pwd)

declare -a logged_in_users

echo "Alege o optiune:"

while [ 1 != 2 ];
do
	echo "1: Afisare baza de date"
	echo "2: Inregistrarea unui candidat in baza de date"
	echo "3: Login"
	echo "4: Logout"
	echo "5: Genereaza raport"
	echo "6: Sterge candidat din baza de date"
	echo "0: Iesire din program"

	read -p "Optiunea dumneavoastra:" functie

	if [ "$functie" -eq 1 ];then
	echo "--------------------------------------------------"
	cat candidati.csv
	echo "--------------------------------------------------"
	elif [ "$functie" -eq 2 ];then
	echo "--------------------------------------------------"
	./inregistrare.sh
	echo "--------------------------------------------------"
	elif [ "$functie" -eq 3 ];then
	echo "--------------------------------------------------"
	export logged_in_users
	source ./login.sh
	echo "--------------------------------------------------"
	elif [ "$functie" -eq 4 ];then
	echo "--------------------------------------------------"
	export logged_in_users
	source ./logout.sh
	echo "--------------------------------------------------"
	elif [ "$functie" -eq 5 ];then
	echo "--------------------------------------------------"
	./raport.sh
  read -p "Pentru a afisa raportul apasa tasta 1: " tasta
        if [ "$tasta" -eq 1 ]; then
            read -p "Introduceti numele candidatului pentru care ati generat raportul: " nume
            raport_file="homes/$nume/raport.txt"
            if [ -f "$raport_file" ]; then
                echo
                cat "$raport_file"
            else
                echo "Raportul pentru utilizatorul '$nume' nu a fost generat încă sau nu există."
            fi
        
        fi
	echo "--------------------------------------------------"
	elif [ "$functie" -eq 6 ];then
	echo "--------------------------------------------------"
	./stergere.sh
	echo "--------------------------------------------------"
	elif [ "$functie" -eq 0 ];then

	break

	else

	break
fi
cd "$initial_dir"
done
