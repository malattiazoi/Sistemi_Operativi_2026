#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# [cite_start]Un minorenne trascorre troppo tempo giocando con due computer games[cite: 109].
# Fare in modo che, a tre minuti dall'avvio di ciascuno, l'esecuzione sia 
# [cite_start]interrotta senza che il ragazzo si renda conto del motivo[cite: 110].
# [cite_start]Suggerimento: testare con due programmi a caso[cite: 112].
# ------------------------------------------------------------------------------

# [cite_start]Definisco i nomi dei processi da monitorare (come da suggerimento [cite: 112])
# Puoi cambiarli con "Minecraft", "Fortnite", o per testare usare "Calculator" o "TextEdit"
GAME_1="Calculator"
GAME_2="TextEdit"
LIMIT_MINUTES=3

# Funzione per convertire il formato tempo di 'ps' (MM:SS o HH:MM:SS) in minuti
get_minutes() {
    local TIME_STR="$1"
    
    # ps restituisce il tempo trascorso (etime) in vari formati:
    # MM:SS (es. 03:15) oppure HH:MM:SS (es. 01:03:15)
    
    # Estraggo i pezzi usando ':' come separatore
    # IFS (Input Field Separator) permette di spezzare la stringa
    IFS=':' read -r -a PARTS <<< "$TIME_STR"
    
    local LEN=${#PARTS[@]}
    local MINS=0
    
    if [ "$LEN" -eq 2 ]; then
        # Formato MM:SS -> La prima parte sono i minuti
        # 10# serve a forzare la base 10 (evita errori se il numero inizia con 0, es 08)
        MINS=$((10#${PARTS[0]}))
    elif [ "$LEN" -eq 3 ]; then
        # Formato HH:MM:SS -> Ore * 60 + Minuti
        local HOURS=$((10#${PARTS[0]}))
        local M=$((10#${PARTS[1]}))
        MINS=$((HOURS * 60 + M))
    fi
    
    echo "$MINS"
}

# [cite_start]Loop infinito (Simulazione Login Item) [cite: 111]
while true; do
    
    # Cerco i processi dei giochi
    # ps -eo comm,etime,pid : Stampa Comando, Tempo Trascorso, PID per tutti i processi
    # grep : Filtra solo le righe che contengono i nomi dei giochi
    
    ps -eo comm,etime,pid | grep -E "$GAME_1|$GAME_2" | while read CMD TIME PID; do
        
        # Ignoro il processo grep stesso (che potrebbe apparire nel listing)
        if [[ "$CMD" == "grep" ]]; then continue; fi
        
        # Calcolo da quanti minuti è attivo
        RUNNING_MINS=$(get_minutes "$TIME")
        
        # Log di debug (opzionale, per vedere cosa succede)
        # echo "Check: $CMD (PID $PID) attivo da $RUNNING_MINS minuti."
        
        # Se supera il limite, uccido il processo
        if [ "$RUNNING_MINS" -ge "$LIMIT_MINUTES" ]; then
            # [cite_start]kill -9 è un'uccisione immediata (sigkill), sembra un crash [cite: 110]
            kill -9 "$PID" 2>/dev/null
        fi
        
    done
    
    # Attendo 10 secondi prima del prossimo controllo per non sovraccaricare la CPU
    sleep 10
done
