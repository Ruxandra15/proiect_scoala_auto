#!/bin/bash

mkdir -p homes

if [ $(wc -l < candidati.csv) -eq 1 ]; then
    last_id=0
else
    last_id=$(tail -n 1 candidati.csv | sed 's/^\([^,]*\),.*/\1/')
fi

next_id=$(printf "%02d" $((10#$last_id + 1)))

function is_valid_name() {
      text="$1"
    if [[ "$text" =~ ^[A-Za-z]+$ ]]; then
        return 0
    else
        return 1
    fi
}

function check_duplicate_name(){
    nume="$1"
    while IFS=, read -r existing_id existing_nume existing_prenume existing_varsta existing_categorie existing_cutie_v existing_punctaj existing_email existing_parola;
    do
      if [[ "$existing_nume" == "$nume" ]]; then
         echo "Numele '$nume' există deja în fișier."
            return 1
      fi
    done < <(tail -n +2 candidati.csv)
    return 0
}

read -p "Introduceti numele:" nume
while ! is_valid_name "$nume";
do
   echo "Numele trebuie sa contina doar litere'"
   read -p "Va rugam sa reintroduceti numele:" nume
done

while ! check_duplicate_name "$nume";
do
    read -p "Vă rugăm să reintroduceți un alt nume:" nume
    while ! is_valid_name "$nume";
    do
        echo "Numele trebuie să conțină doar litere."
        read -p "Vă rugăm să reintroduceți numele:" nume
    done
done

read -p "Introduceti prenumele:" prenume
while ! is_valid_name "$prenume";
do
    echo "Prenumele trebuie să conțină doar litere."
    read -p "Vă rugăm să reintroduceți prenumele:" prenume
done

read -p "Introduceti varsta:" varsta
if [ "$varsta" -lt 18 ]; then
    echo "Varsta trebuie să fie de cel puțin 18 ani."
    exit 1
fi

read -p "Introduceti categoria auto:" categorie
while [[ ! "$categorie" =~ ^[A-Z][0-9]+$ && ! "$categorie" =~ ^[A-Z]$ ]];
do
    echo "Nu există o astfel de categorie auto."
    read -p "Vă rugăm să reintroduceți categoria (ex: A1, B, B1, C):" categorie
done

read -p "Introduceti tipul cutiei de viteza a masinii (automata/manuala):" cutie_v
while [[ ! "$cutie_v" =~ ^(automata|manuala)$ ]];
do
    echo "Tipul cutiei de viteze poate fi doar 'automata' sau 'manuala'."
    read -p "Va rugam sa reintroduceti tipul cutiei:" cutie_v
done

read -p "Introduceti punctajul obtinut la examenul teoretic:" punctaj
while [[ ! "$punctaj" =~ ^[0-9]+$ ]];
do
    echo "Punctajul trebuie să conțină doar cifre."
    read -p "Va rugam sa reintroduceti punctajul:" punctaj
done

read -p "Introduceti email:" email
while [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]] ;
do
    echo "Va rugam sa introduceti un email valid."
    read -p "Introduceti email:" email
done

read -p "Introduceti parola:" parola
while [[ ${#parola} -lt 8 || ! "$parola" =~ [A-Za-z] || ! "$parola" =~ [0-9] || ! "$parola" =~ [^A-Za-z0-9] ]];
do
    echo "Parola trebuie sa contina cel putin 8 caractere, cel putin o litera mare, una mica, o cifra si un caracter special."
    read -p "Introduceti parola:" parola
done

if [ "$punctaj" -ge 22 ]; then

   current_year=$(date +%Y)
   random_month=$(printf "%02d" $((RANDOM % 12 + 1)))
   random_day=$(printf "%02d" $((RANDOM % 28 + 1))) # ziua 1-28 pentru a evita probleme cu diferite luni
   random_hour=$(printf "%02d" $((RANDOM % 11 + 8))) # ora între 08 și 18
   random_minute=$(printf "%02d" $((RANDOM % 60)))
   data_programarii="$current_year-$random_month-$random_day $random_hour:$random_minute"
else
   data_programarii="respins examen teoretic"
fi

last_login=$(date +%Y-%m-%d:%H:%M:%S)

echo "$next_id,$nume,$prenume,$varsta,$categorie,$cutie_v,$punctaj,$email,$parola,$data_programarii,$last_login" >> candidati.csv

mkdir -p "homes/$nume"

echo
echo "Candidatul a fost inregistrat cu succes!"
echo "A fost creat cu succes directorul $nume!"

if [ "$data_programarii" != "respins examen teoretic" ]; then
	echo "$nume a fost programat la traseu pe data de: $data_programarii!"
fi
