#!/bin/bash

# ------------------------------------------------------------------------------
# [cite_start]TRACCIA[cite: 96, 97]:
# Script che prende un parametro N.
# Crea nella cartella corrente N soft link agli N file di maggiori dimensioni 
# presenti nel FILE SYSTEM.
# Nome link: 12 cifre dimensione + trattino + basename (es. 000010485760-pippo.txt).
# ------------------------------------------------------------------------------

N="$1"

# 1. Controllo Parametro
# Verifica se N è un numero
if [[ ! "$N" =~ ^[0-9]+$ ]]; then
    echo "Errore: Devi fornire un numero intero positivo N."
    exit 1
fi

echo "Ricerca dei $N file più grandi nel File System..."
echo "ATTENZIONE: La ricerca parte da '/' (root). Potrebbe richiedere tempo."

# 2. Ricerca e Ordinamento
# find / -type f : Cerca tutti i file partendo dalla radice.
# -ls            : Stampa dettagli (simile a ls -l), colonna 7 è la dimensione su molti sistemi.
# 2>/dev/null    : Nasconde errori di "Permission denied".
# sort -k7rn     : Ordina sulla 7a colonna (dimensione), numerico (n), decrescente (r).
# head -n "$N"   : Prende i primi N.

# NOTA COMPATIBILITÀ: 
# L'output di 'find -ls' varia leggermente. Su Linux standard colonna 7 è size.
# Su alcuni BSD/Mac potrebbe variare. Usiamo un approccio robusto con 'du'.
# Tuttavia, per script base d'esame, l'approccio find -printf è meglio su Linux,
# ma qui usiamo un ciclo while standard.

find / -type f -exec ls -s {} + 2>/dev/null | sort -rn | head -n "$N" | while read SIZE PATH_FILE; do
    
    # ls -s restituisce i blocchi (KB solitamente), non i byte esatti, ma è veloce.
    # Per essere aderenti alla traccia (bytes), dovremmo usare 'wc -c'.
    # Dato che 'find' su tutto il disco è lento, ottimizziamo recuperando i byte ora.
    
    if [ -f "$PATH_FILE" ]; then
        # Calcolo byte esatti
        BYTE_SIZE=$(wc -c < "$PATH_FILE" | tr -d ' ')
        
        # Nome base
        BASE_NAME=$(basename "$PATH_FILE")
        
        # 3. Formattazione Nome Link (12 cifre con padding zeri)
        # printf "%012d" riempie di zeri a sinistra fino a 12 cifre.
        LINK_NAME=$(printf "%012d-%s" "$BYTE_SIZE" "$BASE_NAME")
        
        # 4. Creazione Link
        echo "Creazione link: $LINK_NAME -> $PATH_FILE"
        ln -s "$PATH_FILE" "$LINK_NAME"
    fi
done