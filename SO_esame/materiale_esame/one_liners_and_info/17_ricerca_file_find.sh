#!/bin/bash

# ==============================================================================
# 17. FIND MASTER CLASS: RICERCA FILE AVANZATA (MACOS / BSD)
# ==============================================================================
# OBIETTIVO:
# Trovare file nel sistema basandosi su nome, dimensioni, data, permessi o inode.
# Eseguire comandi sui file trovati (es. cancellarli, spostarli, rinominarli).
#
# DIFFERENZE CRITICHE MACOS (BSD) vs LINUX (GNU):
# 1. Cancellazione: Su Mac esiste il flag '-delete' (comodissimo).
# 2. Dimensione: Su Mac 'k' (kilobyte) è minuscolo, 'M' (megabyte) maiuscolo.
# 3. Exec: Le parentesi graffe {} vanno gestite con attenzione.
# 4. Statistiche: Per stampare dimensioni/inode, 'find -ls' è diverso da Linux.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. SETUP AMBIENTE DI TEST
# ------------------------------------------------------------------------------
echo "--- Creazione Ambiente di Test ---"
mkdir -p test_find/docs
mkdir -p test_find/imgs
mkdir -p test_find/logs
touch test_find/docs/report.txt
touch test_find/docs/nota.md
touch test_find/imgs/foto1.jpg
touch test_find/imgs/foto2.png
touch test_find/logs/error.log
touch "test_find/file con spazi.txt"

# Creiamo un file "vecchio" (simulato)
touch -t 202001011200 test_find/vecchio.txt

# Creiamo un file "grande" (10MB)
mkfile 10m test_find/grande_file.bin

echo "File creati in ./test_find"


# ==============================================================================
# 1. SINTASSI BASE E RICERCA PER NOME
# ==============================================================================
# Sintassi: find [DOVE] [COSA_CERCARE] [AZIONI]
# IMPORTANTE: Metti sempre il pattern del nome tra virgolette "*.txt" per evitare
# che la shell lo espanda prima di passarlo a find.

echo "----------------------------------------------------------------"
echo "--- 1. RICERCA PER NOME ---"

# Cerca file che finiscono per .txt nella cartella corrente (.)
echo "Tutti i file .txt:"
find . -name "*.txt"

# Cerca ignorando maiuscole/minuscole (-iname)
echo "Tutti i file .jpg (case insensitive):"
find . -iname "*.JPG"

# Cerca file che NON contengono un pattern (Not / !)
echo "Tutto ciò che NON è un log:"
find ./test_find -not -name "*.log"


# ==============================================================================
# 2. FILTRARE PER TIPO (-type)
# ==============================================================================
# f = file regolare
# d = directory
# l = link simbolico

echo "----------------------------------------------------------------"
echo "--- 2. RICERCA PER TIPO ---"

# Trova solo le DIRECTORY
echo "Solo cartelle:"
find . -type d

# Trova solo i FILE regolari
echo "Solo file:"
find . -type f

# Scenario Esame 12: "Trova la directory con più file"
# Devi prima isolare le directory (-type d) e poi contare il contenuto.


# ==============================================================================
# 3. PROFONDITÀ DI RICERCA (-maxdepth)
# ==============================================================================
# Di default find scende all'infinito.
# -maxdepth 1 = Cerca solo nella cartella corrente (non entrare nelle sottocartelle).

echo "----------------------------------------------------------------"
echo "--- 3. PROFONDITÀ (-maxdepth) ---"

echo "Cerca solo nel primo livello:"
find . -maxdepth 1 -name "*.txt"


# ==============================================================================
# 4. RICERCA PER DIMENSIONE (-size) - CRITICO ESAME 35
# ==============================================================================
# Unità su macOS:
# c = bytes
# k = kilobytes (minuscolo!)
# M = megabytes (maiuscolo!)
# G = gigabytes
#
# Simboli:
# +10M = Più grande di 10MB
# -10M = Più piccolo di 10MB
# 10M  = Esattamente 10MB (raro trovarli esatti)

echo "----------------------------------------------------------------"
echo "--- 4. DIMENSIONE (-size) ---"

echo "File più grandi di 1MB:"
find . -size +1M

echo "File vuoti (size 0):"
find . -empty

# Scenario Esame 35: "Trova i file di maggiori dimensioni"
# Si usa find con -size e poi si passa a sort.
# find . -type f -exec du -k {} + | sort -nr


# ==============================================================================
# 5. RICERCA PER TEMPO (-mtime, -atime)
# ==============================================================================
# mtime = Modification Time (contenuto modificato)
# atime = Access Time (letto/aperto)
# ctime = Change Time (metadati/permessi cambiati)
#
# Unità: GIORNI (di default).
# -1 = Meno di 1 giorno fa (ultime 24h).
# +1 = Più di 1 giorno fa (più vecchio di 24h).

echo "----------------------------------------------------------------"
echo "--- 5. TEMPO (-mtime) ---"

echo "File modificati nelle ultime 24 ore (-mtime -1):"
find . -mtime -1

echo "File più vecchi di 1 anno (+365 giorni):"
find . -mtime +365


# ==============================================================================
# 6. INODE E LINK (-inum, -samefile) - CRITICO ESAME 22 e 17
# ==============================================================================
# Esame 22 chiede: "Trova ed elimina il file e tutti i suoi link".
# I link hard condividono lo stesso numero di Inode.

echo "----------------------------------------------------------------"
echo "--- 6. INODE E LINK ---"

# Creiamo un hard link per testare
ln test_find/docs/report.txt test_find/report_link_hard.txt

# Metodo A: Trovare per numero Inode (-inum)
# 1. Trovo inode del file sorgente
INODE=$(stat -f %i test_find/docs/report.txt)
echo "L'inode di report.txt è: $INODE"
echo "Cerco tutti i file con questo Inode:"
find . -inum "$INODE"

# Metodo B: Trovare per riferimento file (-samefile)
# Più semplice, non serve estrarre l'inode prima.
echo "Cerco tutti gli hard link di report.txt:"
find . -samefile test_find/docs/report.txt

# Esame 17: "Numero di inode più alto"
# find . -type f -exec stat -f %i {} + | sort -nr | head -1


# ==============================================================================
# 7. PERMESSI E UTENTI (-perm, -user) - ESAME 24
# ==============================================================================
# Esame 24: "File leggibile solo dal proprietario".

echo "----------------------------------------------------------------"
echo "--- 7. PERMESSI (-perm) ---"

# Cerca file che hanno ESATTAMENTE permessi 777 (rwxrwxrwx)
# find . -perm 777

# Cerca file che sono eseguibili dall'utente (-perm -u=x)
# Il meno davanti indica "almeno questi permessi".
find . -type f -perm -u=x

# Cerca file di un utente specifico
# find . -user $(whoami)


# ==============================================================================
# 8. ESEGUIRE COMANDI (-exec vs -delete) - LA POTENZA VERA
# ==============================================================================
# Una volta trovati i file, vogliamo farci qualcosa.
#
# Sintassi -exec:
# find ... -exec COMANDO {} \;
# {} viene sostituito dal nome del file trovato.
# \; indica la fine del comando (va escapato).

echo "----------------------------------------------------------------"
echo "--- 8. AZIONI (-exec) ---"

# Esempio: Lanciare 'ls -l' su ogni file trovato
echo "Dettagli file .txt:"
find . -name "*.txt" -exec ls -l {} \;

# Esempio: Cancellare file (Standard POSIX)
# find . -name "*.tmp" -exec rm {} \;

# Esempio: Cancellare file (Specifico macOS/BSD - Più veloce)
# find . -name "*.tmp" -delete


# ==============================================================================
# 9. GESTIONE SPAZI NEI NOMI (PRINT0 e XARGS)
# ==============================================================================
# Se un file si chiama "file con spazi.txt", il comando 'xargs' normale fallisce
# perché crede siano 3 file diversi.
# SU MACOS: Usa -print0 (separa col byte NULL) e xargs -0 (legge byte NULL).

echo "----------------------------------------------------------------"
echo "--- 9. SPAZI E XARGS (-print0) ---"

# Sbagliato (pericoloso con spazi):
# find . -name "*.txt" | xargs rm

# Corretto (Blindato):
echo "File trovati gestiti correttamente con xargs -0:"
find . -name "file con spazi.txt" -print0 | xargs -0 ls -l


# ==============================================================================
# 🧩 SCENARI D'ESAME RISOLTI (SCRIPT PRONTI)
# ==============================================================================

echo "----------------------------------------------------------------"
echo "--- SCENARI D'ESAME ---"

# SCENARIO ESAME 22: "Elimina file e tutti i suoi link"
# ----------------------------------------------------------------
TARGET="test_find/docs/report.txt"
# Usa -samefile per trovare hard links e se stesso.
# Usa -delete per rimuoverli.
# find . -samefile "$TARGET" -delete

# SCENARIO ESAME 35: "N file più grandi"
# ----------------------------------------------------------------
# 1. Trova file (-type f)
# 2. Stampa dimensione e nome (stat -f "%z %N")
# 3. Ordina numerico decrescente (sort -nr)
# 4. Prendi i primi N (head -n 5)
echo "Top 3 file più grandi:"
find . -type f -exec stat -f "%z %N" {} + | sort -nr | head -n 3

# SCENARIO ESAME 17: "Inode più alto"
# ----------------------------------------------------------------
echo "Inode più alto nel sistema:"
find . -exec stat -f %i {} + | sort -nr | head -n 1

# SCENARIO: "Cambia estensione da .htm a .html per tutti i file"
# ----------------------------------------------------------------
# find . -name "*.htm" -exec mv {} {}l \;


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS FIND)
# ==============================================================================
# | FLAG             | DESCRIZIONE                                       |
# |------------------|---------------------------------------------------|
# | -name "*.txt"    | Cerca per nome (case sensitive).                  |
# | -iname "*.txt"   | Cerca per nome (case insensitive).                |
# | -type f / d      | Cerca solo File o Directory.                      |
# | -maxdepth N      | Cerca solo fino a profondità N.                   |
# | -size +10M       | Cerca file più grandi di 10 Mega (M maiuscola!).  |
# | -mtime -1        | Modificati nelle ultime 24 ore.                   |
# | -inum N          | Cerca file con Inode N.                           |
# | -samefile FILE   | Cerca hard link di FILE.                          |
# | -exec CMD {} \;  | Esegue comando su ogni file (uno alla volta).     |
# | -exec CMD {} +   | Esegue comando su gruppi di file (veloce).        |
# | -delete          | Cancella i file trovati (Specifico BSD/Mac).      |
# | -print0          | Stampa terminando con NULL (per xargs -0).        |

# Pulizia ambiente test
rm -rf test_find
echo "----------------------------------------------------------------"
echo "Tutorial Find Completato."

# ==============================================================================
# GUIDA AL COMANDO 'find' (RICERCA NEL FILESYSTEM)
# ==============================================================================

# 1. RICERCA PER NOME E TIPO
# ------------------------------------------------------------------------------
# Cerca tutti i file .sh nella cartella corrente e sottocartelle
find . -name "*.sh"

# Cerca ignorando maiuscole/minuscole
find /home -iname "ESAME.txt"

# Cerca solo DIRECTORY (-type d) o solo FILE (-type f)
find /var/log -type d
find /etc -type f


# 2. RICERCA PER DIMENSIONE E TEMPO
# ------------------------------------------------------------------------------
# Trova file più grandi di 100MB
find / -size +100M

# Trova file modificati negli ultimi 2 giorni (-mtime)
find . -mtime -2

# Trova file vuoti
find . -empty


# 3. RICERCA PER PERMESSI E UTENTE
# ------------------------------------------------------------------------------
# Trova file che hanno permessi 777 (pericoloso!)
find . -perm 777

# Trova file appartenenti all'utente mlazoi814
find /home -user mlazoi814


# 4. AZIONI SUI RISULTATI (-exec) - MOLTO IMPORTANTE PER L'ESAME
# ------------------------------------------------------------------------------
# Trova tutti i file .log e cancellali (usa con cautela!)
# find . -name "*.log" -exec rm {} \;

# Trova tutti i file .sh e cambiane i permessi a 755
find . -name "*.sh" -exec chmod 755 {} \;


# ==============================================================================
# 📊 TABELLA DELLE OPZIONI (FLAG) PER 'find'
# ==============================================================================
# | FLAG     | NOME INTERO    | DESCRIZIONE                                     |
# |----------|----------------|-------------------------------------------------|
# | .        | Path           | Punto di partenza ( . = qui, / = tutto il disco)|
# | -name    | Name           | Cerca per nome (esatto e case-sensitive)        |
# | -iname   | Ignore Name    | Cerca per nome ignorando maiuscole/minuscole    |
# | -type f  | Type File      | Cerca solo i file regolari                      |
# | -type d  | Type Directory | Cerca solo le cartelle                          |
# | -size    | Size           | Dimensione (+10M = più di 10MB, -1k = meno di 1KB)|
# | -mtime   | Modify Time    | Giorni dall'ultima modifica (+7 = più di una sett)|
# | -user    | User           | Cerca file di un determinato utente             |
# | -perm    | Permissions    | Cerca per permessi ottali (es. 644)             |
# | -empty   | Empty          | Trova file o cartelle vuote                     |
# | -exec    | Execute        | Esegue un comando su ogni file trovato          |
# | -delete  | Delete         | Cancella direttamente i file trovati            |
# | -maxdepth| Max Depth      | Limita la ricerca a N livelli di sottocartelle  |


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (SCENARI PRATICI)
# ==============================================================================

# --- SCENARIO 1: "Trova e conta quanti file ci sono" ---
# find . -type f | wc -l

# --- SCENARIO 2: "Trova una parola dentro i file trovati" ---
# Trova tutti i file .txt e cerca la parola "ERRORE" al loro interno
# find . -name "*.txt" -exec grep "ERRORE" {} +

# --- DIFFERENZA TRA {} \; e {} + ---
# -exec comando {} \;  -> Lancia il comando UNA VOLTA per OGNI file (lento).
# -exec comando {} +   -> Lancia il comando una volta sola passando tutti i file insieme (veloce).

# --- TRUCCO PER I PERMESSI NEGATI ---
# Quando cerchi come utente normale, vedrai molti errori "Permission denied".
# Pulire l'output mandando gli errori nel nulla:
# find / -name "segreto.txt" 2>/dev/null