#!/bin/bash

# ==============================================================================
# 02. GESTIONE INPUT AVANZATA: GETOPTS E SELECT (INTERFACCE UTENTE)
# ==============================================================================
# OBIETTIVO:
# 1. Creare script professionali che accettano flag (es. ./script.sh -v -u mario).
# 2. Creare menu interattivi per l'utente (es. "Scegli 1 per Backup").
#
# AMBIENTE: macOS (Bash 3.2)
# ==============================================================================

# ------------------------------------------------------------------------------
# PARTE 1: GETOPTS (PARSING ARGOMENTI RIGA DI COMANDO)
# ------------------------------------------------------------------------------
# getopts è un comando built-in progettato per processare opzioni a lettera singola.
# SINTASSI: getopts "stringa_opzioni" variabile
#
# LA STRINGA OPZIONI (CRITICA):
# - "a"    -> Cerca il flag -a (senza argomenti).
# - "b:"   -> Cerca il flag -b CHE RICHIEDE UN ARGOMENTO (i due punti lo indicano).
# - ":ab:" -> I due punti INIZIALI attivano la modalità "Silenziosa" (gestione errori manuale).

echo "--- 1. ESEMPIO GETOPTS ---"

# Definiamo valori di default
VERBOSE=false
USERNAME="Guest"
FILE_OUTPUT=""

# Simuliamo degli argomenti per testare lo script senza doverlo lanciare da terminale
# (In un script reale, questi sono passati dall'utente dopo il nome dello script)
# Resettiamo OPTIND (fondamentale se si usa getopts più volte nello stesso script)
OPTIND=1

# Funzione per simulare l'uso reale
processa_argomenti() {
    # Ciclo while che parsa gli argomenti uno per uno
    # "vu:f:" significa:
    # -v (flag semplice)
    # -u (richiede argomento, es. -u mario)
    # -f (richiede argomento, es. -f log.txt)
    while getopts "vu:f:" opt; do
        case $opt in
            v)
                VERBOSE=true
                echo "Modalità Verbosa ATTIVATA (-v)"
                ;;
            u)
                # $OPTARG contiene il valore passato dopo il flag
                USERNAME="$OPTARG"
                echo "Utente impostato a: $USERNAME (-u)"
                ;;
            f)
                FILE_OUTPUT="$OPTARG"
                echo "File di output: $FILE_OUTPUT (-f)"
                ;;
            \?)
                # Case di default per opzioni non valide (es. -z)
                echo "Errore: Opzione non valida -$OPTARG" >&2
                return 1
                ;;
            :)
                # Case per opzioni che richiedevano un argomento ma non l'hanno avuto
                echo "Errore: L'opzione -$OPTARG richiede un argomento." >&2
                return 1
                ;;
        esac
    done
}

# Testiamo la funzione con un set di argomenti simulati
echo "Simulazione comando: ./script.sh -v -u Admin -f report.txt"
# set -- imposta i parametri posizionali ($1, $2...) della shell corrente
set -- -v -u "Admin" -f "report.txt"
processa_argomenti "$@"

echo "--- Stato Finale Variabili ---"
echo "Verbose: $VERBOSE"
echo "User:    $USERNAME"
echo "File:    $FILE_OUTPUT"


# ------------------------------------------------------------------------------
# 2. OPTIND E SHIFT (PULIZIA ARGOMENTI)
# ------------------------------------------------------------------------------
# Dopo aver processato i flag (-a, -b...), spesso rimangono degli argomenti "liberi"
# (es. il nome di un file alla fine del comando: ./script.sh -v file.txt).
# getopts NON tocca questi argomenti. Dobbiamo usare 'shift'.

echo "----------------------------------------------------------------"
echo "--- 2. PULIZIA ARGOMENTI (SHIFT) ---"

# Simuliamo: ./script.sh -v file_da_processare.txt
set -- -v "file_da_processare.txt"
OPTIND=1 # Reset necessario per la demo

# Parsiamo solo il -v
while getopts "v" opt; do
    case $opt in
        v) echo "Flag -v trovato";;
    esac
done

# A questo punto $1 è ancora "-v". Dobbiamo spostare il puntatore.
# La formula magica è: shift $((OPTIND - 1))
shift $((OPTIND - 1))

echo "Dopo lo shift, il primo argomento (\$1) è: $1"
# Ora $1 contiene "file_da_processare.txt", pronto per essere usato.


# ------------------------------------------------------------------------------
# 3. SELECT (CREAZIONE MENU INTERATTIVI)
# ------------------------------------------------------------------------------
# 'select' crea automaticamente un menu numerato.
# Funziona in loop infinito finché non incontra 'break'.
# Variabile PS3: Definisce il prompt del menu (default "#? ").

echo "----------------------------------------------------------------"
echo "--- 3. MENU SELECT ---"

# Impostiamo il prompt
PS3="Seleziona un'operazione (1-4): "

echo "Benvenuto nel pannello di controllo."

# Le opzioni del menu sono passate come lista a 'select'
# Simuliamo un input utente usando una pipe per non bloccare lo script
# (In un caso reale, rimuovi la pipe 'echo 2 |' per farlo interattivo)

# Nota: select usa l'input standard. Qui simuliamo che l'utente prema "2".
# Incolla questo blocco nel terminale senza la pipe per testarlo davvero.

(echo "2"; sleep 1; echo "4") | while true; do
    # Questo è il blocco select reale
    select scelta in "Backup" "Monitoraggio" "Pulizia" "Esci"; do
        
        # 'select' mette la scelta dell'utente nella variabile $scelta
        # Se l'utente digita un numero non valido, $scelta è vuota.
        
        case $scelta in
            "Backup")
                echo "--> Avvio procedura di Backup..."
                # Qui chiameresti la funzione backup()
                break # Esce dal select, torna al while (o finisce se non c'è while)
                ;;
            "Monitoraggio")
                echo "--> Avvio top e vm_stat..."
                # Qui chiameresti monitor()
                break
                ;;
            "Pulizia")
                echo "--> Svuotamento cache..."
                # Qui chiameresti clean()
                break
                ;;
            "Esci")
                echo "Arrivederci!"
                break 2 # Esce dal select E dal loop esterno (se presente)
                ;;
            *)
                echo "Scelta non valida ($REPLY). Riprova."
                # Non mettiamo break, così il menu viene ristampato
                ;;
        esac
    done
    
    # Se siamo qui, siamo usciti da un break.
    # In questo esempio simulato usciamo anche dal while finto.
    break 
done


# ------------------------------------------------------------------------------
# 4. GESTIONE INPUT MISTO (GETOPTS + INTERATTIVO)
# ------------------------------------------------------------------------------
# Pattern Professionale:
# Se l'utente passa argomenti, esegui senza chiedere nulla (Batch Mode).
# Se l'utente NON passa argomenti, mostra il menu (Interactive Mode).

echo "----------------------------------------------------------------"
echo "--- 4. PATTERN IBRIDO (BATCH vs INTERACTIVE) ---"

# Funzione simulata Main
main_logic() {
    # Se il numero di argomenti ($#) è maggiore di 0, usa getopts
    if [ $# -gt 0 ]; then
        echo "MODALITÀ BATCH (Non interattiva)"
        while getopts "bme" opt; do
            case $opt in
                b) echo "Eseguo Backup...";;
                m) echo "Eseguo Monitoraggio...";;
                e) echo "Esco.";;
                *) echo "Opzione errata"; exit 1;;
            esac
        done
    else
        # Altrimenti, mostra il menu
        echo "MODALITÀ INTERATTIVA (Nessun argomento passato)"
        PS3="Scegli azione: "
        # select ... (codice del menu visto sopra)
        echo "[Qui apparirebbe il menu select]"
    fi
}

echo "Test 1: Con argomenti (-b -m)"
set -- -b -m
main_logic "$@"

echo "Test 2: Senza argomenti"
set -- 
main_logic "$@"


# ==============================================================================
# 🧩 SCENARIO D'ESAME: VALIDATORE INPUT
# ==============================================================================
# "Lo script deve chiedere l'età e assicurarsi che sia un numero."

echo "----------------------------------------------------------------"
echo "--- SCENARIO: VALIDAZIONE INPUT (READ) ---"

# Funzione di validazione
chiedi_eta() {
    while true; do
        # -p: Prompt (Messaggio)
        # read su Mac non supporta -i (valore iniziale) o -e (readline) avanzato di Linux
        echo -n "Inserisci la tua età: "
        # Simuliamo input per non bloccare
        # read ETA
        ETA="25" 
        echo "$ETA (Simulato)"
        
        # Validazione con Regex (solo numeri)
        if [[ "$ETA" =~ ^[0-9]+$ ]]; then
            if [ "$ETA" -ge 18 ]; then
                echo "Accesso Consentito."
                return 0
            else
                echo "Accesso Negato: Minorenne."
                return 1
            fi
        else
            echo "Errore: Inserire un numero valido!"
        fi
        break # Usciamo dal loop per la demo
    done
}

chiedi_eta


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (GETOPTS)
# ==============================================================================
# | SIMBOLO | SIGNIFICATO                                                  |
# |---------|--------------------------------------------------------------|
# | x       | Cerca il flag -x (booleano, c'è o non c'è).                  |
# | x:      | Cerca il flag -x seguito da un argomento ($OPTARG).          |
# | :       | (All'inizio stringa) Attiva Silent Mode (gestione errori).   |
# | \?      | (Nel case) Gestisce opzione sconosciuta.                     |
# | :       | (Nel case, solo in Silent Mode) Gestisce argomento mancante. |

echo "----------------------------------------------------------------"
echo "Tutorial Completato."
# ==============================================================================
# GUIDA COMPLETA: GESTIONE ARGOMENTI (getopts) E MENU (select)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. IL COMANDO 'getopts'
# A cosa serve: A leggere i parametri passati allo script (es: ./script.sh -a -b)
# ------------------------------------------------------------------------------
# SINTASSI: getopts "stringa_opzioni" variabile
#
# LA STRINGA DELLE OPZIONI:
# "v"   -> Opzione semplice (on/off). Es: -v
# "f:"  -> I due punti DOPO la lettera dicono che l'opzione RICHIEDE un valore.
#          Es: -f file.txt (il valore "file.txt" finirà nella variabile $OPTARG)
# ":"   -> Se metti i due punti ALL'INIZIO (es: ":vf:"), getopts entra in 
#          "Silent Mode": non stampa errori brutti di sistema, ma ti permette
#          di gestirli nel 'case' con i simboli '?' e ':'.

verbose=0
input_file=""

echo "--- FASE 1: Lettura Opzioni ---"

# Il ciclo 'while' continua finché ci sono opzioni da leggere
while getopts ":vf:" opt; do
  case $opt in
    v)
      # Se l'utente mette -v, cambiamo la variabile
      verbose=1
      echo "[DEBUG] Modalità verbosa attivata"
      ;;
    f)
      # Se l'utente mette -f valore, $OPTARG conterrà quel valore
      input_file=$OPTARG
      echo "[DEBUG] File ricevuto: $input_file"
      ;;
    :)
      # Questo caso scatta se l'utente scrive -f ma non mette il nome del file
      echo "ERRORE: L'opzione -$OPTARG richiede un argomento."
      exit 1
      ;;
    \?)
      # Questo caso scatta se l'utente mette un'opzione non prevista (es: -z)
      echo "ERRORE: Opzione -$OPTARG non riconosciuta."
      echo "Uso: $0 [-v] [-f nome_file]"
      exit 1
      ;;
  esac
done

# --- IL COMANDO 'shift' ---
# Fondamentale! 'getopts' tiene il conto di quante opzioni ha letto in $OPTIND.
# 'shift $((OPTIND - 1))' sposta la lista degli argomenti verso sinistra.
# Se scrivi: ./script.sh -v -f test.txt "Argomento Extra"
# Dopo lo shift, "Argomento Extra" diventa il nuovo $1.
shift $((OPTIND - 1))

echo "Argomenti rimanenti dopo il parsing: $@"


# ------------------------------------------------------------------------------
# 2. IL COMANDO 'select'
# A cosa serve: A creare menu numerati interattivi in modo automatico.
# ------------------------------------------------------------------------------
# PS3: È una variabile speciale di Bash che definisce il testo del prompt 
#      mostrato all'utente per fare la scelta. Se non la metti, apparirà '#?'.
PS3="Scegli un'operazione (1-4): "

echo -e "\n--- FASE 2: Menu Interattivo ---"

# Definiamo una lista di opzioni
opzioni=("Backup" "Ripristino" "Log" "Esci")

# Il ciclo select crea il menu numerato partendo dall'array
select scelta in "${opzioni[@]}"; do
  case $scelta in
    "Backup")
      echo "Hai scelto di fare il Backup."
      # Qui metteresti il codice del backup
      ;;
    "Ripristino")
      echo "Hai scelto il Ripristino."
      ;;
    "Log")
      echo "Ecco i log di sistema..."
      ;;
    "Esci")
      echo "Uscita in corso..."
      break # Il comando 'break' è l'unico modo per interrompere il menu select
      ;;
    *)
      # Se l'utente digita un numero non in elenco
      echo "Scelta non valida! Hai digitato: $REPLY"
      ;;
  esac
done

# NOTE FINALI PER L'ESAME:
# - $OPTARG: contiene il valore dell'opzione corrente (solo per quelle con i :)
# - $OPTIND: indice del prossimo argomento da elaborare.
# - $REPLY: nel comando 'select', contiene il testo o il numero digitato dall'utente.