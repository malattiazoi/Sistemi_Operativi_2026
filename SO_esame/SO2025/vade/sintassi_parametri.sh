### parametri in script bash



#### $1, $2, $3, ...
Argomenti passati allo script (in ordine).
echo "Primo argomento: $1"
echo "Secondo argomento: $2"

# Esempio:
# ./script.sh uno due
# Output: uno, due

# ---

#### $#
Numero totale di argomenti passati allo script o funzione.
echo "Totale argomenti: $#"

# Esempio:
# ./script.sh a b c
# Output: 3

# ---

#### $*
Tutti gli argomenti come un’unica stringa.
for x in $*; do echo "$x"; done

# Esempio:
# ./script.sh "uno due" tre
# Output:
# uno
# due
# tre  ← (divide anche i gruppi tra virgolette!)

# ---

argomenti=("$@")

#### $@
# Tutti gli argomenti come lista separata.
for x in "$@"; do echo "$x"; done

# Esempio:
# ./script.sh "uno due" tre
# Output:
# uno due
# tre  ← (rispetta le virgolette)

# -> Quindi:
# $*  = tutti gli argomenti come UNA sola parola
# "$@" = tutti gli argomenti come parole SEPARATE

# ---

#### $0
Nome dello script o comando corrente.
echo "$0"
# Output: nome del file eseguito (es. ./script.sh)

# ---

#### $?
Codice di uscita (exit code) dell’ultimo comando eseguito.
comando
echo $?
# 0 = successo, diverso da 0 = errore

# Esempio:
ls file_inesistente.txt
echo "Stato: $?"   # Output: 2 (errore)

# ---

#### $!
PID (Process ID) dell’ultimo comando eseguito in background (&).
sleep 30 &
echo "PID del processo: $!"

# Utile per monitorare o terminare processi lanciati in background.

# ---

#### $$
# PID (Process ID) dello script corrente.
echo "PID dello script: $$"

# ---

#### $_
Ultimo argomento dell’ultimo comando eseguito.
ls /etc
echo "$_"
# Output: /etc

# ---

#### $-
Mostra le opzioni attive della shell (es. set -x, -e, ecc.)
echo "$-"

# ---

#### $IFS
Internal Field Separator (usato per separare parole).
Di default è spazio, tab e newline.
echo "$IFS"

# ---

#### Esempio riassuntivo
#!/bin/bash
echo "Script: $0"
echo "Numero argomenti: $#"
echo "Tutti (con \$@): $@"
echo "Tutti (con \"\$@\" in loop):"
for arg in "$@"; do echo " -> $arg"; done


# iterare i parametri

### ITERARE I PARAMETRI IN BASH

#### 1. Loop classico su tutti gli argomenti
for arg in "$@"; do
    echo "Argomento: $arg"
done

# Esempio:
# ./script.sh uno due "tre quattro"
# Output:
# Argomento: uno
# Argomento: due
# Argomento: tre quattro

# "$@" -> tratta ogni argomento separatamente, rispettando le virgolette.

# ---

#### 2. Differenza con $*
for arg in $*; do
    echo "Argomento: $arg"
done

# ./script.sh "uno due" tre
# Output:
# Argomento: uno
# Argomento: due
# Argomento: tre
# (gli argomenti vengono separati anche dentro le virgolette)

# ---

#### 3. Con contatore
i=1
for arg in "$@"; do
    echo "Argomento $i: $arg"
    ((i++))
done

# ./script.sh a b c
# Output:
# Argomento 1: a
# Argomento 2: b
# Argomento 3: c

# ---

#### 4. Dentro una funzione

stampa_argomenti() { #oppure:  function stampa_argomenti {
    echo "Totale: $#"
    for p in "$@"; do
        echo "-> $p"
    done
}

stampa_argomenti "Linux" "Bash" "Script"

# Output:
# Totale: 3
# -> Linux
# -> Bash
# -> Script

# ---

#### 5. Usando shift (per scorrere e consumare argomenti)
while [ $# -gt 0 ]; do
    echo "Primo argomento: $1"
    shift   # sposta i parametri a sinistra: $2 -> $1, $3 -> $2, ecc.
done

# ./script.sh a b c
# Output:
# Primo argomento: a
# Primo argomento: b
# Primo argomento: c

# ---

#### 6. Esempio pratico: opzioni tipo CLI
while [ $# -gt 0 ]; do
    case "$1" in
        -f)
            file="$2"
            echo "File: $file"
            shift 2
            ;;
        -v|--verbose)
            echo "Modalità verbose attiva"
            shift
            ;;
        *)
            echo "Argomento sconosciuto: $1"
            shift
            ;;
    esac
done

####################
#### comando getopts
# script esempio getopts #########################################################

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


# #################################################################################

./esempio_getopts.sh -v -f dati.txt
# Modalità verbosa attivata
# File specificato: dati.txt

./esempio_getopts.sh -f prova.txt
# Nessuna modalità verbosa
# File specificato: prova.txt

## per utilizzare argomenti inseriti di seguito alle opzioni, usare dopo il costrutto getops:
shift $((OPTIND-1))

echo arg2 è $1 # arg2 è ciao
echo arg2 è $2 # arg2 è mondo

./esempio_getopts.sh -v -f dati.txt ciao mondo
##


# "vf:" indica che -v non ha argomento, mentre -f sì (: significa “richiede argomento”).

# $OPTARG contiene l’argomento dell’opzione corrente.

# $OPTIND tiene traccia della posizione corrente nella lista di argomenti.



# "silent error mode" : inizia con ":" per attivare la "silent error mode"
# esempio di silent error mode:
# while getopts ":f:v" opt; do

###################
#### builtin select

echo "Scegli un animale:"
# PS3="Seleziona un animale (numero): "

select animale in cane gatto pappagallo pesce "Esci"; do
  case $animale in
    cane)
      echo "Hai scelto il cane"
      ;;
    gatto)
      echo "Hai scelto il gatto"
      ;;
    pappagallo)
      echo "Hai scelto il pappagallo"
      ;;
    pesce)
      echo "Hai scelto il pesce"
      ;;
    "Esci")
      echo "Ciao!"
      break
      ;;

  esac
done

echo "Hai digitato il numero $REPLY (che corrisponde a $animale)"

# #?	Prompt predefinito mostrato da select
# PS3	Variabile che definisce il testo del prompt
# $REPLY	Contiene il numero digitato dall’utente
# $animale (nel nostro esempio)	Contiene il valore corrispondente nella lista