#!/bin/bash

# ==============================================================================
#   PROCESS HUNTER (Bash 3.2 Compatible)
#   Descrizione: Cerca processi per Nome, Utente (UID) o controlla un PID.
# ==============================================================================

# Funzione per mostrare come si usa lo script (Help Menu)
# È fondamentale negli esami per mostrare che sai gestire gli errori dell'utente.
usage() {
    echo "Utilizzo: $0 [OPZIONE] [VALORE]"
    echo "Opzioni:"
    echo "  -n [nome]   Cerca PID tramite nome del programma (es. 'chrome')"
    echo "  -u [user]   Cerca tutti i processi di un utente (Nome o UID)"
    echo "  -p [pid]    Verifica se uno specifico PID è in esecuzione"
    echo "  -h          Mostra questo aiuto"
    exit 1
}

# Se non ci sono argomenti, mostra l'help e esci
if [ $# -eq 0 ]; then
    usage
fi

# ==============================================================================
# PARSING DEGLI ARGOMENTI (getopts)
# ==============================================================================
# getopts è il modo standard per gestire flag come -n, -u, -p.
# 'n:u:p:h' significa:
#   n: -> accetta un argomento (il nome)
#   u: -> accetta un argomento (l'user)
#   p: -> accetta un argomento (il pid)
#   h  -> non accetta argomenti (flag semplice)

MODE=""
VALORE=""

while getopts "n:u:p:h" opt; do
    case $opt in
        n)
            MODE="NAME"
            VALORE="$OPTARG" # $OPTARG contiene il valore passato dopo il flag
            ;;
        u)
            MODE="USER"
            VALORE="$OPTARG"
            ;;
        p)
            MODE="PID"
            VALORE="$OPTARG"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Opzione non valida: -$OPTARG" >&2
            usage
            ;;
    esac
done

# ==============================================================================
# LOGICA DI RICERCA
# ==============================================================================

# Controllo se è stata selezionata una modalità
if [ -z "$MODE" ]; then
    echo "Errore: Devi specificare una modalità (-n, -u, -p)."
    usage
fi

echo "--- Risultati Ricerca ($MODE: $VALORE) ---"
printf "%-8s %-12s %-s\n" "PID" "UTENTE" "COMANDO" # Header formattato
echo "--------------------------------------------------"

case "$MODE" in
    NAME)
        # 1. Ricerca per NOME
        # ps -A : Mostra tutti i processi
        # -o pid,user,command : Stampa solo colonne PID, Utente e Comando
        # grep -i : Cerca ignorando maiuscole/minuscole
        # grep -v grep : ESCLUDE il processo grep stesso dai risultati (Cruciale!)
        
        ps -A -o pid,user,command | grep -i "$VALORE" | grep -v grep | while read line; do
            # Se la riga non è vuota, la stampiamo
            if [ -n "$line" ]; then
                echo "$line"
            fi
        done
        
        # Controllo se grep ha trovato qualcosa usando $PIPESTATUS (Avanzato)
        # Oppure verifichiamo se l'output era vuoto. Un modo semplice in esame:
        # Se volevi solo i PID nudi e crudi potevi usare: pgrep -i "$VALORE"
        ;;

    USER)
        # 2. Ricerca per UTENTE (Nome o UID)
        # L'opzione -u di ps accetta sia nomi (root) che ID (0)
        
        # Controllo se l'utente esiste (opzionale ma carino)
        # id -u nome_utente > /dev/null 2>&1
        
        ps -u "$VALORE" -o pid,user,command 2>/dev/null
        
        if [ $? -ne 0 ]; then
             echo "Nessun processo trovato per l'utente '$VALORE' o utente inesistente."
        fi
        ;;

    PID)
        # 3. Verifica esistenza PID
        # L'opzione -p cerca esattamente quel PID
        
        # Regex per controllare che l'input sia solo numeri (visto prima!)
        if [[ ! "$VALORE" =~ ^[0-9]+$ ]]; then
            echo "ERRORE: Il PID deve essere un numero intero."
            exit 1
        fi

        ps -p "$VALORE" -o pid,user,command | grep -v "PID" # Rimuovo l'header originale di ps
        
        # $? è l'exit status dell'ultimo comando. 
        # Se ps trova il PID, ritorna 0. Altrimenti 1.
        if [ ${PIPESTATUS[0]} -eq 0 ]; then
             echo "-> Il processo è ATTIVO."
        else
             echo "-> Il processo $VALORE NON esiste o è terminato."
        fi
        ;;
esac

echo "--------------------------------------------------"