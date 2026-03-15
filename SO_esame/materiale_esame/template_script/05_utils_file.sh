#!/bin/bash

# ==============================================================================
# UTILS: FILE SYSTEM OPERATIONS
# ==============================================================================
# OBIETTIVO:
# Manipolare nomi file, estensioni e creare backup rapidi.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. OTTENERE ESTENSIONE E NOME BASE
# ------------------------------------------------------------------------------
# Senza usare comandi esterni, solo Bash manipulation (veloce).

# Uso: EXT=$(get_ext "foto.vacanze.jpg") -> "jpg"
get_ext() {
    local FILE="$1"
    echo "${FILE##*.}"
}

# Uso: NAME=$(get_filename "foto.vacanze.jpg") -> "foto.vacanze"
get_filename() {
    local FILE="$1"
    echo "${FILE%.*}"
}

# ------------------------------------------------------------------------------
# 2. BACKUP SICURO
# ------------------------------------------------------------------------------
# Crea una copia .bak del file. Se esiste già, non sovrascrive (o aggiunge data).
# Uso: backup_file "config.txt"

backup_file() {
    local FILE="$1"
    local BAK="${FILE}.bak"
    
    if [ -f "$FILE" ]; then
        cp "$FILE" "$BAK"
        echo "[BACKUP] Creato $BAK"
    else
        echo "[WARN] File $FILE non trovato, niente backup."
    fi
}

# ------------------------------------------------------------------------------
# 3. RINOMINA DI MASSA (TEMPLATE)
# ------------------------------------------------------------------------------
# Esempio di funzione complessa per rinominare file sostituendo stringhe.
# Uso: mass_rename "." "jpg" "jpeg" (cambia estensione a tutti i file nella dir)

mass_rename() {
    local DIR="$1"
    local OLD_STR="$2"
    local NEW_STR="$3"
    
    echo "Rinominando in $DIR: $OLD_STR -> $NEW_STR..."
    
    # Loop sui file
    for FILE in "$DIR"/*"$OLD_STR"*; do
        [ -e "$FILE" ] || continue # Se non ci sono file, salta
        
        # Sostituzione stringa Bash ${VAR//OLD/NEW}
        local NEW_NAME="${FILE//$OLD_STR/$NEW_STR}"
        
        mv "$FILE" "$NEW_NAME"
        echo "$FILE -> $NEW_NAME"
    done
}


# ------------------------------------------------------------------------------
# 4. ESECUZIONE SCRIPT NEL CONTESTO (SOURCING MASSIVO)
# ------------------------------------------------------------------------------
# Cerca script con un certo prefisso in una cartella e li esegue con 'source'.
# Utile per esami tipo "Esegui gli script nome_01, nome_02...".
# Uso: run_in_context "./cartella" "prefisso_"

run_in_context() {
    local TARGET_DIR="$1"
    local PREFIX="$2"
    
    # Controllo che la directory esista
    if [ ! -d "$TARGET_DIR" ]; then
        echo "[WARN] Directory '$TARGET_DIR' non trovata. Salto."
        return 1
    fi

    echo "[EXEC] Cerco script '$PREFIX*' in '$TARGET_DIR'..."

    # 1. Attivo nullglob per evitare errori se non trova nulla
    shopt -s nullglob
    
    # 2. Creo la lista dei file ordinata (sort assicura l'ordine alfabetico/numerico)
    #    Nota: 2>/dev/null nasconde errori di ls se vuoto
    local FILES=$(ls "$TARGET_DIR"/"$PREFIX"* 2>/dev/null | sort)
    
    if [ -z "$FILES" ]; then
        echo "[INFO] Nessuno script trovato."
        shopt -u nullglob
        return 0
    fi

    # 3. Loop di esecuzione
    for SCRIPT in $FILES; do
        # Controllo che sia un file regolare (-f) e non una cartella
        if [ -f "$SCRIPT" ]; then
            echo ">>> Sourcing: $(basename "$SCRIPT")"
            # IL COMANDO MAGICO: source
            source "$SCRIPT"
        fi
    done
    
    # Ripristino comportamento default
    shopt -u nullglob
}

# ==============================================================================
# FUNZIONE: move_if_match
# UTILIZZO: move_if_match "file.txt" "parola" "/destinazione"
# INPUT:    $1 = File da controllare, $2 = Stringa da cercare, $3 = Destinazione
# OUTPUT:   Nessuno (Sposta il file se il nome O il contenuto matchano).
#           Utile per esercizi di smistamento file basati su criteri misti.
# ==============================================================================
move_if_match() {
    local FILE="$1"
    local KEYWORD="$2"
    local DEST_DIR="$3"
    
    local FNAME=$(basename "$FILE")
    local MATCH=0
    
    # Check 1: Nome contiene la stringa?
    if [[ "$FNAME" == *"$KEYWORD"* ]]; then
        MATCH=1
    # Check 2: Contenuto contiene la stringa?
    elif grep -q "$KEYWORD" "$FILE" 2>/dev/null; then
        MATCH=1
    fi
    
    if [ "$MATCH" -eq 1 ]; then
        mv "$FILE" "$DEST_DIR/"
    fi
}