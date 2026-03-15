#!/usr/bin/bash


nome="mario"
nome_esteso="valentino rossi"


echo nome
echo $nome
echo $nome_esteso


affermazione="$nome_esteso è velocissimo"

echo $affermazione

a="giovanni"

echo "$aiiiiii"
echo "${a}iiiiii"

echo ======

read -p "inserisci primo numero: " x
read -p "inserisci secondo numero: " y
risultato=$(echo "$x+$y" | bc)

echo "la somma è $risultato"




