# !/bin/bash

# crea script che verifica l'esistenza di una directory e nel suo contesto esegue
# tutti gli script al suo interno secodo un ordine stabilito (numerico o alfabetico)

if [ $# -lt 2 ]; then
    echo "[ERR] USO= $0 <directory> <nome_file>"
    exit 1
fi

DIR="$1"
PREFIX="$2"

echo "Esecuzione..."

if [ ! -d "$DIR" ]; then
    echo "[ERR] l'argomento non è una directory."
    exit 1
fi

for SCRIPT in "$DIR/$PREFIX"*; do
    if [ -f "$SCRPT" ]; then 
        echo "Sourcing di [$SCRIPT]..."
        source "$SCRIPT"
    else
        echo "[ERR] File irregolare!"
        exit 1
    fi
do

echo "Script eseguiti con successo!"

#versione con funzioni

check_dir() {
    if [ ! -d "$1" ]; then
        echo "[ERRORE] Directory '$1' inesistente." >&2
        exit 1
    fi
}

run_in_context() {
    local TARGET_DIR="$1"
    local PATTERN="$2"
    # shopt -s nullglob evita errori se non trova nulla
    shopt -s nullglob
    
    # Costruisco la lista ordinata
    # sort garantisce l'ordine anche se il globbing fallisse (raro)
    FILES=$(ls "$TARGET_DIR"/"$PATTERN"* 2>/dev/null | sort)
    
    if [ -z "$FILES" ]; then
        echo "[WARN] Nessuno script trovato con pattern '$PATTERN' in '$TARGET_DIR'."
        return
    fi
    
    for SCRIPT in $FILES; do
        if [ -x "$SCRIPT" ] || [ "${SCRIPT##*.}" == "sh" ]; then
            echo "------------------------------------------------"
            echo ">>> SOURCING: $(basename "$SCRIPT")"
            
            # ESECUZIONE NEL CONTESTO
            # Le variabili settate dentro $SCRIPT saranno visibili qui dopo!
            source "$SCRIPT"
            
            echo "<<< COMPLETATO"
        fi
    done
    
    shopt -u nullglob
}

# Esempio hardcoded come da traccia ("es. nome_scelto_da_te...")
DIRECTORY_TARGET="./plugin_folder"
PREFISSO_TARGET="task_"

# Controllo se l'utente passa argomenti, altrimenti uso default
if [ $# -ge 2 ]; then
    DIRECTORY_TARGET="$1"
    PREFISSO_TARGET="$2"
fi

check_dir "$DIRECTORY_TARGET"
run_in_context "$DIRECTORY_TARGET" "$PREFISSO_TARGET"