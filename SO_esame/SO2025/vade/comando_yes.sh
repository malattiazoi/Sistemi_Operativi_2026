Il comando "yes" in Bash serve a ripetere continuamente una stringa
finché non viene interrotto.

Sintassi:
    yes [STRINGA]

Se non viene indicata alcuna stringa, ripete automaticamente "y":
    yes
Output infinito:
    y
    y
    y
    ...

Può essere usato per automatizzare conferme nei comandi:
    yes | comando_che_chiede_conferma

Esempio:
    yes | apt-get install pacchetto

Può ripetere una frase personalizzata:
    yes "accetto"

Il comando si ferma con:
    CTRL + C

Usi speciali:
- Stress test della CPU:
      yes > /dev/null
- Limitare l'output:
      yes | head -n 10
- Riempire un file con testo ripetuto:
      yes "test" > file.txt
