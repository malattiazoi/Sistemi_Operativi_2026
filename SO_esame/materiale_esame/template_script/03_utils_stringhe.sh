#!/bin/bash

# ==============================================================================
# UTILS: MANIPOLAZIONE STRINGHE (MAC BASH 3.2 SAFE)
# ==============================================================================
# OBIETTIVO:
# Fornire funzioni per modificare stringhe che funzionino anche sulle vecchie
# versioni di Bash presenti su macOS, dove ${VAR^^} non esiste.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CONVERSIONE MAIUSCOLO / MINUSCOLO
# ------------------------------------------------------------------------------
# Usa 'tr' o 'awk' per garantire compatibilità totale.

# Uso: VAR_UP=$(to_upper "ciao")
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Uso: VAR_LOW=$(to_lower "CIAO")
to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# ------------------------------------------------------------------------------
# 2. TRIM (RIMUOVERE SPAZI INIZIALI E FINALI)
# ------------------------------------------------------------------------------
# Spesso 'wc -l' o output di comandi lasciano spazi sporchi.
# Questa funzione pulisce la stringa.
# Uso: PULITO=$(trim "   ciao mondo   ")

trim() {
    local VAR="$1"
    # Usa sed per rimuovere spazi inizio (^) e fine ($)
    # xargs è anche un trucco veloce: echo "  a  " | xargs
    echo "$VAR" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

# ------------------------------------------------------------------------------
# 3. CONTAINS (CERCARE SOTTOSTRINGA)
# ------------------------------------------------------------------------------
# Verifica se una stringa ne contiene un'altra.
# Uso: if contains "La mela rossa" "mela"; then ...

contains() {
    local HAYSTACK="$1" # Il pagliaio
    local NEEDLE="$2"   # L'ago

    # Sintassi Bash [[ string == *substring* ]] (Wildcard)
    if [[ "$HAYSTACK" == *"$NEEDLE"* ]]; then
        return 0 # Trovato (True)
    else
        return 1 # Non trovato (False)
    fi
}

# ------------------------------------------------------------------------------
# 4. SPLIT (DIVIDERE STRINGA IN ARRAY)
# ------------------------------------------------------------------------------
# Divide una stringa in base a un delimitatore.
# Uso: split_str "mario,luigi,anna" ","

split_str() {
    local STRING="$1"
    local DELIMITER="$2"
    
    # Impostiamo IFS temporaneamente
    local OLD_IFS="$IFS"
    IFS="$DELIMITER"
    
    # Leggiamo in un array
    read -ra ADDR <<< "$STRING"
    
    # Ripristiniamo IFS
    IFS="$OLD_IFS"
    
    # Stampiamo gli elementi (o li usiamo)
    for i in "${ADDR[@]}"; do
        echo "$i"
    done
}

# ------------------------------------------------------------------------------
# 5. CHECK_NOME (CONTROLLO INSERIMENTO NOME)
# ------------------------------------------------------------------------------
# Controlla se è stato inserito un nome
# senza caratteri speciali

check_nome() {
    # La regex ^[a-zA-Z\ ]+$ significa:
    # ^       = Inizio stringa
    # [a-zA-Z ] = Accetta solo lettere e spazi
    # +       = Deve esserci almeno un carattere
    # $       = Fine stringa
    
    if [[ "$1" =~ ^[a-zA-Z\ ]+$ ]]; then
        return 0  # 0 significa VERO (Successo) in Bash
    else
        return 1  # 1 significa FALSO (Errore)
    fi
}

# --- ESEMPIO DI UTILIZZO ---
echo -n "Inserisci il tuo nome: "
read input_utente

if check_nome "$input_utente"; then
    echo "Nome valido: $input_utente"
else
    echo "Errore: Il nome non può contenere numeri o simboli!"
fi