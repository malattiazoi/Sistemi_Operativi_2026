#!/bin/bash

# ==============================================================================
# 22. GUIDA COMPLETA AL COMANDO 'trap' (GESTIONE SEGNALI E CLEANUP)
# ==============================================================================
# FONTE: Appunti lezioni + Integrazioni Exam Kit (Specifiche MacOS)
# DESCRIZIONE:
# Il comando `trap` intercetta i segnali inviati al processo (come Ctrl-C)
# o eventi della shell (come l'uscita EXIT o un errore ERR).
#
# USI CRITICI PER L'ESAME:
# 1. Cleanup: Cancellare file temporanei alla fine dello script (OBBLIGATORIO!)
# 2. Sicurezza: Impedire che l'utente chiida lo script a metà (Ctrl-C)
# 3. Debug: Capire dove si rompe lo script.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SINTASSI BASE
# ------------------------------------------------------------------------------
# trap 'comandi_da_eseguire' SEGNALE1 SEGNALE2

# Esempio Base: Stampa un messaggio se premi Ctrl-C (SIGINT)
trap 'echo " Hai premuto Ctrl-C! Non esco!"' SIGINT


# ------------------------------------------------------------------------------
# 2. CLEANUP AUTOMATICO (LO SCENARIO PIÙ IMPORTANTE)
# ------------------------------------------------------------------------------
# Se crei file temporanei, DEVI rimuoverli anche se lo script crasha o viene interrotto.
# Usa il segnale pseudo 'EXIT' (0), che viene eseguito SEMPRE alla chiusura.

# Creazione file temporaneo sicuro (funziona su MacOS e Linux)
tmp_file=$(mktemp /tmp/esame_mlazoi.XXXXXX)

# Funzione di pulizia
cleanup() {
    echo "--- Eseguo pulizia finale ---"
    echo "Rimuovo file temporaneo: $tmp_file"
    rm -f "$tmp_file"
}

# Imposta la trappola su EXIT (copre fine normale, exit code, errori e interrupt)
trap cleanup EXIT


# ------------------------------------------------------------------------------
# 3. IGNORARE I SEGNALI (RENDERE LO SCRIPT "IMMORTALE")
# ------------------------------------------------------------------------------
# Se passi una stringa vuota '' come comando, il segnale viene ignorato.

# Ignora Ctrl-C (SIGINT)
trap '' INT
trap '' SIGINT

# Ora se provi a premere Ctrl-C, non succede nulla.

# ------------------------------------------------------------------------------
# 4. RIPRISTINARE IL COMPORTAMENTO DI DEFAULT
# ------------------------------------------------------------------------------
# Se vuoi che Ctrl-C torni a funzionare normalmente, usa il trattino '-'.

trap - INT
trap - SIGINT


# ------------------------------------------------------------------------------
# 5. DEBUGGING E LOGGING DI ERRORI (FLAG -E)
# ------------------------------------------------------------------------------
# Per intercettare gli errori (ERR) anche dentro le funzioni, serve 'set -E'.
# Senza 'set -E', la trap ERR non viene ereditata dalle subshell/funzioni.

set -E

# Trap su ERRORE: Ti dice esattamente dove si è rotto lo script
trap 'echo "Errore critico alla riga $LINENO. Comando fallito: $BASH_COMMAND"; exit 1' ERR

# Esempio di comando che fallirà (se la directory non esiste) e attiverà la trap:
# ls directory_inesistente_123


# ------------------------------------------------------------------------------
# 6. DEBUGGING ESTREMO (TRAP DEBUG)
# ------------------------------------------------------------------------------
# Esegue un comando PRIMA di OGNI riga di codice. Molto verboso ("petulante").

trap "echo [DEBUG] Sto per eseguire un comando..." DEBUG

ls -l
uname
echo "Fine debug"

# Rimuovo la trap di debug per non impazzire nel resto dello script
trap - DEBUG


# ------------------------------------------------------------------------------
# 7. VISUALIZZAZIONE TRAPPOLE
# ------------------------------------------------------------------------------

# Mostra la lista di tutti i segnali disponibili nel sistema (utile su Mac)
trap -l

# Mostra le trappole attualmente attive e impostate
trap -p


# ------------------------------------------------------------------------------
# 8. SCENARIO AVANZATO: CHIEDERE CONFERMA PRIMA DI USCIRE
# ------------------------------------------------------------------------------
# Invece di uscire subito con Ctrl-C, chiediamo all'utente se è sicuro.

conferma_uscita() {
  echo -e "\nVuoi davvero uscire? (y/n): "
  read risposta
  # Se risponde 'y', usciamo manualmente (exit 0 farà scattare anche la trap EXIT!)
  [[ $risposta == "y" ]] && exit 0
}

# Associo la funzione al segnale SIGINT (Ctrl-C)
trap conferma_uscita SIGINT

echo "--- INIZIO LOOP INFINITO (Premi Ctrl-C per testare la conferma) ---"
# Nota: Ho messo un limite al loop per non bloccarti il terminale se esegui tutto il file
for i in {1..5}; do
  echo "Facendo cose importanti... ($i/5)"
  sleep 1
done


# ==============================================================================
# ⚠️ REFERENCE: TIPI DI SEGNALI (DA SAPERE PER L'ESAME)
# ==============================================================================
# I numeri dei segnali possono variare leggermente tra System V e BSD (Mac),
# ma questi sono standard:

# SIGINT (2)
# ----------------------------------------
# Scatenato da: Ctrl + C
# Descrizione: Interrompe un processo in foreground.
# Gestione: ✅ Può essere bloccato, ignorato o gestito (come fatto sopra).

# SIGTERM (15)
# ----------------------------------------
# Scatenato da: comando 'kill PID' (default)
# Descrizione: Richiesta "gentile" di terminazione. Permette al processo di pulire.
# Gestione: ✅ Può essere gestito.

# SIGKILL (9)
# ----------------------------------------
# Scatenato da: comando 'kill -9 PID'
# Descrizione: Termina FORZATAMENTE e IMMEDIATAMENTE il processo.
# Gestione: ❌ NON può essere bloccato, ignorato o gestito. La trap non funziona qui.

# SIGSTOP (17, 19 o 23 su Mac)
# ----------------------------------------
# Scatenato da: Ctrl + Z (spesso manda SIGTSTP, simile) o 'kill -STOP PID'
# Descrizione: "Congela" il processo (pausa).
# Gestione: ❌ Non può essere gestito.

# SIGHUP (1)
# ----------------------------------------
# Scatenato da: Chiusura del terminale.
# Descrizione: Dice al processo che l'utente se n'è andato.
# Gestione: ✅ Spesso usato dai demoni per rileggere i file di configurazione.

# EXIT (0)
# ----------------------------------------
# Pseudo-segnale della shell.
# Descrizione: Viene eseguito ogni volta che la shell esce, per qualsiasi motivo
# (successo o errore), tranne SIGKILL. Fondamentale per il cleanup.


# ==============================================================================
# 📊 TABELLA OPZIONI (FLAG) PER 'trap'
# ==============================================================================
# | FLAG | DESCRIZIONE                                                     |
# |------|-----------------------------------------------------------------|
# | -l   | (List) Elenca tutti i nomi dei segnali e i loro numeri.         |
# | -p   | (Print) Stampa le definizioni delle trap attive in formato riutilizzabile.|
# | -    | (Dash) Resetta il segnale al comportamento di default.          |
# | ''   | (Quote vuote) Ignora completamente il segnale specificato.      |

# ==============================================================================
# 💡 SUGGERIMENTI E TRUCCHI PER MACOS/LINUX
# ==============================================================================

# --- TRUCCO 1: TRAPPARE PIÙ SEGNALI INSIEME ---
# Per essere sicuro di pulire tutto, intercetta INT, TERM e EXIT insieme.
# trap cleanup EXIT INT TERM

# --- TRUCCO 2: SET -E (CRITICO!) ---
# Molti studenti sbagliano l'esame perché mettono una trap su ERR, ma poi
# l'errore avviene dentro una function() e la trap non scatta.
# SCRIVI SEMPRE 'set -E' all'inizio se usi trap ERR.

# --- TRUCCO 3: SEGNALI "KILLER" ---
# Se il tuo script si è bloccato e Ctrl-C non funziona (perché lo hai trappato),
# apri un altro terminale e usa:
# kill -9 <PID_DELLO_SCRIPT>
# Questo bypassa qualsiasi trap.