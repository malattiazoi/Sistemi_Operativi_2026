#!/bin/bash

#scrivere uno script che simuli un parental control
#1 avviamo un gioco simulato (sleep un sacco in background)
#2 stampare il suo PID
#3 monitorare il processo e dopo 3 secondi di vita KILLARLO
#4 stampa un messaggio a schermo di conferma


echo "---avvio in background gioco---"

sleep 50 &

#PID=$! prende l'ultimo comando mandato in background
PID_GIOCO=$!
echo="individuato videogame illeggittimo al PID: $PID_GIOCO"

MAX_TIME=3
EXEC_TIME=0

#kill -0 torna zero fino a quando il processo esiste
while kill -0 "$PID_GIOCO" 2>/dev/null; do
	echo "il gioco è attivo da $EXEC_TIME secondi..."
	if [ "$EXEC_TIME" -ge "$MAX_TIME" ]; then
	kill -9 "$PID_GIOCO"
	else
	sleep 1
	((EXEC_TIME++)) 
	fi
done

echo "game killed!"


#se volessi cercare il PID per nome o user,

# Funzione: Cerca per NOME
# Output: Stampa righe nel formato "PID:UID" (coppia separata da due punti)
cerca_pid_nome() {
    local ricerca="$1"
    
    # ps -A -o pid,uid,command: Prende PID, UID e Comando 
	# ps stampa i processi -A tutti di tutti gli utenti
	# -o ordina per quello che voglio
    # grep: Filtra -i ignora maiuscole e minuscole -v stampa
	# quello che non matcha con la ricerca
    # awk: Pulisce tutto e stampa SOLO "PID:UID" (colonna 1 e 2)
    ps -A -o pid,uid,command | grep -i "$ricerca" | grep -v grep | awk '{print $1":"$2}'
}

# Funzione: Cerca per UTENTE
# Output: Stampa righe nel formato "PID:UID"
cerca_pid_utente() {
    local utente="$1"
    
    # 2>/dev/null nasconde errori se l'utente non esiste
    ps -u "$utente" -o pid,uid 2>/dev/null | grep -v "PID" | awk '{print $1":"$2}'
}

# esempio di utilizzo, magari ci facciamo passare da terminale
# quello che dobbiamo cercare o ci mettiamo un read nello script

LISTA_OUTPUT=() #array aggiunge con +=(elemento)
NOME="ollama"
USER="root"
echo "cerco processi con nome '$NOME'..."

OUTPUT=$(cerca_pid_nome("$NOME"))

for riga in $OUTPUT; do
	if [ -n "$riga" ]; then	#
		LISTA_OUTPUT*=("$riga")
	fi
done

echo "aggiungo i processi di '$USER'..."

OUTROOT=$(cerca_pid_utente("$USER"))

for elemento in $OUTROOT; do
	[ -n "$elemento" ] && LISTA_OUTPUT+=("$elemento")
done

echo "OUTPUT: elementi trovati ${#LISTA_OUTPUT[@]}"
printf printf "%-10s %-10s\n" "PID" "UID"

for elemento in "${LISTA_OUTPUT[@]}"; do
	PID="${elemento%:*}" #tutto prima di :
	UID="${elemento#*:}" #tutto dopo di :
	printf "%-10s %-10s\n" "$PID" "$UID"

	if [[ $UID == 0 ]]; then echo "PROCESSO ROOT: $PID"
	fi
done











# #!/bin/bash

# # ==============================================================================
# # FUNZIONI UTILS
# # ==============================================================================

# # Controlla se un PID è in esecuzione
# is_running() {
#     local PID="$1"
#     # Redirigo stderr su null per non vedere errori se il processo non esiste
#     kill -0 "$PID" 2>/dev/null
# }

# # Funzione Watchdog: Monitora e Killa dopo timeout
# # Uso: watchdog_kill <PID> <TIMEOUT_SEC>
# watchdog_kill() {
#     local PID="$1"
#     local TIMEOUT="$2"
#     local ELAPSED=0

#     echo "[WATCHDOG] Monitoraggio PID $PID (Max: ${TIMEOUT}s)"

#     while is_running "$PID"; do
#         if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
#             echo "[KILL] Tempo scaduto per PID $PID."
#             kill -9 "$PID"
#             return 0
#         fi
        
#         sleep 1
#         ((ELAPSED++))
#         # echo -n "." # Feedback visivo opzionale (puntini)
#     done
#     echo "" # A capo finale
# }

# # ==============================================================================
# # MAIN
# # ==============================================================================

# echo "Simulazione: Avvio 'sleep 20'..."
# sleep 20 &
# MY_PID=$!

# # Chiamo la funzione di controllo (Imposto limite a 3 secondi)
# watchdog_kill "$MY_PID" 3

# # Verifica finale (Opzionale)
# if is_running "$MY_PID"; then
#     echo "Errore: Il processo è ancora vivo!"
# else
#     echo "Successo: Il processo è stato terminato."
# fi

# #!/bin/bash

# # Imports
# source ./_UTILS/utils_logging.sh
# source ./_UTILS/utils_process.sh

# # Main
# log_info "Avvio simulazione gioco..."
# sleep 20 &
# TARGET_PID=$!

# log_info "Gioco partito (PID: $TARGET_PID). Attivo controllo parentale..."

# # La funzione kill_timeout è già pronta in utils_process.sh!
# # Fa esattamente quello che chiede l'esame.
# kill_timeout "$TARGET_PID" "3"

# log_success "Sistema pulito."