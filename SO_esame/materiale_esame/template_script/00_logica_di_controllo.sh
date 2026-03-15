#!/bin/bash

# ==============================================================================
# 00. LOGICA DI CONTROLLO: IF, FOR, WHILE, CASE (MACOS EDITION)
# ==============================================================================
# OBIETTIVO:
# Gestire il flusso dello script. Prendere decisioni e ripetere azioni.
#
# UTILIZZO NEGLI ESAMI:
# - ESAME 49: "Monitora processo e killalo dopo 3 min" (WHILE + SLEEP).
# - ESAME 191e: "Leggi input finché utente scrive 'fine'" (WHILE + READ).
# - ESAME 43: "Per ogni file trovato, chiedi all'utente" (FOR + IF).
#
# SINTASSI CRITICA:
# - [ ... ] : Test standard POSIX (più compatibile).
# - [[ ... ]] : Test avanzato Bash (più potente, gestisce meglio gli spazi).
# - (( ... )) : Test aritmetico (solo per numeri).



# - SGUARDO VELOCE ALL'UTILIZZO PARENTESI

pwd            # Sono in /home/mattia
(
    cd /tmp    # Cambio cartella SOLO qui dentro
    ls
)
pwd            # Sono ancora in /home/mattia (Magia!)

a=5
(( a++ ))           # Incrementa a (diventa 6)
(( b = a * 2 ))     # Moltiplicazione
if (( a > 3 )); then echo "Maggiore"; fi

# Esempio corretto (notare le virgolette obbligatorie)
if [ "$nome" = "Mario" ]; then ...

# Esempio potente
if [[ $nome == "Mario" && $eta -gt 18 ]]; then ...

# Esempio Regex (Solo con le doppie quadre!)
if [[ $file =~ \.jpg$ ]]; then ...

file="foto"
# Sbagliato: cerca la variabile $file_backup che non esiste
mv $file $file_backup  

# Corretto:
mv $file ${file}_backup.jpg

# Manipolazione (Funziona in Bash 3.2):
path="/home/mattia/file.txt"
echo ${path%.*}   # Rimuove l'estensione -> /home/mattia/file
echo ${path##*.}  # Estrae l'estensione -> txt

# Manda l'output di entrambi i comandi nello stesso file
{ echo "Start"; ls; } > log.txt

# Ricorda sempre gli SPAZI. Le parentesi quadre in Bash vogliono aria.

# [a=b] ❌ ERRORE

# [ a = b ] ✅ GIUSTO



# ==============================================================================

# ------------------------------------------------------------------------------
# 1. IL COSTRUTTO IF (PRENDERE DECISIONI)
# ------------------------------------------------------------------------------
# Sintassi: if [ condizione ]; then ... elif ... else ... fi

echo "--- 1. IF / ELSE ---"

FILE_TEST="test_file.txt"
touch "$FILE_TEST"

# 1.1 Controllo Esistenza File (-f, -d, -e)
if [ -f "$FILE_TEST" ]; then
    echo "Il file $FILE_TEST esiste."
else
    echo "Il file non esiste."
fi

# 1.2 Confronto Stringhe (=, !=, -z, -n)
# -z = Stringa vuota (Zero length)
# -n = Stringa non vuota
UTENTE="Mario"

if [ "$UTENTE" == "Mario" ]; then
    echo "Ciao Mario!"
elif [ -z "$UTENTE" ]; then
    echo "Errore: Utente vuoto."
else
    echo "Ciao sconosciuto."
fi

# 1.3 Confronto Numerico (-eq, -ne, -gt, -lt)
# eq=equal, ne=not equal, gt=greater than, lt=less than
# ESAME 49: Utile per contare i minuti.
COUNT=5
if [ "$COUNT" -gt 3 ]; then
    echo "Il contatore è maggiore di 3."
fi


# ------------------------------------------------------------------------------
# 2. CICLO FOR (RIPETERE SU UNA LISTA)
# ------------------------------------------------------------------------------
# Ideale per: "Per ogni file nella cartella...", "Per ogni argomento passato..."

echo "----------------------------------------------------------------"
echo "--- 2. CICLO FOR ---"

# 2.1 Loop su file (Globbing)
# Shopt nullglob evita errori se non ci sono txt
shopt -s nullglob
echo "Elenco file .txt:"
for FILE in *.txt; do
    echo "Trovato file: $FILE"
    # Qui potresti fare operazioni (es. mv, cp, sed)
done
shopt -u nullglob

# 2.2 Loop Numerico (Range)
# Sintassi {start..end}
echo "Conto da 1 a 3:"
for i in {1..3}; do
    echo "Numero $i"
done

# 2.3 C-Style Loop (Avanzato)
for (( i=0; i<3; i++ )); do
    echo "Indice $i"
done


# ------------------------------------------------------------------------------
# 3. CICLO WHILE (RIPETERE FINCHÉ VERO)
# ------------------------------------------------------------------------------
# Ideale per: Monitoraggio continuo, Lettura file riga per riga, Menu interattivi.

echo "----------------------------------------------------------------"
echo "--- 3. CICLO WHILE ---"

# 3.1 Loop Infinito con break (SOLUZIONE ESAME 191e)
# "Leggi righe finché l'utente scrive 'fine'"
echo "Scrivi parole (digita 'fine' per uscire):"
while true; do
    read -p "> " INPUT
    
    # Controllo uscita
    if [ "$INPUT" == "fine" ]; then
        echo "Terminazione richiesta."
        break
    fi
    
    echo "Hai scritto: $INPUT"
    # In esame 191e qui appenderesti al file >> segreto.txt
done


# 3.2 Loop Basato su Condizione (SOLUZIONE ESAME 49 - MONITORAGGIO)
# "Controlla se un processo è attivo ogni X secondi"
# Esempio simulato (timeout dopo 3 cicli)
SECONDS_PASSED=0
LIMIT=3

while [ "$SECONDS_PASSED" -lt "$LIMIT" ]; do
    echo "Monitoraggio in corso... (Minuto $SECONDS_PASSED)"
    # Qui controlleresti: pgrep "nome_gioco"
    
    ((SECONDS_PASSED++))
    # sleep 1 # Simuliamo attesa (in esame sleep 60)
done
echo "Tempo scaduto."


# ------------------------------------------------------------------------------
# 4. CASE (MENU E SCELTE MULTIPLE)
# ------------------------------------------------------------------------------
# Più pulito di tanti if/elif. Ottimo per gestire flag o estensioni file.

echo "----------------------------------------------------------------"
echo "--- 4. CASE STATEMENT ---"

FILE_EXT="foto.jpg"

case "$FILE_EXT" in
    *.jpg|*.jpeg)
        echo "È un'immagine JPEG."
        ;;
    *.txt)
        echo "È un file di testo."
        ;;
    *)
        echo "Formato sconosciuto."
        ;;
esac


# ------------------------------------------------------------------------------
# 5. TEST AVANZATI ([[ ]]) E OPERATORI LOGICI (&&, ||)
# ------------------------------------------------------------------------------
# && (AND): Esegui solo se il precedente ha successo.
# || (OR):  Esegui solo se il precedente fallisce.

echo "----------------------------------------------------------------"
echo "--- 5. LOGICA AVANZATA ---"

# Esempio &&: Crea directory E POI entra
mkdir -p test_dir && cd test_dir && echo "Sono dentro test_dir" && cd ..

# Esempio ||: Se il file non esiste, crealo
[ -f "non_esiste.txt" ] || touch "non_esiste.txt"

# Regex dentro IF (Solo con [[ ]])
# ESAME 43: "Cerca file con caratteri non alfanumerici"
NOME_FILE="ciao@mondo.txt"
if [[ "$NOME_FILE" =~ [^a-zA-Z0-9.] ]]; then
    echo "Il file '$NOME_FILE' contiene caratteri speciali!"
fi


# ==============================================================================
# 🧩 SCENARI D'ESAME RISOLTI
# ==============================================================================

echo "----------------------------------------------------------------"
echo "--- SCENARI D'ESAME ---"

# SCENARIO ESAME 49: MONITORAGGIO E KILL
# "Se il processo GIOCO gira per 3 minuti, killalo."
# ------------------------------------------------------
# Logic Flow:
# 1. Controlla se esiste (pgrep).
# 2. Se esiste, aspetta.
# 3. Se esiste ancora dopo il tempo limite, kill.

check_and_kill() {
    TARGET_PROC="sleep" # Simuliamo con sleep
    MAX_TIME=2 # Secondi (in esame minuti)
    
    # Lanciamo un processo dummy per testare
    sleep 10 &
    PID_GIOCO=$!
    echo "Processo gioco avviato (PID $PID_GIOCO)"
    
    slept=0
    while kill -0 "$PID_GIOCO" 2>/dev/null; do
        echo "Il gioco è attivo..."
        sleep 1
        ((slept++))
        
        if [ "$slept" -ge "$MAX_TIME" ]; then
            echo "Tempo limite raggiunto! Terminazione forzata."
            kill -9 "$PID_GIOCO"
            break
        fi
    done
}
# check_and_kill # Decommenta per testare

# SCENARIO ESAME 43: RINOMINA INTERATTIVA
# "Trova file con caratteri strani e chiedi nuovo nome"
# ------------------------------------------------------
# for F in *; do
#    if [[ "$F" =~ [^a-zA-Z0-9] ]]; then
#       read -p "Trovato file strano '$F'. Nuovo nome? " NEW_NAME
#       mv "$F" "$NEW_NAME"
#    fi
# done


# ==============================================================================
# ⚠️ TABELLA OPERATORI DI TEST
# ==============================================================================
# | OPERATORE | SIGNIFICATO (FILE)             | SIGNIFICATO (STRINGHE) |
# |-----------|--------------------------------|------------------------|
# | -e        | Esiste                         | -                      |
# | -f        | È un file regolare             | -                      |
# | -d        | È una directory                | -                      |
# | -z        | -                              | È vuota (lunghezza 0)  |
# | -n        | -                              | NON è vuota            |
# | ==        | -                              | Uguale a               |
# | !=        | -                              | Diverso da             |
# | =~        | -                              | Match Regex (solo [[)  |

# Pulizia
rm -f test_file.txt non_esiste.txt
rmdir test_dir
echo "----------------------------------------------------------------"
echo "Tutorial Logica Completato."