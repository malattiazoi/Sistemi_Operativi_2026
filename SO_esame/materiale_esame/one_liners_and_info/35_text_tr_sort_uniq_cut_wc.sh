#!/bin/bash

# ==============================================================================
# 35. TEXT TOOLS: TR, SORT, UNIQ, CUT, WC (MANIPOLAZIONE DATI)
# ==============================================================================
# OBIETTIVO:
# Imparare a manipolare flussi di testo per risolvere esercizi di:
# 1. Crittografia e Sostituzione (Esame 23 - Cifrario).
# 2. Ordinamento e Classifica (Esame 35 - File più grandi, Esame 12 - Directory popolate).
# 3. Pulizia dati (Rimozione spazi, caratteri DOS).
#
# AMBIENTE: macOS (BSD Tools)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. TR (TRANSLATE) - IL SOSTITUTORE DI CARATTERI
# ------------------------------------------------------------------------------
# `tr` lavora SOLO sullo Standard Input (STDIN). Non accetta file come argomenti.
# Devi usare la pipe `|` o la ridirezione `<`.
# Sintassi: tr [OPZIONI] SET1 [SET2]

echo "--- 1. TR (Translate) ---"

# 1.1 Sostituzione Semplice (Carattere per Carattere)
# Sostituisce ogni 'e' con 'E' e ogni 'o' con 'O'.
echo "hello world" | tr "eo" "EO"
# Output: hEllO wOrld

# 1.2 Cancellazione (-d) - PULIZIA FILE
# Rimuovere tutti i numeri da una stringa.
echo "Password123Segreta456" | tr -d '0-9'
# Output: PasswordSegreta

# 1.3 Compressione Ripetizioni (-s / Squeeze)
# Riduce sequenze di caratteri ripetuti a uno solo. Utile per spazi multipli.
echo "Mario    Rossi     ha    spazi" | tr -s ' '
# Output: Mario Rossi ha spazi


# ------------------------------------------------------------------------------
# 🎯 SIMULAZIONE ESAME 23: IL CIFRARIO (ROT13)
# ------------------------------------------------------------------------------
# Traccia Esame 23:
# "Trasformare le lettere dalla A alla M in lettere dalla N alla Z e viceversa;
#  le lettere dalla a alla m in lettere dalla n alla z e viceversa."
#
# Questa è la definizione esatta del cifrario ROT13 (Ruota di 13 posizioni).
# L'alfabeto ha 26 lettere. 13 è la metà. Quindi A(1) -> N(14).

echo "--- Simulazione Esame 23: Cifrario ---"

MESSAGGIO="Ciao Esame 23"

# Mappatura:
# A-M diventeranno N-Z
# N-Z diventeranno A-M
# Idem per minuscole.
#
# SET1 (Input):  'A-Za-z'
# SET2 (Output): 'N-ZA-Mn-za-m'

CIFRATO=$(echo "$MESSAGGIO" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
echo "Originale: $MESSAGGIO"
echo "Cifrato:   $CIFRATO"

# Verifica (Decifrare = Cifrare di nuovo con ROT13)
DECIFRATO=$(echo "$CIFRATO" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
echo "Decifrato: $DECIFRATO"


# ------------------------------------------------------------------------------
# 2. SORT (ORDINAMENTO)
# ------------------------------------------------------------------------------
# Fondamentale per creare classifiche (Top N file, Top N processi).

echo "--- 2. SORT (Ordinamento) ---"

# Creiamo un file di numeri disordinati
printf "10\n2\n100\n50\n" > numeri.txt

# 2.1 Ordinamento Alfabetico (DEFAULT - PERICOLOSO CON NUMERI)
# Per il computer, "100" viene prima di "2" perché '1' < '2'.
echo "Sort Alfabetico (Sbagliato per numeri):"
sort numeri.txt

# 2.2 Ordinamento Numerico (-n)
echo "Sort Numerico (-n):"
sort -n numeri.txt

# 2.3 Ordinamento Inverso (-r)
# Dal più grande al più piccolo.
echo "Sort Inverso (-r):"
sort -nr numeri.txt

# 2.4 Ordinamento per Colonna (-k)
# Se hai un file a colonne (es. "Nome Età"), e vuoi ordinare per Età (colonna 2).
printf "Mario 30\nLuigi 25\nAnna 40\n" > persone.txt
echo "Ordina per età (colonna 2):"
sort -k 2 -n persone.txt


# ------------------------------------------------------------------------------
# 🎯 SIMULAZIONE ESAME 35: ORDINAMENTO FILE PER DIMENSIONE
# ------------------------------------------------------------------------------
# Traccia: "Creare N soft link agli N file di maggiori dimensioni"
# Dobbiamo trovare i file, ottenerne la dimensione e ordinarli.

echo "--- Simulazione Esame 35: Sort File Size ---"

# 1. Trova tutti i file nella cartella corrente (.)
# 2. Esegui 'du -k' (Disk Usage in Kilobyte) per ogni file.
# 3. Ordina numericamente inverso (-nr) per avere i più grandi in cima.
# 4. Prendi i primi 5 (head -n 5).

find . -type f -exec du -k {} + | sort -nr | head -n 5

# NOTA MACOS:
# 'du' su Mac stampa: "DIMENSIONE   ./PERCORSO/FILE"
# Quindi la colonna 1 è la dimensione (perfetto per sort -n).


# ------------------------------------------------------------------------------
# 3. UNIQ (RIMUOVERE O CONTARE DUPLICATI)
# ------------------------------------------------------------------------------
# REGOLA D'ORO: `uniq` funziona SOLO su input adiacenti.
# DEVI SEMPRE FARE `sort` PRIMA DI `uniq`.

echo "--- 3. UNIQ ---"

# Lista con duplicati
printf "Mela\nPera\nMela\nBanana\nMela\n" > frutta.txt

# 3.1 Rimuovere duplicati (Output unico)
echo "Lista unica:"
sort frutta.txt | uniq

# 3.2 Contare occorrenze (-c) - UTILISSIMO PER STATISTICHE
# "Qual è il frutto più frequente?"
echo "Conteggio frequenza:"
sort frutta.txt | uniq -c | sort -nr
# Output:
#    3 Mela
#    1 Pera
#    1 Banana
# (Notare il doppio sort: il primo per uniq, il secondo per ordinare la classifica).


# ------------------------------------------------------------------------------
# 4. CUT (TAGLIARE COLONNE)
# ------------------------------------------------------------------------------
# Più veloce e semplice di awk se il separatore è un carattere singolo.

echo "--- 4. CUT ---"

# CSV Esempio
echo "Nome,Cognome,Età,Città" > dati.csv
echo "Mario,Rossi,30,Roma" >> dati.csv

# 4.1 Estrarre campi (-f) con delimitatore (-d)
# Estrai solo Cognome (2) e Città (4) separati da virgola
cut -d ',' -f 2,4 dati.csv

# 4.2 Estrarre caratteri (-c)
# Estrai i primi 3 caratteri di ogni riga
echo "abcdefg" | cut -c 1-3


# ------------------------------------------------------------------------------
# 5. WC (WORD COUNT) - CONTEGGI
# ------------------------------------------------------------------------------
# Usato per verificare condizioni ("Se ci sono più di 10 file, allora...")

echo "--- 5. WC ---"
# -l : Linee
# -w : Parole
# -c : Byte

# Conta quanti file ci sono nella cartella corrente
NUM_FILE=$(ls -1 | wc -l)
echo "Ci sono $NUM_FILE file qui."


# ==============================================================================
# 🧩 ESERCIZIO COMBINATO: ANALISI LOG
# ==============================================================================
# Scenario: Hai un log di accessi web. Vuoi sapere l'IP che ha fatto più richieste.
# Formato Log: "IP - DATA - METODO"
# 192.168.1.50 - [10/Oct] - GET
# 10.0.0.1 - [10/Oct] - POST
# 192.168.1.50 - [10/Oct] - GET

echo "--- Esercizio Combinato: Top IP ---"

cat <<EOF > access.log
192.168.1.50 - GET
10.0.0.1 - POST
192.168.1.50 - GET
192.168.1.50 - POST
10.0.0.1 - GET
8.8.8.8 - GET
EOF

# Pipeline:
# 1. cut -d ' ' -f 1    -> Estrae solo l'IP (prima colonna, spazio delim).
# 2. sort               -> Ordina gli IP (necessario per uniq).
# 3. uniq -c            -> Conta le ripetizioni ("3 192.168.1.50").
# 4. sort -nr           -> Mette quello con più hit in cima.
# 5. head -n 1          -> Prende il vincitore.

VINCITORE=$(cut -d ' ' -f 1 access.log | sort | uniq -c | sort -nr | head -n 1)
echo "L'IP più attivo è: $VINCITORE"


# ==============================================================================
# ⚠️ TRUCCHI "SALVA VITA" PER L'ESAME
# ==============================================================================

# --- TRUCCO 1: SORT UMANO (KB, MB) ---
# Se devi ordinare l'output di `ls -lh` (che ha 1K, 2M, 3G),
# su Linux useresti `sort -h`.
# Su macOS vecchio (spesso nei laboratori), `-h` potrebbe non esistere.
# SOLUZIONE: Usa i comandi base (`du -k`) che danno numeri puri e usa `sort -n`.

# --- TRUCCO 2: PULIZIA DOS (\r) ---
# Se lo script del prof non va, probabilmente ha caratteri Windows invisibili.
# cat file_win.txt | tr -d '\r' > file_mac.txt

# --- TRUCCO 3: CASE INSENSITIVE ---
# Per ordinare ignorando maiuscole/minuscole:
# sort -f file.txt  