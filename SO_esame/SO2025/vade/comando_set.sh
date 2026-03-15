
# Comando: set  
# Il comando `set` serve per modificare il comportamento della shell,
# abilitando o disabilitando specifiche opzioni di esecuzione.
# Può anche essere usato per impostare variabili posizionali ($1, $2, ...).

Sintassi:
  set [opzioni]
  set -o nome_opzione
  set +o nome_opzione
  set -- arg1 arg2 ...


Opzioni comuni e loro significato:

  -e    (errexit)   → esci se un comando fallisce (status ≠ 0)
  -u    (nounset)   → errore se usi una variabile non definita
  -x    (xtrace)    → mostra ogni comando prima di eseguirlo
  -v    (verbose)   → stampa le righe man mano che vengono lette
  -C    (noclobber) → impedisce di sovrascrivere file con '>'
  -o pipefail       → fallisce se uno qualsiasi dei comandi in una pipeline fallisce
                     predefinita:	exit code dell’ultimo comando	ignora fallimenti intermedi
                     set -o pipefail:	exit code dell’ultimo comando fallito	fallisce se uno qualsiasi fallisce
------------------------------------------------------------
Esempi di utilizzo:
------------------------------------------------------------

# 1. Abilitare opzioni singole
set -e      # Esci dallo script se un comando fallisce
set -u      # Errore se uso una variabile non definita
set -x      # Mostra i comandi che vengono eseguiti (debug)

# 2. Disabilitare le stesse opzioni
set +e
set +u
set +x

# 3. Attivare la modalità "safe"
# (per gli script)
set -euo pipefail
# Equivale a:
#   set -e
#   set -u
#   set -o pipefail

# 4. Mostrare lo stato delle opzioni
set -o
# Output esemplificativo:
# errexit         on
# nounset         off
# pipefail        on

# 5. Impostare argomenti posizionali
set -- uno due tre
echo "$1"   # stampa "uno"
echo "$2"   # stampa "due"

# 6. Disabilitare più opzioni insieme
set +euo pipefail

# 7. Debug temporaneo
set -x          # abilita debug
# ... blocco di comandi ...
set +x          # disabilita debug

