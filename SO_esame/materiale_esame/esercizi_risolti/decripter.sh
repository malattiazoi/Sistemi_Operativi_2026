#!/bin/bash

# Si sospetta che la seguente stringa di caratteri decimali:
# 106694605488716606615510761624192084515169992988095944557093130
# contenga, codificata in qualche modo, una stringa di testo.
# Scrivere uno script bash di sinossi:
# decode_decimal.sh <STRINGA> 
# che, prendendola come argomento, la decodifichi trasformandola in un
# testo leggibile e stampi tale testo al terminale.

STRINGA="$1"

if [ -z "$STRINGA" ]; then
    echo "Uso: $0 <numero_decimale_gigante>"
    exit 1
fi

# Controllo presenza 'bc' (essenziale)
if ! command -v bc >/dev/null 2>&1; then
    echo "Errore: 'bc' non trovato. Installalo per gestire numeri grandi."
    exit 1
fi

# 1. Conversione Decimale -> Hex (Universale)
# obase=16: output in esadecimale
# tr -d '\\\n': Rimuove i backslash e gli 'a capo' che bc inserisce su numeri lunghi
HEX_VAL=$(echo "obase=16; $STRINGA" | bc | tr -d '\\\n')

# 2. Conversione Hex -> ASCII (con Fallback Cross-Platform)
if command -v xxd >/dev/null 2>&1; then
    # Metodo Standard (Linux/Mac)
    echo "$HEX_VAL" | xxd -r -p
    echo "" 
elif command -v perl >/dev/null 2>&1; then
    # Metodo Fallback (Perl è ovunque su Unix)
    echo "$HEX_VAL" | perl -ne 's/([0-9a-f]{2})/print chr hex $1/gie'
    echo ""
else
    echo "Errore: Ne' xxd ne' perl trovati per la conversione ASCII."
    exit 1
fi 