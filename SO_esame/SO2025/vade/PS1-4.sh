PS1, PS2, PS3 e PS4 sono variabili speciali della shell Bash che controllano l’aspetto dei prompt e il comportamento della modalità di debug. Di seguito una spiegazione con esempi pratici.

PS1 – Prompt principale
È il prompt mostrato quando la shell è pronta a ricevere un comando.
Esempio di PS1 predefinito:
  PS1="[\u@\h \W]\\$ "
Questo mostra: [utente@hostname directory]$
Esempio personalizzato:
  PS1="\u@\h:\w$ "
Mostrerà qualcosa tipo:
  mario@pc:/home/mario$

PS2 – Prompt di continuazione
Compare quando un comando non è completo.
Valore predefinito:
  PS2="> "
Esempio:
  $ echo "ciao
  >
La stringa non chiusa fa comparire il prompt PS2.

PS3 – Prompt del comando select
Usato negli script Bash con il costrutto "select" per menu interattivi.
Esempio:
  PS3="Scegli un'opzione: "
  select scelta in start stop quit; do
      echo "Hai scelto: $scelta"
  done
Il prompt apparirà come:
  1) start
  2) stop
  3) quit
  Scegli un'opzione:

PS4 – Prompt della modalità debug (set -x)
È un prefisso usato per mostrare i comandi mentre vengono eseguiti in modalità debug.
Valore predefinito:
  PS4="+ "
Esempio:
  PS4="> "
  set -x
  echo "Debug in corso"
Output:
  > echo "Debug in corso"
  Debug in corso

Riassunto:
- PS1: prompt principale.
- PS2: prompt di continuazione per comandi multilinea.
- PS3: prompt dei menu interattivi "select".
- PS4: prefisso mostrato durante il debug "set -x".
