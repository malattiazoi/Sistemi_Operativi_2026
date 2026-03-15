#!/bin/bash

# ==============================================================================
# 18. SHELL OPTIONS: SET E SHOPT (DEBUG & SICUREZZA)
# ==============================================================================
# OBIETTIVO:
# Configurare il comportamento della Shell per renderla più sicura,
# attivare il debug e gestire gli errori automaticamente.
#
# COMANDI PRINCIPALI:
# - set: Modifica le opzioni standard POSIX (es. exit on error, debug).
# - shopt: Modifica le opzioni specifiche di Bash (es. gestione wildcard).
#
# CONCETTO CHIAVE:
# Attivare un'opzione:  set -x (Meno = Acceso/Attivo)
# Disattivare opzione:  set +x (Più  = Spento/Disattivato)
# (Sì, è controintuitivo, ma è così dai tempi di Unix anni '70).
# ==============================================================================

echo "--- Inizio Tutorial Shell Options ---"

# ==============================================================================
# 1. DEBUGGING DELLO SCRIPT (-x)
# ==============================================================================
# Scenario: Lo script non funziona e non capisci perché.
# Soluzione: 'set -x' (X-ray / eXecute print).
# Stampa ogni comando PRIMA di eseguirlo, con le variabili già espanso.

echo "----------------------------------------------------------------"
echo "--- 1. DEBUG MODE (-x) ---"

VAR="Mondo"

# ATTIVIAMO IL DEBUG
set -x

# Ora vedrai nel terminale: + echo 'Ciao Mondo'
echo "Ciao $VAR"

# Vedrai: + TEST=15
TEST=$(( 10 + 5 ))

# DISATTIVIAMO IL DEBUG (altrimenti sporca tutto il resto dell'output)
set +x

echo "Debug disattivato. L'output è tornato pulito."


# ==============================================================================
# 2. INTERROMPERE SU ERRORE (-e)
# ==============================================================================
# Scenario: Hai uno script che fa:
# 1. cd cartella_importante
# 2. rm -rf *
# Se il passo 1 fallisce (cartella non esiste), lo script continua e esegue il passo 2
# nella cartella corrente, cancellando TUTTO. Disastro.
#
# Soluzione: 'set -e' (Exit on Error).
# Se un comando ritorna un Exit Code diverso da 0, lo script muore subito.

echo "----------------------------------------------------------------"
echo "--- 2. EXIT ON ERROR (-e) ---"

# Eseguiamo questo test in una subshell (parentesi) per non killare questo tutorial
(
    echo "Sottoshell: Attivo set -e..."
    set -e
    
    echo "Sottoshell: Provo a elencare una cartella che non esiste..."
    ls /cartella_fantasma
    
    # Questa riga NON verrà mai eseguita se set -e funziona
    echo "Sottoshell: ATTENZIONE! Se leggi questo, set -e NON ha funzionato!"
)

# Controlliamo come è andata
if [ $? -ne 0 ]; then
    echo "Main: La sottoshell è terminata con errore (Come previsto da set -e)."
else
    echo "Main: La sottoshell non ha rilevato errori."
fi


# ==============================================================================
# 3. VARIABILI NON SETTATE (-u)
# ==============================================================================
# Scenario: Scrivi 'rm -rf /$DIR_TEMP'.
# Ma hai dimenticato di definire DIR_TEMP.
# Bash espande in 'rm -rf /'. Il computer è formattato.
#
# Soluzione: 'set -u' (Unset variables).
# Tratta le variabili non definite come errori critici.

echo "----------------------------------------------------------------"
echo "--- 3. UNBOUND VARIABLES (-u) ---"

(
    set -u
    echo "Provo a stampare una variabile non definita:"
    # Tenta di leggere $VARIABILE_INESISTENTE
    echo "Valore: $VARIABILE_INESISTENTE"
    
    echo "Questo messaggio non deve apparire."
) || echo "Main: Errore rilevato! Variabile non settata (set -u funziona)."


# ==============================================================================
# 4. GESTIONE PIPE (-o pipefail) - CRITICO
# ==============================================================================
# Problema: In una pipe (cmd1 | cmd2), Bash guarda solo l'exit code dell'ULTIMO comando.
# Esempio: 'comando_fallito | echo "fatto"' -> Exit Code 0 (Successo), perché echo ha funzionato.
# Questo inganna 'set -e'.
#
# Soluzione: 'set -o pipefail'.
# Se UN QUALSIASI comando nella pipe fallisce, tutto lo script fallisce.

echo "----------------------------------------------------------------"
echo "--- 4. PIPEFAIL (-o pipefail) ---"

(
    set -e
    set -o pipefail
    
    echo "Eseguo pipe rotto: ls /no_exist | wc -l"
    # ls fallisce, ma wc funzionerebbe. Con pipefail, l'intero blocco fallisce.
    ls /no_exist 2>/dev/null | wc -l
    
    echo "NON DOVRESTI LEGGERE QUESTO."
) || echo "Main: Pipefail ha intercettato l'errore nel mezzo della pipe."


# ==============================================================================
# 5. PROTEZIONE SOVRASCRITTURA (-C) - NOCLOBBER
# ==============================================================================
# Scenario: 'echo dati > importante.conf'.
# Se il file esisteva, lo hai appena piallato.
#
# Soluzione: 'set -C' (No Clobber). Impedisce la sovrascrittura con >.

echo "----------------------------------------------------------------"
echo "--- 5. NO CLOBBER (-C) ---"

touch file_prezioso.txt
(
    set -C
    echo "Provo a sovrascrivere..."
    echo "Nuovi Dati" > file_prezioso.txt
) 2>/dev/null || echo "Main: Sovrascrittura bloccata da set -C."

# Come forzare la sovrascrittura se ho set -C attivo?
# Si usa l'operatore >|
# echo "Dati forzati" >| file_prezioso.txt


# ==============================================================================
# 6. SIMULARE ARGOMENTI POSIZIONALI (set --)
# ==============================================================================
# Scenario: Vuoi testare uno script che usa $1, $2, $3 senza doverlo
# lanciare da riga di comando ogni volta.
# Oppure vuoi resettare gli argomenti dentro lo script.

echo "----------------------------------------------------------------"
echo "--- 6. SET POSITIONAL PARAMETERS (set --) ---"

echo "Argomenti originali dello script: $1 $2"

# Simuliamo che l'utente abbia passato "Mario" e "Rossi"
set -- "Mario" "Rossi"

echo "Nuovo \$1: $1"
echo "Nuovo \$2: $2"
echo "Tutti (\$@): $@"

# Simuliamo un array di file
set -- *.sh
echo "Il primo file .sh trovato è: $1"


# ==============================================================================
# 7. SHOPT: GESTIONE WILDCARD (NULLGLOB)
# ==============================================================================
# Problema: Se fai 'for f in *.mp3' e NON ci sono mp3,
# Bash imposta la variabile f alla stringa letterale "*.mp3".
# Il comando successivo fallisce: "File *.mp3 not found".
#
# Soluzione: 'shopt -s nullglob'.
# Se non trova match, la lista è vuota e il loop non parte.

echo "----------------------------------------------------------------"
echo "--- 7. SHOPT (NULLGLOB) ---"

# Senza nullglob (Comportamento default pericoloso)
echo "Test Standard (Senza file .xyz):"
for f in *.xyz; do
    echo "Ho trovato: '$f'"
    if [ "$f" == "*.xyz" ]; then
        echo "  -> VEDI? È solo una stringa, non un file!"
    fi
done

# Con nullglob (Comportamento sicuro)
echo "Test con shopt -s nullglob:"
shopt -s nullglob
for f in *.xyz; do
    echo "Questo non verrà stampato perché la lista è vuota."
done
shopt -u nullglob # Disattivo (unset) per tornare normale


# ==============================================================================
# 8. SHOPT: FILE NASCOSTI (DOTGLOB)
# ==============================================================================
# Problema: 'rm *' non cancella i file nascosti (.git, .env).
# Soluzione: 'shopt -s dotglob'.
# Include i file che iniziano con punto nelle espansioni *.

echo "----------------------------------------------------------------"
echo "--- 8. SHOPT (DOTGLOB) ---"

mkdir -p test_nascosti
touch test_nascosti/.segreto
touch test_nascosti/visibile.txt

echo "Espansione normale * :"
echo test_nascosti/*

echo "Espansione con dotglob:"
shopt -s dotglob
echo test_nascosti/*
shopt -u dotglob


# ==============================================================================
# 🧩 IL "STRICT MODE" (STANDARD INDUSTRIALE)
# ==============================================================================
# Se all'esame ti chiedono di scrivere uno script "robusto",
# metti questa riga subito dopo #!/bin/bash.

# set -euo pipefail
#
# -e : Esci se un comando fallisce.
# -u : Esci se usi variabili non definite.
# -o pipefail : Esci se una pipe fallisce a metà.
#
# IFS=$'\n\t' : (Opzionale avanzato) Gestisce meglio gli spazi nei nomi file.


# ==============================================================================
# ⚠️ TABELLA RIEPILOGATIVA SET / SHOPT
# ==============================================================================
# | COMANDO          | EFFETTO                                            |
# |------------------|----------------------------------------------------|
# | set -x           | Debug mode (stampa comandi eseguiti).              |
# | set -e           | Exit on Error (esce se exit code != 0).            |
# | set -u           | Unbound vars (errore su variabili vuote).          |
# | set -o pipefail  | Rileva errori anche dentro le pipe \|.             |
# | set -C           | No Clobber (impedisce sovrascrittura file >).      |
# | set -- a b       | Imposta manualmente $1=a, $2=b.                    |
# | shopt -s nullglob| I pattern non trovati spariscono (non restano stringhe).|
# | shopt -s dotglob | I pattern * includono anche i file nascosti (.).   |

# Pulizia
rm -f file_prezioso.txt
rm -rf test_nascosti
echo "----------------------------------------------------------------"
echo "Tutorial Set/Shopt Completato."

# ==============================================================================
# GUIDA COMPLETA AL COMANDO 'set' - CONFIGURAZIONE E DEBUG
# ==============================================================================
# FONTE: Appunti lezioni + Integrazioni Exam Kit
# DESCRIZIONE: 
# Il comando `set` modifica il comportamento della shell, abilitando/disabilitando
# opzioni di esecuzione e gestendo i parametri posizionali ($1, $2...).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SINTASSI E LOGICA DI BASE
# ------------------------------------------------------------------------------
# set [opzioni]        -> Attiva opzioni (flag corti, es: set -e)
# set -o nome_opzione  -> Attiva opzioni (nomi lunghi, es: set -o errexit)
# set +o nome_opzione  -> DISATTIVA opzioni (Attenzione: il '+' disattiva!)
# set -- arg1 arg2     -> Imposta i parametri posizionali

# ------------------------------------------------------------------------------
# 2. OPZIONI FONDAMENTALI (Dal file originale)
# ------------------------------------------------------------------------------

# -e  (errexit)
# --------------------------------------------------------
# Esci immediatamente se un comando fallisce (exit status non zero).
# Esempio:
# set -e
# cd cartella_inesistente  # Qui lo script muore subito
# rm -rf * # Questo non verrà mai eseguito (Salvezza!)

# -u  (nounset)
# --------------------------------------------------------
# Tratta le variabili non impostate come errori.
# Esempio:
# set -u
# echo $variabile_non_esistente  # Genera errore e ferma lo script
# (Senza questo, bash stamperebbe una riga vuota e continuerebbe, nascondendo il bug)

# -x  (xtrace)
# --------------------------------------------------------
# Debugging: stampa ogni comando nel terminale PRIMA di eseguirlo.
# Le righe stampate sono precedute da un '+' (o quello che c'è in PS4).
# set -x

# -v  (verbose)
# --------------------------------------------------------
# Stampa le righe di input della shell man mano che vengono lette.
# A differenza di -x, stampa il codice sorgente grezzo, non l'espansione.

# -C  (noclobber)
# --------------------------------------------------------
# Impedisce la sovrascrittura di file esistenti con l'operatore di reindirizzamento '>'.
# set -C
# echo "test" > file_importante.txt   # ERRORE: file esiste
# echo "test" >| file_importante.txt  # OK: '>|' forza la sovrascrittura

# -f  (noglob)
# --------------------------------------------------------
# Disabilita il "Pathname Expansion" (globbing).
# I caratteri jolly come *, ?, [ ] non vengono espansi.
# set -f
# echo * # Stampa letteralmente un asterisco, non la lista dei file.

# ------------------------------------------------------------------------------
# 3. IL CASO SPECIALE: PIPEFAIL (-o pipefail)
# ------------------------------------------------------------------------------
# Questo è critico per gli esami che usano le pipeline ( cmd1 | cmd2 | cmd3 ).

# COMPORTAMENTO PREDEFINITO (Senza pipefail):
# Bash guarda solo l'exit code dell'ULTIMO comando della pipe.
# Esempio: ls cartella_inesistente | grep "txt"
# 'ls' fallisce, ma 'grep' finisce bene (non trova nulla, exit 0).
# Risultato totale: 0 (Successo). --> PERICOLOSO IN ESAME!

# COMPORTAMENTO CON PIPEFAIL (set -o pipefail):
# Il codice di uscita della pipeline è quello dell'ultimo comando che ha fallito.
# Se fallisce anche solo un pezzo della catena, tutto lo script lo sa.

# TABELLA DI CONFRONTO (Dal tuo file):
# | Configurazione      | Exit Code Restituito             | Comportamento                |
# |---------------------|----------------------------------|------------------------------|
# | Default             | Exit code dell'ULTIMO comando    | Ignora fallimenti intermedi  |
# | set -o pipefail     | Exit code dell'ULTIMO FALLITO    | Fallisce se CHIUNQUE fallisce|

# ------------------------------------------------------------------------------
# 4. BEST PRACTICE ESAME: LA "MODALITÀ SAFE"
# ------------------------------------------------------------------------------
# Copia e incolla questo blocco all'inizio di ogni tuo script d'esame.

set -euo pipefail

# Spiegazione combinata:
# -e : Blocca su errore
# -u : Blocca su variabili vuote
# -o pipefail : Blocca su errori nelle pipe

# ------------------------------------------------------------------------------
# 5. GESTIONE PARAMETRI POSIZIONALI (set --)
# ------------------------------------------------------------------------------
# Il comando set può sovrascrivere $1, $2, $3... dello script corrente.
# Utile per testare script che richiedono argomenti senza riavviarli.

# Esempio:
set -- "mela" "pera" "banana"

echo "Primo argomento (\$1): $1"   # Stampa: mela
echo "Secondo argomento (\$2): $2" # Stampa: pera
echo "Tutti gli argomenti (\$@): $@" # Stampa: mela pera banana

# Per svuotare tutti gli argomenti:
# set --


# ==============================================================================
# 📊 TABELLA RIEPILOGATIVA OPZIONI (FLAG)
# ==============================================================================
# | FLAG CORTA | FLAG LUNGA (-o) | EFFETTO                                      |
# |------------|-----------------|----------------------------------------------|
# | -e         | errexit         | Stop script se un comando fallisce (err != 0)|
# | -u         | nounset         | Stop script se usi variabili non definite    |
# | -x         | xtrace          | Stampa traccia comandi (Debug mode)          |
# | -v         | verbose         | Stampa input letto (Lettura mode)            |
# | -C         | noclobber       | Protegge i file dalla sovrascrittura (>)     |
# | -f         | noglob          | Disabilita espansione * e ?                  |
# | (nessuna)  | pipefail        | Rileva errori all'interno delle pipe (|)     |
# | (nessuna)  | history         | Abilita la command history                   |
# | (nessuna)  | ignoreeof       | Impedisce di chiudere la shell con CTRL+D    |

# ==============================================================================
# 💡 APPROFONDIMENTI E TRUCCHI PER L'ESAME
# ==============================================================================

# --- 1. COME ATTIVARE E DISATTIVARE ---
# Ricorda la logica inversa che confonde spesso:
# set -x  (MENO attiva l'opzione)
# set +x  (PIÙ disattiva l'opzione)

# --- 2. VEDERE LO STATO ATTUALE ---
# Se vuoi sapere quali opzioni sono attive nel tuo terminale ora:
# set -o
# Ti mostrerà una lista tipo:
# errexit         on
# nounset         off
# pipefail        on ...

# --- 3. QUANDO NON USARE 'set -e' ---
# Se nel tuo script VUOI gestire un errore manualmente (es. con un if),
# 'set -e' ti chiuderebbe lo script prima che tu possa gestirlo.
# Soluzione temporanea:
# set +e             # Disattiva controllo errori
# comando_rischioso
# set -e             # Riattiva controllo errori

# Oppure usa l'operatore OR:
# comando_rischioso || echo "Il comando ha fallito ma continuo..."