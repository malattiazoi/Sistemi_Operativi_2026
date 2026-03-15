#!/bin/bash

# ==============================================================================
# 07. GESTIONE DATE E TEMPO: IL COMANDO DATE (MACOS / BSD EDITION)
# ==============================================================================
# OBIETTIVO:
# Gestire timestamp, log, backup datati e calcoli temporali.
#
# DIFFERENZA CRITICA MACOS vs LINUX:
# - Linux (GNU): Usa `date --date="yesterday"`.
# - macOS (BSD): Usa `date -v-1d` (Adjust Value).
#
# Se usi la sintassi Linux su Mac, riceverai "illegal option -- -".
# Questo file insegna ESCLUSIVAMENTE la sintassi corretta per macOS.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. FORMATTAZIONE BASE (OUTPUT ESTETICO)
# ------------------------------------------------------------------------------
# Sintassi: date "+FORMATO"
# Il simbolo '+' è obbligatorio prima della stringa di formato.

echo "--- 1. FORMATTAZIONE BASE ---"

# Data completa default
echo "Default:"
date

# Formato ISO standard (YYYY-MM-DD) - IL PIÙ USATO NEI LOG
echo "ISO Date:"
date "+%Y-%m-%d"

# Formato Orario (HH:MM:SS)
echo "Orario:"
date "+%H:%M:%S"

# Combinazione per nomi file di backup
# Esempio: backup_20231025_1430.tar.gz
FILE_NAME="backup_$(date +%Y%m%d_%H%M).tar.gz"
echo "Nome file generato: $FILE_NAME"

# Includere testo arbitrario (bisogna proteggere gli spazi o usare virgolette)
echo "Log style:"
date "+[LOG %Y-%m-%d %H:%M:%S] Operazione completata"


# ------------------------------------------------------------------------------
# 2. TIMESTAMP UNIX (EPOCH) - FONDAMENTALE PER I CALCOLI
# ------------------------------------------------------------------------------
# L'Epoch è il numero di secondi passati dal 1 Gennaio 1970 (UTC).
# È l'unico modo sano per fare matematica con le date (es. Differenza tra due orari).
# Flag: %s

echo "----------------------------------------------------------------"
echo "--- 2. TIMESTAMP (EPOCH) ---"

TIMESTAMP=$(date +%s)
echo "Secondi dal 1970: $TIMESTAMP"

# Esempio pratico: Generare un ID univoco temporaneo
TEMP_ID="session_$(date +%s)"
echo "Session ID: $TEMP_ID"


# ------------------------------------------------------------------------------
# 3. VIAGGIARE NEL TEMPO (FLAG -v) - SPECIFICO MACOS
# ------------------------------------------------------------------------------
# Come ottenere "ieri", "domani", "tra un'ora", "l'anno scorso"?
# Su Mac si usa il flag -v (Adjust Value).
# Sintassi: -v[+|-][valore][unità]
# Unità: y (anno), m (mese), w (settimana), d (giorno), H (ora), M (minuto), S (secondo).

echo "----------------------------------------------------------------"
echo "--- 3. ADJUST TIME (FLAG -v) ---"

# IERI (-1 giorno)
echo "Ieri era:"
date -v-1d "+%Y-%m-%d"

# DOMANI (+1 giorno)
echo "Domani sarà:"
date -v+1d "+%Y-%m-%d"

# TRA UN'ORA
echo "Tra un'ora sarà:"
date -v+1H "+%H:%M"

# L'ANNO SCORSO
echo "Un anno fa:"
date -v-1y "+%Y"

# COMBINAZIONI COMPLESSE
# Esempio: "3 settimane fa, di martedì" (Si possono concatenare più -v)
# Nota: Su Mac si può forzare il giorno della settimana.
# Ma l'uso più comune è sottrarre tempo.
echo "Meno 1 mese e meno 2 giorni da oggi:"
date -v-1m -v-2d "+%Y-%m-%d"


# ------------------------------------------------------------------------------
# 4. PARSING E CONVERSIONE DATE (FLAG -j -f) - DIFFICILE MA POTENTE
# ------------------------------------------------------------------------------
# Scenario: Hai una data scritta come stringa "25-12-2023" e vuoi sapere che giorno era
# o convertirla in Timestamp per fare calcoli.
#
# Flag necessari:
# -j : "Don't set". Non provare a cambiare l'orologio del sistema (solo calcolo).
# -f : "Format". Spiega a date come leggere la stringa in input.
# "input_string" : La data che hai.
# "+output_format" : Come la vuoi trasformata.

echo "----------------------------------------------------------------"
echo "--- 4. CONVERSIONE DATE (-j -f) ---"

DATA_INPUT="25-12-2023"
echo "Converto la stringa '$DATA_INPUT'..."

# 1. Convertire in Timestamp (per calcoli)
# Spiegazione: Leggi (-f) il formato "Giorno-Mese-Anno" dalla stringa input
# e stampalo come secondi (%s).
TS_NATALE=$(date -j -f "%d-%m-%Y" "$DATA_INPUT" "+%s")
echo "Timestamp di Natale 2023: $TS_NATALE"

# 2. Convertire in altro formato (es. Nome del giorno)
GIORNO_SETTIMANA=$(date -j -f "%d-%m-%Y" "$DATA_INPUT" "+%A")
echo "Il 25 Dicembre 2023 era: $GIORNO_SETTIMANA"

# 3. Calcolo avanzato: "Che giorno sarà 30 giorni dopo quella data specifica?"
# Combinazione di -j, -f e -v.
echo "30 giorni dopo il 25 Dicembre 2023:"
date -j -v+30d -f "%d-%m-%Y" "$DATA_INPUT" "+%Y-%m-%d"


# ------------------------------------------------------------------------------
# 5. CALCOLO DIFFERENZA TRA DUE DATE (MATEMATICA)
# ------------------------------------------------------------------------------
# Scenario Esame: "Quanti giorni mancano al 1 Gennaio 2026?"
# Logica: (Timestamp_Futuro - Timestamp_Oggi) / 86400 (secondi in un giorno).

echo "----------------------------------------------------------------"
echo "--- 5. CALCOLO DIFFERENZA GIORNI ---"

# 1. Timestamp Oggi
TS_OGGI=$(date +%s)

# 2. Timestamp Target
TARGET_STR="2026-01-01"
TS_TARGET=$(date -j -f "%Y-%m-%d" "$TARGET_STR" "+%s")

# 3. Sottrazione (Aritmetica Bash $((...)))
DIFF_SEC=$((TS_TARGET - TS_OGGI))

# 4. Conversione in giorni (1 giorno = 60*60*24 = 86400 secondi)
GIORNI_MANCANTI=$((DIFF_SEC / 86400))

echo "Mancano $GIORNI_MANCANTI giorni al $TARGET_STR"


# ------------------------------------------------------------------------------
# 6. MISURARE TEMPO DI ESECUZIONE (BENCHMARKING SCRIPT)
# ------------------------------------------------------------------------------
# Scenario: "Lo script deve stampare quanto tempo ha impiegato per girare".

echo "----------------------------------------------------------------"
echo "--- 6. BENCHMARKING ---"

START=$(date +%s)

echo "Eseguo operazione lenta (sleep 2)..."
sleep 2

END=$(date +%s)
ELAPSED=$((END - START))

echo "Operazione completata in $ELAPSED secondi."


# ------------------------------------------------------------------------------
# 7. UTC E FUSI ORARI (FLAG -u)
# ------------------------------------------------------------------------------
# Se lavori con server in nazioni diverse, usa sempre UTC per evitare confusione.

echo "----------------------------------------------------------------"
echo "--- 7. TIMEZONES (-u) ---"

echo "Ora Locale:"
date
echo "Ora UTC (Universale):"
date -u


# ==============================================================================
# 🧩 TABELLA CODICI FORMATTAZIONE (STRFTIME)
# ==============================================================================
# I codici più utili da imparare a memoria per l'esame.
#
# | CODICE | SIGNIFICATO                  | ESEMPIO      |
# |--------|------------------------------|--------------|
# | %Y     | Anno (4 cifre)               | 2024         |
# | %y     | Anno (2 cifre)               | 24           |
# | %m     | Mese (01-12)                 | 10           |
# | %B     | Nome Mese (Locale)           | October      |
# | %d     | Giorno (01-31)               | 25           |
# | %A     | Nome Giorno (Locale)         | Monday       |
# | %w     | Numero Giorno (0=Dom, 6=Sab) | 1            |
# |--------|------------------------------|--------------|
# | %H     | Ora (00-23)                  | 14           |
# | %I     | Ora (01-12)                  | 02           |
# | %M     | Minuti (00-59)               | 30           |
# | %S     | Secondi (00-59)              | 59           |
# | %p     | AM / PM                      | PM           |
# |--------|------------------------------|--------------|
# | %s     | EPOCH (Secondi dal 1970)     | 1698765432   |
# | %j     | Giorno dell'anno (001-366)   | 298          |


# ==============================================================================
# 💡 TRUCCHI E SCENARI D'ESAME
# ==============================================================================

# SCENARIO A: LOGGING FUNZIONALE
# Creare una funzione log che stampa data e messaggio.
log() {
    NOW=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$NOW] $1"
}

echo "--- Test Logging ---"
log "Inizio backup..."
log "Errore connessione database"

# SCENARIO B: "PRIMO GIORNO DEL MESE SCORSO"
# Utile per report mensili.
# 1. Prendi la data di oggi.
# 2. Togli 1 mese (-v-1m).
# 3. Forza il giorno a 01 (-v1d).
# Nota: L'ordine dei flag -v conta!
PRIMO_DEL_MESE_SCORSO=$(date -v-1m -v1d "+%Y-%m-%d")
echo "Il primo giorno del mese scorso era: $PRIMO_DEL_MESE_SCORSO"

# SCENARIO C: ULTIMO GIORNO DEL MESE CORRENTE
# Trucco: Vai al primo giorno del PROSSIMO mese (-v+1m -v1d), poi togli 1 giorno (-v-1d).
ULTIMO_DEL_MESE=$(date -v+1m -v1d -v-1d "+%Y-%m-%d")
echo "L'ultimo giorno di questo mese è: $ULTIMO_DEL_MESE"


# ==============================================================================
# ⚠️ DIFFERENZE LINUX (DA EVITARE SU MAC)
# ==============================================================================
# COMANDO         | LINUX (GNU)             | MACOS (BSD)
# ----------------|-------------------------|--------------------------
# Ieri            | date --date="yesterday" | date -v-1d
# 2 giorni fa     | date --date="2 days ago"| date -v-2d
# Parse stringa   | date -d "string"        | date -j -f "fmt" "string"
# Timestamp file  | date -r file            | stat -f %m file (o date -r)

echo "----------------------------------------------------------------"
echo "Tutorial Date Completato."

# ==============================================================================
# GUIDA AL COMANDO 'date' - GESTIONE TEMPO E TIMESTAMP
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. FORMATTAZIONE BASE (Fondamentale per i nomi dei file)
# ------------------------------------------------------------------------------
# Sintassi: date "+%FORMATO"
#
# %Y -> Anno (2023)
# %m -> Mese (01-12)
# %d -> Giorno (01-31)
# %H -> Ora (00-23)
# %M -> Minuti (00-59)
# %S -> Secondi (00-59)

# ESEMPIO: Creare un nome file con data e ora (classico da esame)
DATA_FILE=$(date "+%Y-%m-%d_%H-%M-%S")
# echo "Il file si chiamerà: backup_$DATA_FILE.tar.gz"


# ------------------------------------------------------------------------------
# 2. TIMESTAMP UNIX (%s)
# A cosa serve: Rappresenta i secondi trascorsi dal 1 Gennaio 1970.
# È utilissimo per fare CALCOLI matematici tra due date.
# ------------------------------------------------------------------------------

# ESEMPIO: Calcolare quanto tempo impiega un comando a girare
inizio=$(date +%s)

# ... qui va il comando pesante (es. uno sleep o una ricerca) ...
sleep 2 

fine=$(date +%s)
durata=$(( fine - inizio ))
# echo "Il processo ha impiegato $durata secondi."


# ------------------------------------------------------------------------------
# 3. VARIABILI DI LOCALE (LC_ALL, LC_TIME)
# A cosa serve: Cambia la lingua della data (es. "Monday" vs "Lunedì").
# ------------------------------------------------------------------------------
# LC_ALL=it_IT.UTF-8 date +%c  # Formato completo in Italiano
# LC_ALL=en_US.UTF-8 date +%A  # Nome del giorno della settimana in Inglese


# ------------------------------------------------------------------------------
# 4. CONVERSIONI (Solo Linux/GNU - Spesso diverso su Mac!)
# ------------------------------------------------------------------------------
# Trasformare una stringa in data:
# Linux: date -d "2023-01-01 + 5 days"
# Mac (BSD): date -j -v+5d -f "%Y-%m-%d" "2023-01-01"

# NOTA: Se l'esame è sul server Linux, usa sempre la sintassi -d.