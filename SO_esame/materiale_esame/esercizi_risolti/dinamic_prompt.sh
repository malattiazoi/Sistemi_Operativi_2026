#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# Fare in modo che il proprio prompt principale indichi il numero
# di processi attivi nel sistema al momento.
# ------------------------------------------------------------------------------

# NOTA IMPORTANTE:
# Uno script non può cambiare il prompt della shell padre (quella dove sei ora).
# Questo script deve essere "sourciato" (source script.sh) oppure stampa
# il comando che l'utente deve copiare.
# Qui mostriamo come impostare la variabile PS1.

echo "Per cambiare il prompt, esegui questo comando nel terminale:"
echo ""
echo "-----------------------------------------------------------"
# PS1 definisce l'aspetto del prompt.
# $(...) esegue il comando ogni volta che premi invio.
# ps -e --no-headers | wc -l: conta i processi.
echo "export PS1='Proc: \$(ps -e --no-headers | wc -l) > '"
echo "-----------------------------------------------------------"

echo ""
echo "Se vuoi provare una simulazione temporanea in questo script:"
# Simulazione (per dimostrare che il codice funziona)
SIMULATED_PS1="Proc: $(ps -e | wc -l) > "
echo "Ecco come apparirebbe: $SIMULATED_PS1"