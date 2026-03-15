#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# 1) Stampare frase target: "Ma la volpe col suo balzo ha raggiunto il quieto Fido"
# 2) Computare il tempo dal PRIMO tasto premuto.
# 3) Stop se frase esatta O trascorsi 45 secondi.
# 4) Stampare tempo e posizione in classifica.
# 5) Mac: secondi. [cite_start]Linux: millisecondi.
# ------------------------------------------------------------------------------

TARGET_PHRASE="Ma la volpe col suo balzo ha raggiunto il quieto Fido"
TIMEOUT=45
RANK_FILE="classifica_tempi.txt"

# 1. Rilevamento OS e Funzione Tempo
# Su Linux 'date +%s%3N' dà millisecondi. Su Mac 'date +%s' dà secondi (coreutils non garantite).
OS_TYPE=$(uname)

get_current_time() {
    if [ "$OS_TYPE" == "Linux" ]; then
        # Millisecondi
        date +%s%3N
    else
        # Secondi (Mac)
        date +%s
    fi
}

calc_diff() {
    local END=$1
    local START=$2
    echo $((END - START))
}

# 2. Setup Interfaccia
echo "-----------------------------------------------------------------"
echo "SFIDA DI VELOCITÀ"
echo "Frase da scrivere: \"$TARGET_PHRASE\""
echo "Hai massimo $TIMEOUT secondi. Il tempo parte appena tocchi un tasto."
echo "-----------------------------------------------------------------"
echo -n "Pronto? Inizia a scrivere > "

# 3. Logica di Input (Il cuore dell'esercizio)
# Leggiamo il PRIMO carattere separatamente per far partire il timer ESATTAMENTE lì.
# -s = silent (lo ristampiamo noi dopo), -n 1 = un solo carattere.
read -s -n 1 FIRST_CHAR

# START TIMER
START_TIME=$(get_current_time)

# Stampo il carattere appena premuto (altrimenti l'utente non lo vede)
printf "$FIRST_CHAR"

# Leggo il RESTO della riga con timeout
# Poiché abbiamo perso qualche millisecondo per leggere il primo char, il timeout
# è tecnicamente 45 meno delta, ma per uno script bash $TIMEOUT va bene.
if read -t "$TIMEOUT" REST_OF_LINE; then
    # Input completato prima del timeout (invio premuto)
    INPUT_FULL="$FIRST_CHAR$REST_OF_LINE"
else
    # Timeout scaduto (read ritorna > 128)
    echo ""
    echo "[TEMPO SCADUTO!]"
    # Anche se scade, proviamo a salvare quello che ha scritto
    INPUT_FULL="$FIRST_CHAR$REST_OF_LINE" # Nota: su timeout bash potrebbe non riempire REST
fi

# STOP TIMER
END_TIME=$(get_current_time)
ELAPSED=$(calc_diff "$END_TIME" "$START_TIME")

echo "" # A capo dopo l'input

# 4. Verifica Correttezza
if [ "$INPUT_FULL" == "$TARGET_PHRASE" ]; then
    echo "COMPLIMENTI! Frase corretta."
    
    # 5. Gestione Classifica
    # Salviamo il tempo nel file. 
    echo "$ELAPSED" >> "$RANK_FILE"
    
    # Calcolo Posizione
    # sort -n : ordina numerico crescente (miglior tempo = numero più basso)
    # grep -n : trova numero riga
    # cut : estrae solo il numero di riga
    # head -1 : prende la prima occorrenza (in caso di tempi uguali)
    
    # Nota: Uso sort -n che funziona sia con interi (Mac) che numeri grandi (Linux ms)
    RANK=$(sort -n "$RANK_FILE" | grep -n -w "$ELAPSED" | head -1 | cut -d: -f1)
    TOTAL=$(wc -l < "$RANK_FILE" | tr -d ' ')
    
    # [cite_start]6. Output Finale [cite: 128, 129]
    if [ "$OS_TYPE" == "Linux" ]; then
        echo "Tempo impiegato: $ELAPSED ms"
    else
        echo "Tempo impiegato: $ELAPSED secondi"
    fi
    echo "Sei in posizione $RANK su $TOTAL tentativi!"

else
    echo "ERRORE O INCOMPLETO."
    echo "Hai scritto: \"$INPUT_FULL\""
    echo "Tentativo non valido per la classifica."
fi