========================================
Comando: trap  (Bash / Shell POSIX)
========================================

Descrizione:
-------------
Il comando `trap` consente di intercettare segnali o eventi della shell
(es. Ctrl-C, EXIT, ERR) ed eseguire comandi o funzioni quando questi accadono.
È molto utile per:
  - pulire file temporanei (cleanup)
  - gestire interruzioni
  - assicurarsi che certe azioni vengano sempre eseguite alla fine dello script

Sintassi:
----------
  trap 'comandi' SIGNAL1 SIGNAL2 ...
  trap '' SIGNAL         → ignora un segnale
  trap - SIGNAL          → ripristina comportamento predefinito
  trap -p                → mostra trap impostate

------------------------------------------------------------
Segnali e eventi comuni:
------------------------------------------------------------
  SIGINT   → interruzione (Ctrl-C)
  SIGTERM  → terminazione (kill)
  SIGHUP   → hangup (chiusura terminale)
  EXIT  → evento speciale: eseguito quando lo script termina
  ERR   → evento speciale: eseguito quando un comando fallisce
  DEBUG → eseguito prima di ogni comando

Nota: SIGKILL e SIGSTOP non possono essere intercettati.

------------------------------------------------------------
Esempi di utilizzo:
------------------------------------------------------------

# 1. Eseguire comandi su Ctrl-C
trap 'echo "Interrotto!"; exit 1' INT

# 2. Ignorare Ctrl-C
trap '' INT
trap '' SIGINT

# 3. Ripristinare il comportamento di default di Ctrl-C
trap - INT
trap - SIGINT

# 4. Cleanup di file temporanei
tmp=$(mktemp /tmp/mioscript.XXXXXX)
cleanup() {
  echo "Rimuovo file temporaneo: $tmp"
  rm -f "$tmp"
}
trap cleanup EXIT

# visualizza lista segnali
trap -l 

# visualizza trappole attive
trap -p


# logging di errori
set -E
trap 'echo "Errore in linea $LINENO, comando: $BASH_COMMAND"; exit 1' ERR
ls dir_inesistente

# logging debug
trap "echo petulante" DEBUG
ls
uname
echo ciao
###

## trap SIGINT per conferma

conferma_uscita() {
  echo -n "Quittare? (y/n): "
  read risposta
  [[ $answer == "y" ]] && exit 0
}

trap conferma_uscita SIGINT

while true; do
  echo "Facendo cose..."
  sleep 2
done

##

###
- SIGKILL (9): Termina forzatamente un processo immediatamente. ❌ Non può essere bloccato o gestito.  
- SIGTERM (15): Richiede a un processo di terminare in modo ordinato. ✅ Può essere gestito.  
- SIGHUP (1): Informa un processo che il terminale che lo controllava è stato chiuso. ✅ Può essere gestito.  
- SIGINT (2): Interrompe un processo (scatenato da Ctrl + C nel terminale). ✅ Può essere gestito.  
- SIGSTOP (19): Sospende un processo, impedendone l’esecuzione fino alla ripresa. ❌ Non può essere bloccato o gestito.  
- SIGCONT (18): Riprende un processo sospeso. ✅ Può essere gestito.