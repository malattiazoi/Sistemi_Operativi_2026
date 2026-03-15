# !/bin/bash 

# trovare cartella A (quella con più n file regolari dalla cartella scelta in giù),
# creare sotto cartella in A che dentro ha tutti file con un prefisso scelto 
# il prefisso è anche il nome della cartella

if [ $# -lt 2 ]; then
    echo "[ERR] Uso script: $0 <dir> <file_name>"
    exit 1
fi

DIR="$1"
NAME="$2"

if [ ! -d "$DIR" ]; then
    echo "[ERR] Directory non valida!"
    exit 1
fi

echo "Ricerca directory nelle radici..."

MAX_COUNT=1
DIR_W=""

find "$DIR" -type d | while read -r CURR_DIR; do
    COUNT=$(find "$CURR_DIR" -maxdepth 1 -tpe f 2>/dev/null | wc -l)
    echo "$COUNT $CURR_DIR"
done > mappa_conteggi.txt

echo "Creazione file temporaneo..."

while read -r COUNT DIR; do 
    if [ "$COUNT" -gt "$MAX_COUNT" ]; then
        MAX_COUNT="$COUNT"
        DIR_W="$DIR"
    fi
done <mappa_conteggi.txt

rm mappa_conteggi.txt
echo "File temporaneo rimosso..." 

if [ -z "$DIR_W" ]; then
    echo "nessuna directory trovata."
    exit 1
fi

echo "Directory vincete: $DIR_W."
echo "Spostiamo dentro la dir $NAME i file..."

DESTINATION="$DIR_W/$NAME"

if [ ! -d "$DESTINATION" ]; then
    mkdir "$DESTINATION"
    echo "\nCartella creata. Inizio caricamento..."
fi

shopt -s nullglob #evito errori se non ci sono file

for FILE in "$DIR_W"/*; do
    if [ -f "$FILE" ]; then 
        BASENAME=$(basename "$NAME")
        MATCH=0
        if [["$BASENAME" == *"$NAME"* ]]; then
        MATCH=1
        elif grep -q "$NAME" "$FILE" 2>/dev/null; then
        MATCH=1
        fi

        if [[ "$MATCH" ==1 ]]; then 
        mv "$FILE" "$DESTINATION"
        echo "$FILE spostato in $DESTINATION"
        fi
    fi
done

sgopt -u nullglob
echo "Operazione conclusa!"

# Versione con funzioni

check_args() {
    if [ "$1" -lt "$2" ]; then
        echo "[ERRORE] Argomenti insufficienti."
        echo "Uso: $0 <dir> <stringa>"
        exit 1
    fi
}

# Trova la directory con più file
find_max_dir() {
    local ROOT="$1"
    local MAX_N=0
    local BEST_DIR=""
    
    # IFS=$'\n' imposta il separatore "a capo" per il ciclo for
    # così find non rompe i nomi con spazi
    local OLD_IFS="$IFS"
    IFS=$'\n'
    
    for DIR in $(find "$ROOT" -type d); do
        # Conto i file
        # tr -d ' ' pulisce eventuali spazi extra di wc
        local N=$(find "$DIR" -maxdepth 1 -type f | wc -l | tr -d ' ')
        
        if [ "$N" -gt "$MAX_N" ]; then
            MAX_N="$N"
            BEST_DIR="$DIR"
        fi
    done
    
    IFS="$OLD_IFS"
    
    # Ritorno il risultato stampandolo (lo catturerò con $())
    echo "$BEST_DIR"
}

move_matching_files() {
    local WORK_DIR="$1"
    local KEYWORD="$2"
    local DESTINATION="$WORK_DIR/$KEYWORD"
    
    mkdir -p "$DESTINATION"
    echo "[INFO] Creata destinazione: $DESTINATION"
    
    # Ciclo sicuro sui file
    for F in "$WORK_DIR"/*; do
        [ -f "$F" ] || continue
        
        local FNAME=$(basename "$F")
        local SHOULD_MOVE=0
        
        # 1. Controllo Nome
        if [[ "$FNAME" == *"$KEYWORD"* ]]; then
            SHOULD_MOVE=1
        # 2. Controllo Contenuto (solo se il nome fallisce)
        elif grep -q "$KEYWORD" "$F"; then
            SHOULD_MOVE=1
        fi
        
        if [ "$SHOULD_MOVE" -eq 1 ]; then
            mv "$F" "$DESTINATION/"
            echo "[MOVE] $FNAME -> $KEYWORD/"
        fi
    done
}

check_args $# 2

INPUT_DIR="$1"
SEARCH_STR="$2"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Directory non valida."
    exit 1
fi

echo "Ricerca directory più popolosa..."
WINNER_DIR=$(find_max_dir "$INPUT_DIR")

if [ -z "$WINNER_DIR" ]; then
    echo "Nessuna directory trovata o vuota."
    WINNER_DIR="$INPUT_DIR" # Fallback sulla root se tutto fallisce
fi

echo "Trovata: '$WINNER_DIR'"
move_matching_files "$WINNER_DIR" "$SEARCH_STR"