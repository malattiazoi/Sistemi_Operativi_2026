#!/bin/bash

# ==============================================================================
# 55. BASI DI PROGRAMMAZIONE BASH: SUBSTITUTION, QUOTING & EXPANSION
# ==============================================================================
# OBIETTIVO:
# Capire come Bash manipola i dati PRIMA di eseguire i comandi.
#
# CONCETTI CHIAVE:
# 1. Command Substitution: $(cmd) -> Esegui comando e usa il risultato.
# 2. Arithmetic Expansion: $((1+1)) -> Fai calcoli matematici.
# 3. Quoting: "..." vs '...' -> Quando espandere le variabili e quando no.
# 4. Parameter Expansion: ${VAR:-default} -> Manipolare variabili.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. COMMAND SUBSTITUTION $() - IL CUORE DEGLI SCRIPT
# ------------------------------------------------------------------------------
# Permette di catturare l'output di un comando e salvarlo in una variabile
# o usarlo come argomento per un altro comando.
#
# SINTASSI MODERNA (Consigliata): $(comando)
# SINTASSI VECCHIA (Sconsigliata): `comando` (Backticks)

echo "--- 1. COMMAND SUBSTITUTION ---"

# Esempio A: Salvare la data in una variabile
OGGI=$(date +%Y-%m-%d)
echo "Oggi è: $OGGI"

# Esempio B: Usare l'output di 'find' per contare i file
# 1. Esegue 'find . -type f'
# 2. Passa il risultato a 'wc -l'
# 3. Sostituisce tutto il blocco $() con il numero finale
NUM_FILE=$(find . -type f | wc -l)
echo "Ci sono $NUM_FILE file nella cartella corrente."

# Esempio C: Nesting (Annidamento) - Solo con $()
# "Dimmi chi è il proprietario del file che ho appena creato"
touch test.txt
OWNER=$(ls -l $(basename "test.txt") | awk '{print $3}')
echo "Il proprietario è: $OWNER"

# NOTA COMPITINO 1:
# "Si usino almeno due command substitutions" significa che devi fare cose tipo:
# RIGHE_A=$(wc -l < fileA.txt)
# RIGHE_B=$(wc -l < fileB.txt)
# if [ "$RIGHE_A" -eq "$RIGHE_B" ]; then ...


# ------------------------------------------------------------------------------
# 2. ARITHMETIC EXPANSION $((...)) - MATEMATICA INTERA
# ------------------------------------------------------------------------------
# Bash sa fare solo calcoli INTERI (niente virgola).
# Sintassi: $(( espressione ))

echo "----------------------------------------------------------------"
echo "--- 2. ARITMETICA ---"

A=10
B=5

# Somma
SOMMA=$((A + B))
echo "$A + $B = $SOMMA"

# Incremento (stile C)
((A++))
echo "A incrementato: $A"

# Operatore Ternario (Simil-IF rapido)
# Condizione ? Vero : Falso
VALORE=$(( A > 5 ? 100 : 0 ))
echo "Poiché A > 5, Valore è: $VALORE"


# ------------------------------------------------------------------------------
# 3. QUOTING: DOPPIE VS SINGOLE
# ------------------------------------------------------------------------------
# REGOLA D'ORO:
# "..." (Soft Quote): Espande variabili ($VAR) e command sub $(cmd).
# '...' (Hard Quote): NON espande nulla. Tutto è testo letterale.

echo "----------------------------------------------------------------"
echo "--- 3. QUOTING RULES ---"

NOME="Mario"

echo "Doppie:  Ciao $NOME"  # Output: Ciao Mario
echo 'Singole: Ciao $NOME'  # Output: Ciao $NOME (Letterale)

# Esempio pericoloso con Command Substitution
echo "Doppie:  Oggi è $(date)" # Esegue date
echo 'Singole: Oggi è $(date)' # Stampa la stringa $(date)

# QUANDO USARE LE SINGOLE?
# Quando passi stringhe speciali a comandi come awk, sed o grep che usano $ per altro.
# Esempio: awk '{print $1}' (Se usi le doppie, Bash prova a espandere $1 prima di awk!)


# ------------------------------------------------------------------------------
# 4. PARAMETER EXPANSION ${...} - MANIPOLAZIONE VARIABILI
# ------------------------------------------------------------------------------
# Bash può modificare le variabili mentre le legge.

echo "----------------------------------------------------------------"
echo "--- 4. PARAMETER EXPANSION ---"

FILE="foto_vacanze.jpg"

# 4.1 Lunghezza stringa ${#VAR}
echo "Lunghezza nome file: ${#FILE} caratteri"

# 4.2 Valore di Default ${VAR:-default}
# Se UTENTE è vuoto, usa "Ospite"
UTENTE=""
echo "Benvenuto, ${UTENTE:-Ospite}"

# 4.3 Rimozione Prefisso/Suffisso
# %  = Rimuovi dalla fine (Suffisso) -> Utile per togliere estensioni
# #  = Rimuovi dall'inizio (Prefisso) -> Utile per togliere percorsi
echo "Senza estensione (%): ${FILE%.*}"
echo "Solo estensione (#):  ${FILE#*.}"

# 4.4 Sostituzione stringa ${VAR/old/new}
MESSAGGIO="Il cane abbaia al cane"
echo "Sostituisci primo: ${MESSAGGIO/cane/gatto}"
echo "Sostituisci tutti: ${MESSAGGIO//cane/gatto}"


# ------------------------------------------------------------------------------
# 5. HERE DOCUMENTS E HERE STRINGS
# ------------------------------------------------------------------------------
# Passare blocchi di testo ai comandi senza creare file temporanei.

echo "----------------------------------------------------------------"
echo "--- 5. HERE DOCS & STRINGS ---"

# HERE STRING (<<<)
# Passa una stringa come se fosse un file in input.
# Invece di: echo "testo" | grep "t"
grep "Mondo" <<< "Ciao Mondo, come va?"

# HERE DOCUMENT (<<EOF)
# Passa più righe di testo a un comando.
cat <<EOF > lista_spesa.txt
Pane
Latte
Uova
EOF

echo "File creato al volo:"
cat lista_spesa.txt

# Trucco: <<'EOF' (con apici) impedisce l'espansione delle variabili nel blocco.
# Utile se stai generando un altro script bash.
cat <<'EOF'
Variabile non espansa: $HOME
EOF


# ==============================================================================
# 🧩 ESEMPIO PRATICO: SOLUZIONE COMPITINO 1 (ESTRATTO)
# ==============================================================================
# "Scrivere uno script che confronti il numero di righe... si usino almeno due
# command substitutions."

echo "----------------------------------------------------------------"
echo "--- SIMULAZIONE COMPITINO 1 ---"

FILE_1="lista_spesa.txt"
FILE_2="test.txt"

# Command Substitution 1: Contare righe File 1
# (Uso < per evitare che wc stampi il nome del file)
RIGHE_1=$(wc -l < "$FILE_1")

# Command Substitution 2: Contare righe File 2
RIGHE_2=$(wc -l < "$FILE_2")

# Utilizzo di Arithmetic Expansion nei test
# Nota: [ ... ] usa -eq, ma (( ... )) usa ==.
if (( RIGHE_1 == RIGHE_2 )); then
    echo "I file hanno lo stesso numero di righe ($RIGHE_1)."
else
    # Arithmetic Expansion per calcolare la differenza
    DIFF=$(( RIGHE_1 - RIGHE_2 ))
    # Valore assoluto (quick hack: togliere il meno se c'è)
    echo "Differenza: ${DIFF#-}"
fi

# Pulizia
rm -f test.txt lista_spesa.txt
echo "----------------------------------------------------------------"
echo "Tutorial 55 (Basi Programmazione) Completato."