#!/bin/bash

# ==============================================================================
# 42. INTEGRITÀ DATI E HASHING: MD5 E SHASUM (MACOS EDITION)
# ==============================================================================
# OBIETTIVO (ESAME 18):
# "Garantire con certezza che la struttura o i file non siano stati modificati."
#
# CONCETTO CHIAVE: L'IMPRONTA DIGITALE (HASH)
# Un Hash (MD5 o SHA) è una stringa alfanumerica generata dal contenuto del file.
# - Se cambi anche solo una virgola nel file, l'Hash cambia COMPLETAMENTE.
# - Se il file è identico, l'Hash è identico.
#
# DIFFERENZA CRITICA MACOS vs LINUX:
# 1. Comando: Linux usa 'md5sum'. macOS usa 'md5'.
# 2. Verifica: Linux fa 'md5sum -c file.chk'. macOS NON HA il flag -c.
#    SU MACOS DEVI CREARE LA LOGICA DI VERIFICA A MANO (o usare shasum).
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. SETUP AMBIENTE
# ------------------------------------------------------------------------------
echo "--- 0. SETUP AMBIENTE ---"
rm -rf test_integrita
mkdir test_integrita
echo "PasswordSegreta123" > test_integrita/db_password.txt
echo "Configurazione=OK" > test_integrita/config.ini

echo "Ambiente creato in ./test_integrita"


# ==============================================================================
# 1. GENERARE HASH MD5 (SINTASSI MACOS)
# ==============================================================================
# Sintassi base: md5 [file]

echo "----------------------------------------------------------------"
echo "--- 1. GENERAZIONE HASH ---"

FILE_TARGET="test_integrita/db_password.txt"

# 1.1 Output Standard BSD (Verboso)
# Formato: MD5 (nomefile) = hash
echo "Output Standard:"
md5 "$FILE_TARGET"

# 1.2 Output Quiet (-q) - FONDAMENTALE PER SCRIPT
# Stampa SOLO l'hash. Perfetto per salvarlo in una variabile.
HASH_CALCOLATO=$(md5 -q "$FILE_TARGET")
echo "Hash Pulito (per script): $HASH_CALCOLATO"

# 1.3 Hash di una stringa al volo (-s)
# Utile se devi hashare una password in memoria senza scriverla su file.
echo "Hash della stringa 'ciao':"
md5 -s "ciao"


# ==============================================================================
# 2. SHASUM: L'ALTERNATIVA PORTABILE (E PIÙ SICURA)
# ==============================================================================
# MD5 è vecchio e tecnicamente vulnerabile (anche se ok per esami scolastici).
# macOS include 'shasum' (SHA-1/256) che è compatibile con la sintassi Linux!
# shasum HA il flag -c (check). Se puoi scegliere, USA QUESTO.

echo "----------------------------------------------------------------"
echo "--- 2. SHASUM (ALTERNATIVA MIGLIORE) ---"

# Generazione
echo "Calcolo SHA1:"
shasum "$FILE_TARGET"

# Verifica Automatica (-c)
# 1. Creiamo il file di controllo
shasum "$FILE_TARGET" > check_file.sha
# 2. Verifichiamo
echo "Verifica shasum -c:"
shasum -c check_file.sha


# ==============================================================================
# 3. SOLUZIONE ESAME 18: VERIFICA INTEGRITÀ MANUALE (CON MD5)
# ==============================================================================
# TRACCIA: "Lo script deve avvisare se il file è stato modificato rispetto all'ultima volta."
# LOGICA:
# 1. Esiste un file con l'hash precedente?
#    NO -> È la prima esecuzione. Calcola e salva.
#    SI -> Calcola hash attuale e confronta con quello salvato.

echo "----------------------------------------------------------------"
echo "--- 3. SOLUZIONE ESAME 18 (CHECK SINGOLO FILE) ---"

DB_FILE="test_integrita/db_password.txt"
HASH_FILE="test_integrita/db_password.md5"

# Funzione di controllo
check_file_integrity() {
    # 1. Calcola Hash attuale (-q per avere solo la stringa)
    CURRENT_HASH=$(md5 -q "$DB_FILE")
    
    # 2. Controlla se abbiamo uno storico
    if [ -f "$HASH_FILE" ]; then
        # Leggiamo l'hash salvato
        SAVED_HASH=$(cat "$HASH_FILE")
        
        # 3. Confronto (Stringa vs Stringa)
        if [ "$CURRENT_HASH" == "$SAVED_HASH" ]; then
            echo "[OK] Il file è INTEGRO (Nessuna modifica)."
        else
            echo "[ALLARME] IL FILE È STATO MODIFICATO!"
            echo "Precedente: $SAVED_HASH"
            echo "Attuale:    $CURRENT_HASH"
            # Aggiorniamo l'hash? Dipende dalla traccia. Di solito no, finché l'admin non resetta.
        fi
    else
        echo "[INIT] Prima esecuzione. Salvataggio impronta digitale."
        echo "$CURRENT_HASH" > "$HASH_FILE"
    fi
}

# TEST 1: Prima esecuzione
echo ">>> RUN 1:"
check_file_integrity

# TEST 2: Seconda esecuzione (Nessuna modifica)
echo ">>> RUN 2:"
check_file_integrity

# TEST 3: Modifica malevola
echo ">>> RUN 3 (Dopo attacco):"
echo "Hacker was here" >> "$DB_FILE"
check_file_integrity


# ==============================================================================
# 4. INTEGRITÀ DI UN'INTERA CARTELLA (RECURSIVE)
# ==============================================================================
# TRACCIA: "Verifica se QUALSIASI file nella cartella è cambiato".
# Soluzione: Usare 'find' per calcolare l'hash di tutti i file e salvare un report.

echo "----------------------------------------------------------------"
echo "--- 4. INTEGRITÀ CARTELLA (SNAPSHOT) ---"

DIR_DA_CONTROLLARE="test_integrita"
SNAPSHOT_OGGI="snapshot_$(date +%s).log"

echo "Creo snapshot dell'intera cartella..."

# Spiegazione comando complesso:
# 1. find . -type f : Trova tutti i file
# 2. -exec md5 {} : Esegue md5 su ogni file
# 3. sort -k 4 : Ordina per nome file (la 4a colonna dell'output md5 standard su mac)
#    Nota: L'output standard è "MD5 (file) = hash". Ordinare aiuta il confronto.

find "$DIR_DA_CONTROLLARE" -type f -exec md5 {} \; | sort > "$SNAPSHOT_OGGI"

echo "Snapshot creato: $SNAPSHOT_OGGI"
cat "$SNAPSHOT_OGGI"

# Come confrontare due snapshot di cartelle?
# Usiamo 'diff'.
# Se 'diff' non stampa nulla, le cartelle sono matematicamente identiche.


# ==============================================================================
# 5. RILEVARE FILE AGGIUNTI O RIMOSSI
# ==============================================================================
# L'integrità strutturale non è solo "file modificati", ma anche "file spariti".

echo "----------------------------------------------------------------"
echo "--- 5. RILEVAMENTO INTRUSIONI (DIFF) ---"

# Creiamo uno snapshot "Gold Master" (Riferimento sicuro)
find "$DIR_DA_CONTROLLARE" -type f -exec md5 {} \; | sort > gold_master.log

# Simuliamo un'intrusione: file aggiunto
touch "$DIR_DA_CONTROLLARE/virus.exe"

# Creiamo snapshot attuale
find "$DIR_DA_CONTROLLARE" -type f -exec md5 {} \; | sort > current_state.log

echo "Confronto Gold Master vs Current:"
# diff mostra le differenze.
# < significa "era nel vecchio ma non nel nuovo" (Cancellato)
# > significa "è nel nuovo ma non nel vecchio" (Aggiunto/Modificato)

diff gold_master.log current_state.log

if [ $? -eq 0 ]; then
    echo "Struttura integra."
else
    echo "ATTENZIONE: Modifiche strutturali rilevate!"
fi


# ==============================================================================
# ⚠️ TABELLA STRUMENTI (MACOS)
# ==============================================================================
# | COMANDO | FLAG     | SIGNIFICATO                                        |
# |---------|----------|----------------------------------------------------|
# | md5     | (nessuno)| Output: MD5 (file) = hash                          |
# | md5     | -q       | Quiet. Output: hash (SOLO L'HASH). Utile variabili.|
# | md5     | -s "txt" | Calcola hash di una stringa diretta.               |
# | shasum  | -a 256   | Usa algoritmo SHA-256 (Più sicuro di MD5).         |
# | shasum  | -c file  | Check. Legge un file di hash e verifica auto.      |
# | diff    | file1 f2 | Confronta due file di testo (es. due snapshot).    |



# Pulizia
rm -rf test_integrita *.log *.sha *.md5
echo "----------------------------------------------------------------"
echo "Tutorial 42 (Integrità/MD5) Completato."