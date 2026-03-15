#!/bin/bash

# Inizializziamo variabili
verbose=0
filename=""

# Analizziamo le opzioni
while getopts "vf:" opt; do
  case $opt in
    v)
      verbose=1
      ;;
    f)
      filename=$OPTARG
      ;;
    :)
      echo "Errore: l'opzione -$OPTARG richiede un argomento!"
      ;;
    \?)
    echo "Uso: $0 [-v] [-f filename]"
      exit 1
      echo "Errore: opzione -$OPTARG non riconosciuta!"
      ;;
    *)
      echo "Caso generico catturato (*): $opt"
      ;;

  esac
done

# Mostra i risultati
if [[ $verbose -eq 1 ]]; then
  echo "Modalità verbosa attivata"
fi

if [[ -n $filename ]]; then
  echo "File specificato: $filename"
else
  echo "Nessun file specificato"
fi



./esempio_getopts.sh -v -f dati.txt
# Modalità verbosa attivata
# File specificato: dati.txt

./esempio_getopts.sh -f prova.txt
# Nessuna modalità verbosa
# File specificato: prova.txt


# Note:
# while getopts ":f:v" opt; do
# Il : iniziale dice a getopts di non mostrare automaticamente errori, ma di impostare opt a : quando manca un argomento.
# Senza il : iniziale, Bash scriverebbe da solo messaggi d’errore tipo:
# getopts: option requires an argument -- f


######


# Uso di select
# select serve per creare menu interattivi nei terminali Bash.

echo "Scegli un animale:"
# PS3='>>:'
select animale in cane gatto pappagallo pesce "Esci"; do
  case $animale in
    cane)
      echo "Hai scelto il cane 🐶"
      ;;
    gatto)
      echo "Hai scelto il gatto 🐱"
      ;;
    pappagallo)
      echo "Hai scelto il pappagallo 🦜"
      ;;
    pesce)
      echo "Hai scelto il pesce 🐟"
      ;;
    "Esci")
      echo "Ciao!"
      break
      ;;
    *)
      echo "Scelta non valida!"
      ;;
  esac
done
