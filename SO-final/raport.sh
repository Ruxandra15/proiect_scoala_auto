#!/bin/bash

function check_name() {
    nume="$1"
    while IFS=, read -r existing_nume;
     do
        if [[ "$existing_nume" == "$nume" ]]; then
            return 0
        fi
    done < <(tail -n +2 candidati.csv | awk -F ',' '{print $2}')
    return 1
}

while true; do
    read -p "Introduceti numele utilizatorului pentru care doriti generarea unui raport (sau 'exit' pentru a iesi): " nume
    if [ "$nume" == "exit" ]; then
        echo "Iesire din program."
        exit 0
    fi

    if check_name "$nume"; then
        user_home="homes/$nume"
        {
            echo " Raportul pentru utilizatorul $nume"
            echo "-----------------------------------------------"
            echo "Numărul de fișiere: $(find "$user_home" -type f | wc -l)"
            echo "Numărul de directoare: $(find "$user_home" -type d | wc -l)"
            echo "Dimensiunea totală a fișierelor (în bytes): $(du -c "$user_home" | grep total | cut -f 1)"
        } >"$user_home/raport.txt" &
        echo "Raportul este generat asincron pentru utilizatorul '$nume' în directorul '$user_home'."
    else
        echo "Numele '$nume' nu există în fișierul candidati.csv. Vă rugăm să încercați din nou sau tastați 'exit' pentru a ieși."
    fi
done
