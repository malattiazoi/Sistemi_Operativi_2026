#!/bin/bash

# ==============================================================================
# 56. TEMPLATE LOGICI: IF, FOR, WHILE (PATTERNS PRONTI)
# ==============================================================================
# OBIETTIVO:
# Fornire blocchi di codice "copia-incolla" per le situazioni d'esame più comuni.
#
# CONTENUTO:
# 1. Loop sicuro sui file (gestisce spazi nei nomi).
# 2. Loop di monitoraggio con Timeout (Esame 49).
# 3. Input utente con validazione (Esame 191e).
# 4. Loop numerico con padding (Esame 35).
# 5. Logica di riprova (Retry) per connessioni instabili.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. LOOP SICURO SU FILE (FILE ITERATOR)
# ------------------------------------------------------------------------------
# UTILIZZO: Quando devi fare operazioni su file che potrebbero avere spazi nel nome.
# Esame 43 (Rinomina file), Esame 35 (Link simbolici).

loop_files_safe() {
    local DIR="$1"
    
    echo "Processando file in $DIR..."
    
    # Shopt nullglob: Se non trova file, il loop non parte (evita errori "*.txt not found")
    shopt -s nullglob
    
    for FILE in "$DIR"/*; do
        # Controllo se è un file regolare (-f) o directory (-d)
        if [ -f "$FILE" ]; then
            echo "Trovato file: '$FILE'"
            
            # --- INSERISCI QUI LA TUA LOGICA ---
            # Esempio: mv "$FILE" "${FILE}.bak"
            
        elif [ -d "$FILE" ]; then
            echo "Trovata cartella: '$FILE' (Salto)"
        fi
    done
    
    shopt -u nullglob
}


# ------------------------------------------------------------------------------
# 2. MONITORAGGIO CON TIMEOUT (WATCHDOG LOOP)
# ------------------------------------------------------------------------------
# UTILIZZO: Esame 49 ("Interrompi processo dopo 3 minuti").
# Logica: Controlla se il PID esiste ogni secondo. Se supera il limite, uccidi.

watchdog_process() {
    local PID="$1"
    local TIMEOUT_SEC="$2"
    local ELAPSED=0
    
    echo "Monitoraggio PID $PID (Timeout: ${TIMEOUT_SEC}s)..."
    
    # kill -0 verifica solo se il processo esiste, non lo uccide.
    while kill -0 "$PID" 2>/dev/null; do
        
        # Check Timeout
        if [ "$ELAPSED" -ge "$TIMEOUT_SEC" ]; then
            echo "[TIMEOUT] Il processo $PID ha girato troppo. TERMINAZIONE."
            kill -9 "$PID"
            return 1 # Uscita con stato "Killato"
        fi
        
        # Attesa
        sleep 1
        ((ELAPSED++))
    done
    
    echo "[INFO] Il processo $PID è terminato naturalmente dopo $ELAPSED secondi."
    return 0
}


# ------------------------------------------------------------------------------
# 3. INPUT UTENTE CON VALIDAZIONE (SENTINEL LOOP)
# ------------------------------------------------------------------------------
# UTILIZZO: Esame 191e ("Leggi righe finché l'utente scrive 'fine'").
# UTILIZZO: Esame 43 ("Chiedi all'utente conferma").

input_loop_sentinel() {
    local SENTINEL="fine"
    local OUTPUT_FILE="input_raccolto.txt"
    
    echo "Inserisci testo (scrivi '$SENTINEL' per uscire):"
    
    # > inizializza il file vuoto
    > "$OUTPUT_FILE"
    
    while true; do
        # -p mostra il prompt
        read -p "> " INPUT_USER
        
        # 1. Check Uscita
        if [ "$INPUT_USER" == "$SENTINEL" ]; then
            echo "Uscita richiesta."
            break
        fi
        
        # 2. Check Input Vuoto (Opzionale)
        if [ -z "$INPUT_USER" ]; then
            echo "Input vuoto non valido."
            continue # Salta al prossimo giro del loop
        fi
        
        # 3. Azione (es. Salva su file)
        echo "$INPUT_USER" >> "$OUTPUT_FILE"
    done
}


# ------------------------------------------------------------------------------
# 4. LOOP NUMERICO CON PADDING (ZERO PADDING)
# ------------------------------------------------------------------------------
# UTILIZZO: Esame 35 ("Crea link_001, link_002...").
# Genera numeri formattati (01, 02.. 10) per nomi file ordinati.

loop_numeric_padding() {
    local MAX=15
    
    echo "Generazione sequenza con zeri..."
    
    for (( i=1; i<=MAX; i++ )); do
        # printf %03d crea numeri a 3 cifre: 001, 002... 010...
        NUM_FMT=$(printf "%03d" $i)
        
        FILENAME="immagine_${NUM_FMT}.jpg"
        echo "Processing: $FILENAME"
        
        # --- LOGICA QUI ---
        # touch "$FILENAME"
    done
}


# ------------------------------------------------------------------------------
# 5. RETRY LOOP (RIPROVA FINCHÉ NON RIESCI)
# ------------------------------------------------------------------------------
# UTILIZZO: Connessioni SSH/SCP instabili o attesa avvio servizi.
# "Prova a copiare il file, se fallisce riprova massimo 5 volte".

retry_command() {
    local CMD="$1"
    local MAX_RETRIES=5
    local COUNT=1
    
    echo "Esecuzione comando: '$CMD'"
    
    # Until esegue FINCHÉ il comando non ha successo (Exit Code 0)
    # Oppure usiamo while ! comando
    
    while ! eval "$CMD"; do
        if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
            echo "[FAIL] Comando fallito dopo $MAX_RETRIES tentativi."
            return 1
        fi
        
        echo "[RETRY] Tentativo $COUNT/$MAX_RETRIES fallito. Riprovo tra 2s..."
        sleep 2
        ((COUNT++))
    done
    
    echo "[SUCCESS] Comando riuscito al tentativo $COUNT."
    return 0
}


# ------------------------------------------------------------------------------
# 6. LOGICA DI CONFRONTO NUMERICO (IF FLOAT)
# ------------------------------------------------------------------------------
# UTILIZZO: Compitino 1 ("Confronta numero righe").
# Bash nativo fa solo interi. Per decimali serve questo trick.

compare_values() {
    local VAL1="$1"
    local VAL2="$2"
    
    # Confronto Intero (Bash puro)
    if [ "$VAL1" -eq "$VAL2" ]; then
        echo "Uguali (Integers)"
    elif [ "$VAL1" -gt "$VAL2" ]; then
        echo "$VAL1 è maggiore"
    fi
    
    # Confronto Decimale (bc) - Se i numeri hanno la virgola
    # Restituisce 1 se vero, 0 se falso
    IS_GREATER=$(echo "$VAL1 > $VAL2" | bc -l)
    
    if [ "$IS_GREATER" -eq 1 ]; then
        echo "$VAL1 è maggiore (Float)"
    fi
}