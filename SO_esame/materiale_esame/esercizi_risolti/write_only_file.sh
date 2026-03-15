#!/bin/bash

#creare un file che è write only
#lo script deve far scrivere alla gente in append ma non leggere

FILE_SEGRETO="scatola_nera.txt"

if [ ! -e "$FILE_SEGRETO" ]; then 
    touch "$FILE_SEGRETO"
    echo "File creato!"
fi

chmod 622 "$FILE_SEGRETO"
echo "Permessi impostati..."
echo "Scrivi ora il tuo messaggio (premi INVIO e CTRL + D per terminare)"; then
if cat >> "$FILE_SEGRETO"; then
    echo -e "\n[ok] Messaggio aggiunto."
else 
    echo -e "\n[ERR] Errore nell'inserimento."

#versione funzioni

setup_blind_file() {
    local FILE="$1"
    # Crea se non esiste
    [ -f "$FILE" ] || touch "$FILE"
    # 6 (rw-) Proprietario
    # 2 (-w-) Gruppo
    # 2 (-w-) Altri (Blind Write)
    chmod 622 "$FILE"
    # check se è andato tutto ok e si può scrivere
    if [ -w "$FILE" ]; then
        echo "[SETUP] File '$FILE' pronto per la scrittura cieca."
    else
        echo "[ERROR] Impossibile impostare i permessi." >&2
        exit 1
    fi
}

append_data() {
    local FILE="$1"
    echo "--- INSERIMENTO DATI (Blind Mode) ---"
    echo "Digita il testo. Per salvare e uscire premi CTRL+D su una nuova riga."
    # Cattura input e appende. 
    # Funziona perché abbiamo permesso 'w' agli others.
    if cat >> "$FILE"; then
        echo -e "\n[SUCCESS] Dati salvati."
    else
        echo -e "\n[FAIL] Errore in scrittura." >&2
    fi
}
#MAIN
TARGET_FILE="archivio_confidenziale.dat"

setup_blind_file "$TARGET_FILE"
append_data "$TARGET_FILE"


