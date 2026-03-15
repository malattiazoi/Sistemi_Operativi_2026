#!/bin/bash
# =========================================================
# File: pgrep_demo.sh
# Scopo: guida dimostrativa a pgrep con esempi e commenti
# =========================================================
# Nota: questo script *non* esegue pgrep su processi di sistema
#       per evitare effetti collaterali — mostra comandi ed esempi.
# =========================================================

print_header() {
  echo
  echo "========================================================="
  echo " $1"
  echo "========================================================="
}

# Introduzione
print_header "INTRO - Che cos'è pgrep?"
cat <<'INTRO'
pgrep è uno strumento che cerca processi in base a un pattern (espressione regolare)
e restituisce i PID (process IDs) corrispondenti. È molto comodo per trovare
processi per nome, per utente, o basandosi su parti della command line.

Comando base:
  pgrep PATTERN

Esempio rapido (reale):
  pgrep sshd        # restituisce i PID dei processi il cui nome corrisponde a 'sshd'
INTRO

# Sezione: -f (match sulla command line completa)
print_header "-f: match sulla command line completa (non solo sul nome)"
cat <<'EXPL_F'
Opzione: -f
Significato: fa il matching del PATTERN sull'intera command line del processo
(inclusi argomenti), non solo sul "nome del processo" (argv[0]).

Perché utile:
  - se il comando è lanciato con argomenti distintivi
  - se ci sono più istanze dello stesso eseguibile con argomenti diversi

Esempi reali:
  pgrep -f "python my_script.py"
  pgrep -f "/usr/bin/java.*-jar myapp.jar"

Esempio fittizio di output:
  # pgrep -f "python my_script.py"
  2345
  6789
EXPL_F

# Sezione: -l e -a
print_header "-l e -a: visualizzare nomi e command line"
cat <<'EXPL_LA'
Opzione: -l  -> mostra "pid (nome)"
Opzione: -a  -> mostra "pid (command line completa)"

Esempi:
  pgrep -l sshd
  pgrep -a python

Esempio fittizio:
  # pgrep -l sshd
  1012 sshd
  2048 sshd

  # pgrep -a python
  2345 python /home/alice/my_script.py --mode test
EXPL_LA

# Sezione: -x (match esatto)
print_header "-x: match esatto"
cat <<'EXPL_X'
Opzione: -x
Significato: richiede che l'intero campo (nome o -f: intera command line) corrisponda esattamente
(rimuove il comportamento "regex parziale").

Esempi:
  pgrep -x sshd      # match solo se il nome è esattamente "sshd"
  pgrep -fx "python my_script.py"

Nota: senza -x, pgrep usa regex che può fare match parziali.
EXPL_X

# Sezione: -u (per utente), -U (UID) e -G (group)
print_header "-u, -U, -G: filtrare per utente/UID/gruppo"
cat <<'EXPL_U'
Opzioni:
  -u user   -> match dei processi appartenenti a 'user' (nome utente)
  -U uid    -> match per user id numerico (UID)
  -G group  -> match per group id (nome o GID)

Esempi:
  pgrep -u alice sshd
  pgrep -U 1000 python
  pgrep -G wheel

Utilizzo pratico: trovare i processi di un utente specifico per monitoraggio o terminazione selettiva.
EXPL_U

# Sezione: -n (ultimo), -o (più vecchio), -c (conteggio)
print_header "-n, -o, -c: selezione per età e conteggio"
cat <<'EXPL_NOC'
Opzioni:
  -n  -> mostra solo il PID del processo più recente (newest)
  -o  -> mostra solo il PID del processo più vecchio (oldest)
  -c  -> mostra solo il conteggio dei processi che matchano

Esempi:
  pgrep -n -u alice python   # PID della più recente istanza python di alice
  pgrep -o sshd              # PID dell'istanza sshd più vecchia
  pgrep -c chrome            # quanti processi chrome sono in esecuzione

Esempio fittizio:
  # pgrep -c sshd
  2
EXPL_NOC

# Sezione: -P (parent), -d (delimiter)
print_header "-P e -d: parent e delimitatore"
cat <<'EXPL_PD'
Opzioni:
  -P ppid        -> cerca processi figli del PID ppid (parent PID)
  -d DELIM       -> separatore di output quando pgrep restituisce più PID (default newline)

Esempi:
  pgrep -P 1       # processi figli di PID 1 (init/systemd)
  pgrep -d ',' sshd  # stampa i pid separati da virgola: "1012,2048"

Uso pratico: costruire liste di PID per passare ad altri comandi in modo pulito.
EXPL_PD

# Sezione: combinazioni e uso con pkill / kill
print_header "Combinazioni utili e avvertenze (pkill / kill)"
cat <<'EXPL_COMBO'
Esempi combinati:
  # trovare e vedere full command lines per tutte le python
  pgrep -af python

  # contare tutte le istanze di nginx eseguite da root
  pgrep -c -u root nginx

  # PID più recente di java con command line completa
  pgrep -fan -x "java -jar myapp.jar"

Attenzione:
  - pgrep restituisce PID: se lo usi con pkill fai attenzione alle regex
  - pkill usa le stesse opzioni per cercare ed uccidere: pkill -f PATTERN
  - NON usare pkill/kill con pattern non verificati (rischio di terminare processi critici)

Esempio per terminare (attenzione!):
  # Prima verifica:
  pgrep -af "myapp"
  # Se l'elenco è corretto, puoi terminare:
  pgrep -f "myapp" | xargs -r kill
  # Oppure (più diretto ma più rischioso):
  pkill -f "myapp"
EXPL_COMBO

# Sezione: differenza tra pgrep e ps+grep
print_header "pgrep vs ps | grep"
cat <<'EXPL_PS'
Molti utenti fanno: ps aux | grep pattern
Vantaggi di pgrep:
  - più compatto e preciso (resti direttamente con i PID)
  - ha opzioni per utente, parent, conteggio, output formattato (-a, -l)
  - meno rischio di dover filtrare il processo 'grep' stesso

Se proprio vuoi vedere command line complete con ps:
  ps aux | grep '[p]attern'   # trucco per evitare di trovare il grep
Ma pgrep -af pattern è più semplice e leggibile.
EXPL_PS

# Sezione: suggerimenti di sicurezza
print_header "Suggerimenti di sicurezza e best practices"
cat <<'TIPS'
- Controlla sempre l'output prima di usare pkill/kill.
- Preferisci pgrep -u USER per evitare di selezionare processi di altri utenti.
- Quando possibile, usa -x per evitare match parziali non voluti.
- Usa -d per avere un output delimitato quando lo passi ad altri comandi.
- In script di produzione, valida le variabili usate per costruire pattern (evita injection di regex indesiderate).
TIPS

# Sezione: esempi rapidi da copiare/incollare
print_header "Esempi rapidi - comandi da eseguire nella shell"
cat <<'EXAMPLES'

# Elenca PID di sshd
pgrep sshd

# Elenca PID + command line di tutti i python
pgrep -af python

# Conta le istanze di nginx
pgrep -c nginx

# PID più recente di 'mysqld'
pgrep -n mysqld

# Trova processi esatti chiamati 'bash' (no match parziale)
pgrep -x bash

# Trova processi appartenenti all'utente 'alice'
pgrep -u alice

# Trova figli di PID 1234
pgrep -P 1234

# Output separato da virgola
pgrep -d ',' sshd

# Vedere pid e nome e poi kill (attenzione!)
pgrep -l myapp
pgrep -f myapp | xargs -r kill
EXAMPLES

# Conclusione
print_header "FINE - nota sull'uso negli script"
cat <<'END_NOTE'
Se usi pgrep in script automatizzati:
 - controlla il codice di uscita ($?) per sapere se ci sono match
 - gestisci il caso "0 risultati" in modo sicuro (evita passare stringhe vuote a kill)
 - preferisci array (es. mapfile -t pids < <(pgrep ...)) per manipolare PID in modo sicuro

Esempio sicuro per salvare PID in array:
  mapfile -t PIDS < <(pgrep -f myapp)
  if [ ${#PIDS[@]} -gt 0 ]; then
      printf 'Trovati PID: %s\n' "${PIDS[*]}"
  else
      echo "Nessun processo trovato"
  fi

Grazie! Se vuoi, posso:
 - generare un file README più formale con tutte le opzioni di pgrep,
 - creare esempi live (ATTENZIONE: richiedono esecuzione sulla tua macchina),
 - o fare un confronto tabellare completo tra pgrep, pkill e pidof.
END_NOTE

# fine script
exit 0
