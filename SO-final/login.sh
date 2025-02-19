#!/bin/bash

function check_name() {
    local username="$1"
    local OK=0

    while IFS=, read -r existing_nume; do
        if [ "$existing_nume" == "$username" ]; then
            OK=1
            break
        fi
    done < <(tail -n +2 candidati.csv | awk -F ',' '{print $2}')

    echo "$OK"
}

function check_password() {
    local username="$1"
    local password="$2"
    local OK=0

    while IFS=, read -r existing_id existing_nume existing_prenume existing_varsta existing_categorie existing_cutie_v existing_punctaj existing_email existing_parola data_traseu_last_login; do
        if [[ "$username" == "$existing_nume" && "$password" == "$existing_parola" ]]; then
            OK=1
            break
        fi
    done < <(tail -n +2 candidati.csv)

    echo "$OK"
}

read -p "Introduceti numele: " nume

exista=false

for user in "${logged_in_users[@]}"; do
    if [ "$user" == "$nume" ]; then
        exista=true
        break
    fi
done

if [ "$exista" = true ]; then
    echo "$nume este deja logat!"
else
    if [ "$(check_name "$nume")" -eq 1 ]; then
        read -p "Introduceti parola: " parola

        if [ "$(check_password "$nume" "$parola")" -eq 1 ]; then
            echo "V-ati autentificat cu succes! Bun venit, $nume!"

            logged_in_users+=("$nume")

            data_noua=$(date +%Y-%m-%d:%H:%M:%S)

            awk -v name="$nume" -v new_date="$data_noua" 'BEGIN {FS=OFS=","} $2 == name {$11=new_date}1' candidati.csv > temp.csv && mv temp.csv candidati.csv

            cd "./homes/$nume"
        else
            echo "Parola incorecta"
        fi
    else
        echo "Utilizatorul nu este inregistrat!"
    fi
fi
echo "--------------Useri-autentificati-----------------"
echo "${logged_in_users[@]}"
