#!/bin/bash

read -p "Introduceti numele pentru logout: " nume

exista=false
for user in "${logged_in_users[@]}"; do
    if [ "$user" == "$nume" ]; then
        exista=true
        logged_in_users=("${logged_in_users[@]/$nume}")
        break
    fi
done

if [ "$exista" = false ]; then
    echo "Utilizatorul '$nume' nu este autentificat."
else
    echo "Utilizatorul '$nume' a fost deconectat cu succes."

    echo "------------Useri-autentificati------------------"
    echo "${logged_in_users[@]}"
fi
