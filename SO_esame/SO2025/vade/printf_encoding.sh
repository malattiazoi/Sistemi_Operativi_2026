============================================================
USARE printf IN BASH PER LAVORARE CON UNICODE, CODE POINT E BYTE UTF-8
============================================================

1) Stampare caratteri tramite code point
----------------------------------------
Bash usa le sequenze di escape stile C:

  \uXXXX       -> code point Unicode a 4 cifre esadecimali
  \UXXXXXXXX   -> code point Unicode a 8 cifre esadecimali

Esempi:
  printf "\u00E9\n"        # é
  printf "\U0001F600\n"    # 😀


2) Regole fondamentali per \u e \U
----------------------------------
- \u vuole esattamente 4 cifre esadecimali
- \U vuole esattamente 8 cifre esadecimali
- le stringhe devono essere tra virgolette doppie
- funziona solo in printf, non in echo (a meno di opzioni speciali)
- le lettere A-F possono essere maiuscole o minuscole


3) Passare code point tramite variabili
---------------------------------------
Non puoi scrivere direttamente "\u$var".

Soluzione corretta:
  hex=00E9
  printf "\\u%04X\n" "0x$hex"


4) Ottenere il code point di un carattere
-----------------------------------------
Sintassi speciale di bash:  '<carattere>

Esempi:
  printf "%d\n" "'A"        -> 65
  printf "U+%04X\n" "'é"    -> U+00E9

Spiegazione:
- "'é" è interpretato da bash come "valore numerico del carattere é"
- quindi printf riceve un numero e lo formatta in esadecimale

Funziona per tutti i caratteri U+0000–U+00FF.
Per caratteri fuori BMP (emoji), bash non usa questa sintassi.


5) Stampare o mostrare sequenze di byte UTF-8 con echo / printf
---------------------------------------------------------------

A) MOSTRARE I BYTE DI UN CARATTERE UTF-8
Per vedere i byte effettivi in esadecimale:

  printf "%s" "é" | hexdump -C

Output tipico:
  c3 a9    -> UTF-8 per U+00E9

B) GENERARE BYTE UTF-8 CON echo -e
Attenzione: funziona solo per valori *in byte*, non per code point.

Esempio: byte UTF-8 "C3 A9" (é)

  echo -e "\xC3\xA9"

C) Generare gli stessi byte con printf:

  printf "\xC3\xA9\n"


6) Esempi didattici
-------------------
Stampare lettere e segni diacritici:
  printf "\u0061\u0301\n"      # á (a + accento)

Stampare emoji:
  printf "\U0001F984\n"        # 🦄

Convertire carattere -> code point:
  printf "U+%04X\n" "'À"       # U+00C0
  printf "U+%04X\n" "'ß"       # U+00DF

Visualizzare byte UTF-8:
  printf "€" | hexdump -C      # E2 82 AC
  echo -e "\xE2\x82\xAC"       # stampa il simbolo €

============================================================
