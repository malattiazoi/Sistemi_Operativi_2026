Il comando "tac" in Bash è simile al comando "cat", ma mostra le righe
di un file in ordine inverso (dall'ultima alla prima).

Sintassi:
    tac [FILE]

Esempio semplice:
    tac file.txt
Mostra il contenuto di file.txt partendo dall'ultima riga.

Leggere input da pipeline invertendo l'ordine delle righe:
    comando | tac

Usi comuni:
- Invertire l'output del comando "cat":
      cat file.txt | tac
- Visualizzare un log dall'evento più recente al più vecchio
- Invertire il contenuto di un file per analisi rapide

Opzioni utili:
    -s  Specifica manualmente un separatore diverso dal newline

Esempio con separatore personalizzato:
    tac -s ";" file.csv
(Inverte il file considerando il ; come separatore di record)

In breve:
"tac" è semplicemente "cat" al contrario.
