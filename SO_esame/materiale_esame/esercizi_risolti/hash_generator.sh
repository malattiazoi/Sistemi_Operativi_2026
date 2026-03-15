#!/bin/bash

# Scrivere uno script bash di sinossi
# guess_hash.sh XX
# che trovi una qualsiasi stringa il cui digest MD5 inizi con i bit la cui 
# rappresentazione esadecimale è "XX" (dove X è una qualsiasi cifra 
# esadecimale). 
# Stampare al terminale le rappresentazioni esadecimali del digest MD5 
# trovato e della stringa usata per produrlo.

TARGET="$1"

# Controllo argomenti
if [ -z "$TARGET" ]; then
    echo "Uso: $0 <prefisso_esadecimale>"
    exit 1
fi

COUNT=0

echo "Cerco una stringa il cui MD5 inizi per '$TARGET'..."

while true; do
    # Genero l'hash del numero corrente.
    # echo -n evita di aggiungere il carattere "a capo" alla stringa
    # awk '{print $1}' pulisce l'output prendendo solo il primo campo (l'hash)
    # 2>&1 manda output nel posto dell'error
    if command -v md5sum >/dev/null 2>&1; then
        # Siamo su Linux
        HASH=$(echo -n "$COUNT" | md5sum | awk '{print $1}')
    else
        # Siamo su Mac (fallback)
        HASH=$(echo -n "$COUNT" | md5)
    fi

    # Controllo se l'hash inizia con il target
    # [[ $STR == $PREFIX* ]] è il pattern matching di Bash
    if [[ "$HASH" == "$TARGET"* ]]; then
        echo "--------------------------------"
        echo "TROVATO!"
        echo "Digest MD5: $HASH"
        echo "Stringa:    $COUNT"
        echo "--------------------------------"
        exit 0
    fi

    # Incremento il contatore per provare la prossima stringa
    ((COUNT++))
done

#con funzioni

#!/bin/bash

TARGET="$1"

# Controllo argomenti
if [ -z "$TARGET" ]; then
    echo "Uso: $0 <prefisso_esadecimale>"
    exit 1
fi

COUNT=0

echo "Cerco una stringa il cui MD5 inizi per '$TARGET'..."

while true; do
    # Genero l'hash del numero corrente.
    # echo -n evita di aggiungere il carattere "a capo" alla stringa
    # awk '{print $1}' pulisce l'output prendendo solo il primo campo (l'hash)
    if command -v md5sum >/dev/null 2>&1; then
        # Siamo su Linux
        HASH=$(echo -n "$COUNT" | md5sum | awk '{print $1}')
    else
        # Siamo su Mac (fallback)
        HASH=$(echo -n "$COUNT" | md5)
    fi

    # Controllo se l'hash inizia con il target
    # [[ $STR == $PREFIX* ]] è il pattern matching di Bash
    if [[ "$HASH" == "$TARGET"* ]]; then
        echo "--------------------------------"
        echo "TROVATO!"
        echo "Digest MD5: $HASH"
        echo "Stringa:    $COUNT"
        echo "--------------------------------"
        exit 0
    fi

    # Incremento il contatore per provare la prossima stringa
    ((COUNT++))
done

#con funzioni

#!/bin/bash

# ==============================================================================
# FUNZIONI
# ==============================================================================

check_args() {
    if [ -z "$1" ]; then
        echo "[ERRORE] Manca il prefisso esadecimale."
        echo "Sintassi: $0 XX"
        exit 1
    fi
}

calculate_md5() {
    local INPUT="$1"
    # Gestione compatibilità Mac/Linux
    if command -v md5sum > /dev/null 2>&1; then
        echo -n "$INPUT" | md5sum | awk '{print $1}'
    else
        echo -n "$INPUT" | md5
    fi
}

brute_force_hash() {
    local PREFIX="$1"
    local CANDIDATE=0
    local HASH=""
    
    echo "[INFO] Avvio ricerca per prefisso: $PREFIX"
    
    while true; do
        # Calcolo Hash
        HASH=$(calculate_md5 "$CANDIDATE")
        
        # Confronto: se HASH inizia con PREFIX
        if [[ "$HASH" == "$PREFIX"* ]]; then
            echo "[SUCCESS] Corrispondenza trovata."
            echo "Digest MD5: $HASH"
            echo "Stringa:    $CANDIDATE"
            return 0
        fi
        
        # Feedback visivo ogni 1000 tentativi (opzionale, per non sembrare bloccato)
        if (( CANDIDATE % 5000 == 0 )); then
            echo -ne "Tentativo $CANDIDATE...\r"
        fi
        
        ((CANDIDATE++))
    done
}


TARGET_PREFIX="$1"

check_args "$TARGET_PREFIX"
brute_force_hash "$TARGET_PREFIX"