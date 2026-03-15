#!/bin/bash

# ==============================================================================
# 54. CHEAT SHEET: SIMBOLI, VARIABILI SPECIALI E SHORTCUTS
# ==============================================================================
# OBIETTIVO:
# Tabella di riferimento rapido per tutti i simboli strani di Bash.
# DA CONSULTARE QUANDO NON TI RICORDI COSA FA UN SIMBOLO.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. VARIABILI SPECIALI (AUTOMATICHE)
# ------------------------------------------------------------------------------
# $?  = EXIT CODE dell'ultimo comando. (0 = Successo, 1-255 = Errore).
#       Utile: if [ $? -eq 0 ]; then ...
#
# $!  = PID dell'ultimo processo lanciato in BACKGROUND (&).
#       Utile: ./script.sh & PID=$! ... kill $PID
#
# $$  = PID dello shell/script CORRENTE (Me stesso).
#       Utile: Per creare file temp unici (es. /tmp/file_$$)
#
# $#  = NUMERO di argomenti passati allo script.
#       Utile: if [ $# -lt 2 ]; then echo "Servono 2 argomenti"; fi
#
# $0  = IL NOME dello script stesso (es. "./mio_script.sh").
#
# $1  = IL PRIMO argomento passato allo script.
# $2  = IL SECONDO argomento... (fino a $9).
#
# $@  = TUTTI gli argomenti (come lista separata).
#       Utile: for ARG in "$@"; do ...
#
# $_  = L'ULTIMO argomento del comando precedente (Shortcut da tastiera).
#
# $USER = Nome utente corrente (Variabile ambiente).
# $HOME = Percorso home directory (es. /Users/mario).
# $PWD  = Directory corrente (Output di pwd).
# $RANDOM = Numero casuale tra 0 e 32767.


# ------------------------------------------------------------------------------
# 2. OPERATORI LOGICI E DI CONTROLLO
# ------------------------------------------------------------------------------
# ;   = SEPARATORE comandi. Esegui A poi B (indipendentemente dall'errore).
#       Esempio: cd .. ; ls
#
# &&  = AND logico. Esegui B *solo se* A ha avuto successo (Exit 0).
#       Esempio: mkdir test && cd test
#
# ||  = OR logico. Esegui B *solo se* A ha FALLITO (Exit != 0).
#       Esempio: cp file1 file2 || echo "Copia fallita!"
#
# &   = BACKGROUND. Esegui il comando in sottofondo e ridammi subito il terminale.
#       Esempio: sleep 100 &
#
# |   = PIPE. Prendi l'output di A e usalo come input di B.
#       Esempio: cat file.txt | grep "Ciao"
#
# !   = NOT (Negazione).
#       Esempio: if [ ! -f file ]; then (Se il file NON esiste).


# ------------------------------------------------------------------------------
# 3. REDIREZIONI (INPUT / OUTPUT)
# ------------------------------------------------------------------------------
# >   = SOVRASCRIVI Output standard (Stdout) su file.
#       Esempio: echo "Ciao" > file.txt (Cancella contenuto precedente).
#
# >>  = APPENDI Output standard su file.
#       Esempio: echo "Ciao" >> file.txt (Aggiunge in coda).
#
# <   = INPUT da file.
#       Esempio: while read RIGA; do ... done < file.txt
#
# 2>  = REDIRIGI ERRORI (Stderr).
#       Esempio: ls cartella_fantasma 2> errori.log
#
# 2>&1 = MANDA ERRORI NELLO STESSO POSTO DELL'OUTPUT NORMALE.
#       Esempio: comando > tutto.log 2>&1 (Tutto finisce nel log).
#
# /dev/null = IL BUCO NERO. Butta via tutto quello che ci mandi.
#       Esempio: comando > /dev/null 2>&1 (Silenzio assoluto).
#
# <<< = HERE STRING. Passa una stringa come se fosse un file.
#       Esempio: grep "Ciao" <<< "Ciao Mondo"
#
# <<EOF = HERE DOC. Crea un file multilinea al volo.
#       Esempio: cat <<EOF > file.txt ... EOF


# ------------------------------------------------------------------------------
# 4. PARENTESI E COSTRUTTI
# ------------------------------------------------------------------------------
# ( ... )   = SUBSHELL. Esegui comandi in un processo figlio isolato.
#             Esempio: (cd /tmp; ls) -> Al termine sei tornato dove eri prima.
#
# { ...; }  = GRUPPO. Esegui comandi nel processo corrente (Attenzione al ; finale).
#
# $( ... )  = COMMAND SUBSTITUTION. Esegui comando e sostituisci col risultato.
#             Esempio: DATA=$(date)
#
# $(( ... ))= ARITMETICA. Fai calcoli matematici (+ - * / %).
#             Esempio: NUM=$(( 10 + 5 ))
#
# [ ... ]   = TEST STANDARD (POSIX). Per if classici.
#             Esempio: if [ "$VAR" == "1" ]; then
#
# [[ ... ]] = TEST AVANZATO (BASH). Supporta Regex (=~) e wildcard.
#             Esempio: if [[ "$FILE" == *.jpg ]]; then


# ------------------------------------------------------------------------------
# 5. WILDCARDS (GLOBBING)
# ------------------------------------------------------------------------------
# * = Tutto (qualsiasi stringa di qualsiasi lunghezza).
#         Esempio: rm *.jpg
#
# ?     = Un solo carattere qualsiasi.
#         Esempio: ls file?.txt (Trova file1.txt, fileA.txt, ma non file10.txt)
#
# [...] = Range di caratteri.
#         Esempio: ls file[1-3].txt (Trova file1, file2, file3)


# ------------------------------------------------------------------------------
# 6. VIRGOLETTE (QUOTING)
# ------------------------------------------------------------------------------
# "..." = DOPPIE. Le variabili ($VAR) vengono espanse (lette).
#         Esempio: echo "Ciao $USER" -> Ciao Mario
#
# '...' = SINGOLE. Tutto è letterale. Niente espansione.
#         Esempio: echo 'Ciao $USER' -> Ciao $USER
#
# `...` = BACKTICKS. Vecchio modo per fare $(...). Sconsigliato.

echo "File di consultazione caricato."