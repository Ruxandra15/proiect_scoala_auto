#!/bin/bash

read -p "Introduceți ID-ul candidatului pe care doriți să-l ștergeți din baza de date: " id
while [[ ! $id =~ ^[0-9][0-9]$ ]]
do
    echo "ID-ul trebuie să fie format din 2 cifre."
    read -p "Vă rugăm să reintroduceți ID-ul: " id
done

grep -q "^$id," candidati.csv

if [ $? -eq 1 ]; then
    echo "Nu a fost găsită nicio înregistrare cu ID-ul $id!"
else
    sed -i "/^$id,/d" candidati.csv
    echo "Candidatul cu ID-ul $id a fost șters!"
fi
