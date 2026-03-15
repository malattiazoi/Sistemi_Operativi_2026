#!/bin/bash

# ==============================================================================
# 51. MANIPOLAZIONE COLONNE: CUT, PASTE, UNIQ, REV (MACOS)
# ==============================================================================
# OBIETTIVO:
# Estrarre campi specifici da file di testo (es. solo i nomi utenti, solo i PID),
# unire file lateralmente e gestire i duplicati.
#
# COMANDI CHIAVE DALLE SLIDE:
# - cut: Taglia sezioni di ogni riga.
# - uniq: Filtra righe identiche ADIACENTI (richiede sort).
# - paste: Unisce file "fianco a fianco" (non in coda come cat).
# - rev: Inverte i caratteri della riga (ciao -> oaic).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CUT: ESTRARRE DATI VERTICALI
# ------------------------------------------------------------------------------
# Sintassi: cut -d "DELIMITATORE" -f "CAMPI" file

echo "--- 1. CUT ---"

# Creiamo un file CSV simulato
# Nome,Cognome,Età,Città
echo "Mario,Rossi,30,Milano" > dati.csv
echo "Luigi,Verdi,25,Roma" >> dati.csv
echo "Anna,Bianchi,30,Napoli" >> dati.csv

# 1.1 Estrarre un campo specifico (-f)
# -d ',' : Usa la virgola come separatore
# -f 2   : Prendi la seconda colonna (Cognome)
echo "Solo Cognomi:"
cut -d ',' -f 2 dati.csv

# 1.2 Estrarre più campi
# -f 1,4 : Prendi colonna 1 e 4
echo "Nome e Città:"
cut -d ',' -f 1,4 dati.csv

# 1.3 Estrarre per posizione carattere (-c)
# Utile per file a larghezza fissa (es. ls -l permissions)
echo "Primi 3 caratteri di ogni riga:"
cut -c 1-3 dati.csv


# ------------------------------------------------------------------------------
# 2. UNIQ: RIMUOVERE DUPLICATI
# ------------------------------------------------------------------------------
# ATTENZIONE: 'uniq' funziona solo se le righe uguali sono CONSECUTIVE.
# Bisogna SEMPRE usare 'sort' prima di 'uniq'.

echo "----------------------------------------------------------------"
echo "--- 2. UNIQ ---"

# Creiamo lista con duplicati
printf "A\nB\nA\nA\nC\nB\n" > lista_sporca.txt

# 2.1 Uniq base (Rimuove duplicati consecutivi)
echo "Uniq senza sort (Sbagliato, A appare due volte):"
uniq lista_sporca.txt

echo "Uniq con sort (Corretto):"
sort lista_sporca.txt | uniq

# 2.2 Contare le occorrenze (-c) - FONDAMENTALE PER STATISTICHE
echo "Conteggio presenze:"
sort lista_sporca.txt | uniq -c
# Output: 3 A, 2 B, 1 C

# 2.3 Mostrare solo i duplicati (-d) o solo gli unici (-u)
echo "Solo righe duplicate:"
sort lista_sporca.txt | uniq -d


# ------------------------------------------------------------------------------
# 3. PASTE: UNIRE FILE ORIZZONTALMENTE
# ------------------------------------------------------------------------------
# 'cat' unisce verticalmente (uno dopo l'altro).
# 'paste' unisce orizzontalmente (colonna A + colonna B).

echo "----------------------------------------------------------------"
echo "--- 3. PASTE ---"

printf "1\n2\n3\n" > numeri.txt
printf "A\nB\nC\n" > lettere.txt

# Unione standard (Tab separator)
echo "Unione Tab:"
paste numeri.txt lettere.txt

# Unione con delimitatore specifico (-d)
echo "Unione CSV:"
paste -d "," numeri.txt lettere.txt


# ------------------------------------------------------------------------------
# 4. REV: INVERSIONE TESTO
# ------------------------------------------------------------------------------
# Inverte ogni riga. Utile per cercare estensioni file o pattern finali.

echo "----------------------------------------------------------------"
echo "--- 4. REV ---"

echo "reversethis" | rev
# Output: sihtesrever

# Esempio: Estrarre estensione file (senza sapere quanti punti ha)
FILE="archivio.tar.gz"
# 1. Inverti: zg.rat.oivihcra
# 2. Taglia primo campo (punto delim): zg
# 3. Inverti di nuovo: gz
EXT=$(echo "$FILE" | rev | cut -d '.' -f 1 | rev)
echo "Estensione di $FILE -> $EXT"


# ==============================================================================
# ⚠️ TABELLA RIASSUNTIVA
# ==============================================================================
# | COMANDO | FLAG     | AZIONE                                            |
# |---------|----------|---------------------------------------------------|
# | cut     | -d "x"   | Imposta delimitatore a "x".                       |
# | cut     | -f N     | Estrae campo N.                                   |
# | cut     | -c 1-5   | Estrae caratteri da 1 a 5.                        |
# | uniq    | -c       | Conta occorrenze (richiede sort prima!).          |
# | uniq    | -d       | Mostra solo i duplicati.                          |
# | paste   | -d ","   | Incolla file fianco a fianco separati da virgola. |
# | rev     | -        | Inverte il testo (abc -> cba).                    |

# Pulizia
rm -f dati.csv lista_sporca.txt numeri.txt lettere.txt
echo "----------------------------------------------------------------"
echo "Tutorial 51 Completato."