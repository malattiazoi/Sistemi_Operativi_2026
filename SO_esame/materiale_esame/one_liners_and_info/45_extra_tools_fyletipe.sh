#!/bin/bash

# ==============================================================================
# 45. EXTRA TOOLS: FILE TYPE, TYPING INPUT & RANKING (MACOS)
# ==============================================================================
# OBIETTIVO:
# Strumenti specifici per risolvere ESAME 93 (Typing Test), COMPITINO 1 e 2.
#
# COSA IMPAREREMO:
# 1. Capire se un file è di testo o binario (comando 'file').
# 2. Pulire l'output di 'wc -l' per usare i numeri negli IF.
# 3. Rilevare la pressione di un SINGOLO tasto (senza premere Invio).
# 4. Creare una classifica (Ranking) e trovare la propria posizione.
# 5. Distinguere se siamo su Mac o Linux (uname).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. RICONOSCERE IL TIPO DI FILE (COMANDO FILE)
# ------------------------------------------------------------------------------
# Compitino 2 chiede: "conta righe solo se è un file di testo".
# Non fidarti dell'estensione .txt! Un file senza estensione può essere testo.

echo "--- 1. FILE TYPE CHECK ---"

# Creiamo due file per test
echo "Ciao Mondo" > testo.txt
printf "\x00\x01\x02" > binario.dat

# Metodo A: Output Umano
# file testo.txt -> "testo.txt: ASCII text"
file testo.txt

# Metodo B: Output MIME-Type (--mime-type) - PERFETTO PER GLI IF
# Stampa "text/plain", "application/pdf", "image/jpeg"
MIME=$(file --mime-type -b testo.txt)
echo "Mime Type testo: $MIME"

MIME_BIN=$(file --mime-type -b binario.dat)
echo "Mime Type binario: $MIME_BIN"

# Esempio Logica Compitino 2
if [[ "$MIME" == text/* ]]; then
    echo "[OK] È un file di testo, posso contare le righe."
else
    echo "[NO] È binario, salto."
fi


# ------------------------------------------------------------------------------
# 2. CONTARE RIGHE IN MODO PULITO (WC TRICK)
# ------------------------------------------------------------------------------
# Compitino 1 chiede di confrontare numeri.
# PROBLEMA MACOS: 'wc -l file' stampa "       8 file.txt" (spazi + nome).
# Bash non riesce a fare matematica con gli spazi: if [ "   8" -eq "8" ] -> Errore.

echo "----------------------------------------------------------------"
echo "--- 2. CLEAN LINE COUNTING ---"

FILE="testo.txt"

# Metodo Sbagliato (Sporco)
RIGHE_SPORCHE=$(wc -l "$FILE")
echo "Sporco: '$RIGHE_SPORCHE'" # Include nome file e spazi

# Metodo 1: Redirezione (<)
# Se passi il file come input standard, wc non stampa il nome, ma lascia gli spazi.
RIGHE_SEMIPULITE=$(wc -l < "$FILE")
echo "Semipulito: '$RIGHE_SEMIPULITE'" # Solo spazi

# Metodo 2: AWK (IL MIGLIORE)
# Stampa solo la prima colonna. Toglie spazi e nomi.
RIGHE_PULITE=$(wc -l "$FILE" | awk '{print $1}')
echo "Pulito (Awk): '$RIGHE_PULITE'"

# Metodo 3: TR (Toglie spazi)
RIGHE_TR=$(wc -l < "$FILE" | tr -d ' ')
echo "Pulito (Tr): '$RIGHE_TR'"


# ------------------------------------------------------------------------------
# 3. INPUT TASTO PER TASTO (READ -N 1) - CRITICO ESAME 93
# ------------------------------------------------------------------------------
# Esame 93: "Il tempo parte quando tocchi il PRIMO tasto".
# 'read' normale aspetta INVIO. Non va bene.
# 'read -n 1' ritorna appena premi 1 tasto.

echo "----------------------------------------------------------------"
echo "--- 3. KEYPRESS DETECTION ---"

echo "Premi un tasto qualsiasi per partire..."
# -n 1 : Leggi 1 carattere
# -s : Silent (non mostrare il carattere a video se non vuoi)
read -n 1 -s TASTO_START

START_TIME=$(date +%s)
echo "Partito! (Primo tasto premuto)"

# Esempio Loop di scrittura (Simulazione Esame 93)
# "Fermati quando l'utente ha scritto la frase target"

TARGET="ciao"
INPUT_STR=""

echo "Scrivi '$TARGET' (carattere per carattere):"

while [ "$INPUT_STR" != "$TARGET" ]; do
    # Leggi 1 carattere alla volta
    read -n 1 -s CHAR
    
    # Aggiungi alla stringa accumulata
    INPUT_STR="${INPUT_STR}${CHAR}"
    
    # Stampa a video (perché -s lo nascondeva)
    echo -n "$CHAR"
    
    # Controllo lunghezza per evitare loop infiniti
    if [ ${#INPUT_STR} -ge ${#TARGET} ] && [ "$INPUT_STR" != "$TARGET" ]; then
        echo ""
        echo "Hai sbagliato frase! Riprova."
        break
    fi
done
echo ""
echo "Bravo! Hai scritto: $INPUT_STR"


# ------------------------------------------------------------------------------
# 4. CLASSIFICHE E RANKING (SORT E GREP -N)
# ------------------------------------------------------------------------------
# Esame 93: "Stampare la posizione in classifica".
# Logica:
# 1. Salvi il tuo tempo in un file "tempi.txt".
# 2. Ordini il file (dal più veloce al più lento).
# 3. Cerchi a che riga è finito il tuo tempo.

echo "----------------------------------------------------------------"
echo "--- 4. RANKING SYSTEM ---"

SCORE_FILE="classifica.txt"
# Creiamo una classifica finta
echo "45" > $SCORE_FILE
echo "12" >> $SCORE_FILE
echo "30" >> $SCORE_FILE

MIO_TEMPO="20"

echo "Il mio tempo: $MIO_TEMPO secondi."

# 1. Aggiungo il mio tempo
echo "$MIO_TEMPO" >> $SCORE_FILE

# 2. Calcolo la posizione
# sort -n : Ordina numerico (12, 20, 30, 45)
# cat -n  : Aggiunge il numero di riga (che equivale alla posizione!)
# grep -w : Cerca il mio numero esatto
# awk     : Estrae solo il numero di riga (posizione)

POSIZIONE=$(sort -n "$SCORE_FILE" | cat -n | grep -w "$MIO_TEMPO" | awk '{print $1}')

echo "Sei arrivato in posizione: $POSIZIONE su $(wc -l < $SCORE_FILE)"


# ------------------------------------------------------------------------------
# 5. RICONOSCERE IL SISTEMA OPERATIVO (UNAME)
# ------------------------------------------------------------------------------
# Esame 93: "Per Mac dare tempo in secondi. Per Linux in millisecondi."
# Bisogna sapere dove siamo.

echo "----------------------------------------------------------------"
echo "--- 5. OS DETECTION ---"

OS_NAME=$(uname -s)
echo "Sistema rilevato: $OS_NAME"

if [ "$OS_NAME" == "Darwin" ]; then
    echo "Siamo su macOS."
    # Mac non ha nanosecondi (%N) in date nativo
    NOW=$(date +%s)
    echo "Tempo (sec): $NOW"
elif [ "$OS_NAME" == "Linux" ]; then
    echo "Siamo su Linux."
    # Linux supporta nanosecondi
    # NOW=$(date +%s%3N) # Millisecondi (non eseguibile su Mac)
    echo "Userei 'date +%s%3N'"
fi


# ==============================================================================
# ⚠️ RIASSUNTO STRUMENTI
# ==============================================================================
# | COMANDO          | FLAG          | UTILIZZO                                |
# |------------------|---------------|-----------------------------------------|
# | file             | --mime-type   | Capire se è "text/plain" o binario.     |
# | wc -l file       | | awk '{print $1}' | Pulire spazi per confronti if.     |
# | read             | -n 1          | Leggere UN solo tasto (start timer).    |
# | read             | -s            | Silent (non mostrare digitazione).      |
# | uname            | -s            | "Darwin" (Mac) vs "Linux".              |
# | sort             | -n            | Ordinare numeri (Classifica).           |
# | cat              | -n            | Numerare righe (Trovare posizione).     |

# Pulizia
rm -f testo.txt binario.dat classifica.txt
echo "----------------------------------------------------------------"
echo "Tutorial 45 (Extra Exams Tools) Completato."