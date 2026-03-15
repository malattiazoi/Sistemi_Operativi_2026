#!/bin/bash

#scrivere uno script che chieda all'utente nome ed età, se è minorenne stampa errore con messaggio
#se è maggiorenne stampa un messaggio di benvenuto col suo nome, attenzione non passare in argomento le variabili.

read -p "inserire nome e premere INVIO: " NOME

read -p "inserire età e premere INVIO: " ETA

if [ -z "$NOME" ] || [ -z "$ETA" ]; then
	echo "Errore: dati mancanti"
	exit 1
fi

if ! [[ "$NOME" =~ ^[a-zA-Z\ ]+$ ]] ; then
	echo "Errore: carattere non valido"
	exit 1
fi

if [[ "$ETA" -ge 18 ]]; then 
	echo "Sei maggiorenne, benvenuto $NOME."
else
	TIME=$((18-ETA))
	echo "Purtroppo è ancora presto, ci vediamo fra $TIME anni."
fi











# #!/bin/bash

# # ==============================================================================
# # DEFINIZIONE FUNZIONI (UTILITY)
# # ==============================================================================

# # Funzione per controllare se una stringa è un numero intero valido
# # Utilizza una Regex (Regular Expression) all'interno di [[ ... ]]
# is_int() {
#     local VALORE="$1"
#     # ^ = Inizio stringa
#     # [0-9]+ = Uno o più numeri
#     # $ = Fine stringa
#     if [[ "$VALORE" =~ ^[0-9]+$ ]]; then
#         return 0 # VERO (In Bash 0 significa successo)
#     else
#         return 1 # FALSO (Errore)
#     fi
# }

# # ==============================================================================
# # LOGICA PRINCIPALE (MAIN)
# # ==============================================================================

# # 1. Acquisizione Dati
# # -p permette di stampare il messaggio direttamente nel read (più pulito)
# read -p "Inserisci il tuo nome: " NOME
# read -p "Inserisci la tua età:  " ETA

# # 2. Validazione Dati (Sanity Check)
# # Controllo se le variabili sono vuote
# if [ -z "$NOME" ]; then
#     echo "[ERRORE] Il nome non può essere vuoto."
#     exit 1
# fi

# # Controllo se l'età è un numero valido usando la funzione sopra
# if ! is_int "$ETA"; then
#     echo "[ERRORE] L'età inserita ('$ETA') non è un numero valido."
#     exit 1
# fi

# # 3. Logica di Business
# if [ "$ETA" -ge 18 ]; then
#     echo "------------------------------------"
#     echo "ACCESSO CONSENTITO"
#     echo "Benvenuto, $NOME. Prego, entra pure."
#     echo "------------------------------------"
# else
#     echo "------------------------------------"
#     echo "ACCESSO NEGATO"
#     echo "Spiacente $NOME, devi avere 18 anni."
#     echo "------------------------------------"
#     exit 1
# fi

# #!/bin/bash

# # Importo le librerie esterne (ipotizzando che esistano nella cartella utils)
# # source ./_UTILS/utils_checks.sh
# # source ./_UTILS/utils_logging.sh

# # Simuliamo l'importazione delle funzioni (per far girare lo script ora)
# log_error() { echo -e "\033[31m[ERROR]\033[0m $1" >&2; }
# log_success() { echo -e "\033[32m[OK]\033[0m $1"; }

# # --- INIZIO SCRIPT ---

# read -p "Nome: " NOME
# read -p "Età: " ETA

# # Validazione rapida
# [ -n "$NOME" ] || { log_error "Nome mancante"; exit 1; }
# [[ "$ETA" =~ ^[0-9]+$ ]] || { log_error "Età non valida"; exit 1; }

# # Logica
# if [ "$ETA" -ge 18 ]; then
#     log_success "Benvenuto $NOME"
# else
#     log_error "Accesso negato a $NOME (Minorenne)"
#     exit 1
# fi