#!/bin/bash

# ==============================================================================
# 46. ADVANCED TOOLKIT: ARRAY, STRINGHE E FILE TEMPORANEI (MACOS)
# ==============================================================================
# OBIETTIVO:
# Gestire dati in memoria (Array), manipolare testo senza 'sed' (String Ops),
# creare file temporanei sicuri e confrontare liste (Set Operations).
#
# AMBIENTE:
# - Bash 3.2 (macOS standard): NON supporta array associativi (Key-Value).
# - comm: Comando sottovalutato per intersezioni di file.
# - mktemp: Lo standard per creare file temporanei.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. BASH ARRAYS (VETTORI INDICIZZATI)
# ------------------------------------------------------------------------------
# Utili per accumulare risultati (es. lista di file da processare alla fine).
# ATTENZIONE: Su macOS (Bash 3.2) esistono solo array numerici (0, 1, 2...).
# NON esistono array associativi (Map/Dictionary) come in Bash 4 (Linux).

echo "--- 1. BASH ARRAYS ---"

# 1.1 Dichiarazione e Assegnazione
# Metodo manuale
LISTA_IP=("192.168.1.1" "10.0.0.1" "127.0.0.1")

# 1.2 Aggiungere elementi (Append)
LISTA_IP+=("8.8.8.8")

# 1.3 Leggere elementi
echo "Primo elemento (indice 0): ${LISTA_IP[0]}"
echo "Tutti gli elementi (@):    ${LISTA_IP[@]}"

# 1.4 Contare elementi (#)
echo "Numero totale IP:          ${#LISTA_IP[@]}"

# 1.5 Loop su Array
echo "Iterazione Array:"
for IP in "${LISTA_IP[@]}"; do
    echo "Processing: $IP"
done

# 1.6 Caricare un file in un Array (Riga per riga)
# Utile se devi caricare un file di config in memoria
# ( IFS=$'\n' serve per gestire righe con spazi)
# ListaFile=( $(cat file.txt) ) <- NON FARLO (Rompe con spazi)
# Usa read in un loop o mapfile (ma mapfile non c'è su Mac Bash 3.2!)

# Metodo Mac-Compatible per leggere file in array:
ARRAY_DA_FILE=()
while IFS= read -r RIGA; do
    ARRAY_DA_FILE+=("$RIGA")
done < <(printf "Riga Uno\nRiga Due\nRiga Tre")

echo "Array caricato da input: ${ARRAY_DA_FILE[1]}"


# ------------------------------------------------------------------------------
# 2. MANIPOLAZIONE STRINGHE NATIVA (SENZA SED/AWK)
# ------------------------------------------------------------------------------
# Bash può modificare le variabili direttamente. È molto più veloce di lanciare sed.

echo "----------------------------------------------------------------"
echo "--- 2. STRING MANIPULATION ---"

FILE="immagine_vacanze.2023.jpg"
echo "File originale: $FILE"

# 2.1 Estrazione Sottostringa (${VAR:Start:Length})
# Prendi i primi 8 caratteri
echo "Primi 8 char:   ${FILE:0:8}"
# Prendi dal carattere 9 in poi
echo "Dal 9 in poi:   ${FILE:9}"

# 2.2 Cancellazione Pattern (${VAR#Pattern} / ${VAR%Pattern})
# # = Cancella da SINISTRA (Inizio) - Shortest match
# ## = Cancella da SINISTRA (Inizio) - Longest match
# % = Cancella da DESTRA (Fine) - Shortest match
# %% = Cancella da DESTRA (Fine) - Longest match

# Scenario: Ottenere estensione
EXT="${FILE##*.}"  # Cancella tutto fino all'ultimo punto (da sinistra)
echo "Estensione:     $EXT"

# Scenario: Ottenere nome senza estensione
NAME="${FILE%.*}"  # Cancella dall'ultimo punto in poi (da destra)
echo "Nome pulito:    $NAME"

# 2.3 Sostituzione (${VAR/Old/New})
# / = Sostituisci prima occorrenza
# // = Sostituisci TUTTE le occorrenze

TEXT="Il cane cane abbaia"
echo "Replace 1:      ${TEXT/cane/gatto}"
echo "Replace All:    ${TEXT//cane/gatto}"

# 2.4 Maiuscolo/Minuscolo (Bash 4+ su Linux, MA NON SU MAC BASH 3.2!)
# Su Mac Bash 3.2 ${VAR^^} e ${VAR,,} DANNO ERRORE.
# DEVI usare tr (visto nel File 40).
echo "Su Mac per Uppercase devi usare tr:"
echo "$TEXT" | tr '[:lower:]' '[:upper:]'


# ------------------------------------------------------------------------------
# 3. SET OPERATIONS: COMM (CONFRONTO FILE)
# ------------------------------------------------------------------------------
# Scenario: Hai due liste di utenti (old.txt e new.txt).
# Vuoi sapere:
# - Chi è rimasto (Intersezione)
# - Chi è nuovo (Solo in new)
# - Chi è stato cancellato (Solo in old)
#
# 'comm' richiede file ORDINATI (sort).

echo "----------------------------------------------------------------"
echo "--- 3. COMM (SET OPERATIONS) ---"

# Creiamo file di test ordinati
printf "Alice\nBob\nCarlo\n" > lista_old.txt
printf "Bob\nCarlo\nDaniele\n" > lista_new.txt

# 3.1 Intersezione (Comuni a entrambi)
# -1: sopprimi colonna 1 (solo in A)
# -2: sopprimi colonna 2 (solo in B)
# Resta colonna 3 (comuni)
echo "Utenti comuni (Rimasti):"
comm -12 lista_old.txt lista_new.txt

# 3.2 Solo nel secondo file (Nuovi arrivi)
# -1: via solo A, -3: via comuni. Resta solo B.
echo "Nuovi utenti (Solo in new):"
comm -13 lista_old.txt lista_new.txt

# 3.3 Solo nel primo file (Cancellati)
echo "Utenti rimossi (Solo in old):"
comm -23 lista_old.txt lista_new.txt


# ------------------------------------------------------------------------------
# 4. FILE TEMPORANEI SICURI (MKTEMP)
# ------------------------------------------------------------------------------
# Non usare mai 'touch /tmp/miofile.txt'. Se esiste già o è un link malevolo,
# rischi problemi di sicurezza. Usa mktemp.

echo "----------------------------------------------------------------"
echo "--- 4. MKTEMP & TRAP CLEANUP ---"

# 4.1 Creare un file temporaneo univoco
# -t prefix : Aggiunge un prefisso al nome casuale
TEMP_FILE=$(mktemp -t esame_script)
echo "Creato temp file sicuro: $TEMP_FILE"

# 4.2 Trap di pulizia (Pattern Professionale)
# Assicura che il file venga cancellato quando lo script esce (anche per errore o Ctrl+C)
# EXIT prende tutti i casi di uscita.
cleanup() {
    echo "Pulizia in corso..."
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT

# Usiamo il file
echo "Dati sensibili" > "$TEMP_FILE"
cat "$TEMP_FILE"

# Quando lo script finisce (o qui sotto), trap scatta.


# ------------------------------------------------------------------------------
# 5. GENERARE SEQUENZE E NUMERI CASUALI (MAC vs LINUX)
# ------------------------------------------------------------------------------
# Linux ha 'seq' e 'shuf'.
# macOS ha 'seq' (di solito) e 'jot'.

echo "----------------------------------------------------------------"
echo "--- 5. SEQUENZE E RANDOM ---"

# 5.1 Sequenze (seq)
# seq FIRST LAST
echo "Sequenza:"
seq 1 3

# 5.2 Numeri Casuali (Random)
# $RANDOM è standard Bash (0-32767).
echo "Random Bash: $RANDOM"

# 5.3 Random Range specifico su Mac (jot)
# jot -r [quanti] [min] [max]
echo "Numero random 1-100 (jot):"
jot -r 1 1 100

# 5.4 Mescolare righe (Shuffle)
# Linux: shuf file.txt
# macOS: Non ha shuf! Si usa sort -R (Random sort) o perl.
echo "Shuffle lista (sort -R):"
printf "A\nB\nC\nD\n" | sort -R


# ------------------------------------------------------------------------------
# 6. PARAMETER EXPANSION AVANZATA (DEFAULT VALUES)
# ------------------------------------------------------------------------------
# Utile per gestire argomenti opzionali negli script d'esame.

echo "----------------------------------------------------------------"
echo "--- 6. DEFAULT VALUES ---"

# ${VAR:-DEFAULT} : Se VAR è vuota/nulla, usa DEFAULT.
ARGOMENTO_UTENTE=""
VALORE_FINALE="${ARGOMENTO_UTENTE:-ValoreDiDefault}"

echo "Argomento vuoto -> $VALORE_FINALE"

ARGOMENTO_UTENTE="Ciao"
VALORE_FINALE="${ARGOMENTO_UTENTE:-ValoreDiDefault}"
echo "Argomento pieno -> $VALORE_FINALE"


# ==============================================================================
# 🧩 RIASSUNTO STRUMENTI EXTRA
# ==============================================================================
# | COMANDO/SINTASSI | DESCRIZIONE                                       |
# |------------------|---------------------------------------------------|
# | ${ARR[@]}        | Tutti gli elementi di un array.                   |
# | ${#ARR[@]}       | Numero elementi array.                            |
# | ${VAR#pattern}   | Rimuove prefisso (es. path/to/file -> file).      |
# | ${VAR%pattern}   | Rimuove suffisso (es. file.txt -> file).          |
# | comm -12 A B     | Intersezione (righe presenti in entrambi).        |
# | mktemp -t A      | Crea file temporaneo sicuro in /tmp.              |
# | sort -R          | Shuffle random delle righe (Mac replacement shuf).|
# | jot -r N min max | Genera N numeri random nel range (Mac specific).  |

# Pulizia manuale non serve, ci pensa il trap :)
echo "----------------------------------------------------------------"
echo "Tutorial 46 (Advanced Tools) Completato."