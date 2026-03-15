#!/bin/bash

# ==============================================================================
# UTILS: MATEMATICA E CALCOLI (FLOAT SUPPORT)
# ==============================================================================
# OBIETTIVO:
# Eseguire calcoli matematici precisi (con virgola) e verifiche numeriche.
# Bash nativo fa solo interi. Per il resto serve 'bc'.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CALCOLATRICE (WRAPPER BC)
# ------------------------------------------------------------------------------
# Esegue un'espressione matematica e ritorna il risultato.
# Uso: RISULTATO=$(calc "10.5 / 2")
# scale=2 imposta 2 cifre decimali di precisione.

calc() {
    local EXPRESSION="$1"
    # -l carica la libreria matematica standard
    echo "scale=2; $EXPRESSION" | bc -l
}

# ------------------------------------------------------------------------------
# 2. CONFRONTO FLOAT
# ------------------------------------------------------------------------------
# Bash non può fare [ 10.5 -gt 2 ].
# Uso: if float_gt "10.5" "2.1"; then ...

float_gt() { # Greater Than
    # Se bc ritorna 1 è vero, 0 è falso
    [ $(echo "$1 > $2" | bc -l) -eq 1 ]
}

float_lt() { # Less Than
    [ $(echo "$1 < $2" | bc -l) -eq 1 ]
}

# ------------------------------------------------------------------------------
# 3. VERIFICA SE INTERO
# ------------------------------------------------------------------------------
# Controlla se una stringa è un numero intero valido (utile per input utente).
# Uso: if is_int "$INPUT"; then ...

is_int() {
    local VAR="$1"
    # Regex: ^ opzionale(-) seguito da numeri uno o più volte $
    [[ "$VAR" =~ ^-?[0-9]+$ ]]
}

# ------------------------------------------------------------------------------
# 4. VERIFICA SE FLOAT
# ------------------------------------------------------------------------------
# Controlla se è un numero con virgola (punto).

is_float() {
    local VAR="$1"
    # Regex: Numeri, punto opzionale, numeri
    [[ "$VAR" =~ ^-?[0-9]*\.?[0-9]+$ ]]
}