#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# [cite_start]Il digest md5 di un file contenente 2 caratteri è e0aa021e21dddbd6d8cecec71e9cf564[cite: 118].
# Scrivere uno script che stampi il contenuto del file e indicare il tempo macchina 
# [cite_start]consumato in modalità utente e sistema[cite: 119].
# ------------------------------------------------------------------------------

TARGET_HASH="e0aa021e21dddbd6d8cecec71e9cf564"

# Funzione per calcolare hash (Compatibile Mac/Linux)
get_md5() {
    if command -v md5sum >/dev/null 2>&1; then
        # Linux
        echo -n "$1" | md5sum | awk '{print $1}'
    else
        # Mac
        md5 -q -s "$1"
    fi
}

# Funzione principale di ricerca
crack_it() {
    echo "Avvio Brute Force su 2 caratteri..."
    
    # Loop sui caratteri ASCII stampabili (da 32 ' ' a 126 '~')
    # Usiamo due cicli annidati perché sappiamo che sono ESATTAMENTE 2 caratteri.
    
    for i in {32..126}; do
        for j in {32..126}; do
            
            # Conversione da Decimale a Carattere usando printf ottale
            # printf \\$(printf %03o $VALORE) trasforma il numero in carattere
            CHAR1=$(printf "\\$(printf %03o "$i")")
            CHAR2=$(printf "\\$(printf %03o "$j")")
            
            CANDIDATE="$CHAR1$CHAR2"
            
            # Calcolo Hash
            CURRENT_HASH=$(get_md5 "$CANDIDATE")
            
            # Verifica
            if [ "$CURRENT_HASH" == "$TARGET_HASH" ]; then
                echo "--------------------------------"
                echo "TROVATO!"
                echo "Hash:      $TARGET_HASH"
                echo "Contenuto: '$CANDIDATE'"
                echo "--------------------------------"
                return 0
            fi
        done
    done
    
    echo "Nessuna corrispondenza trovata nel range standard ASCII."
}

# Esecuzione con misurazione del tempo
# Il comando 'time' di bash stampa real/user/sys alla fine dell'esecuzione.
# [cite_start]La traccia chiede esplicitamente tempo utente e sistema[cite: 119].

time crack_it