#!/bin/bash

# ==============================================================================
# 28. GUIDA COMPLETA AL COMANDO 'stat' (METADATI FILE) - SPECIFICA MACOS
# ==============================================================================
# DESCRIZIONE:
# Il comando 'stat' mostra lo stato dettagliato di un file o filesystem.
# Non mostra il CONTENUTO del file, ma i suoi METADATI:
# - Inode (indirizzo sul disco)
# - Permessi (ottali e simbolici)
# - Proprietari (UID/GID)
# - Timestamps (Access, Modify, Change, Birth)
# - Dimensioni (Bytes, Blocchi)
#
# ⚠️ ATTENZIONE: AMBIENTE MACOS (BSD)
# La sintassi di 'stat' su Mac è COMPLETAMENTE diversa da quella Linux.
# Linux usa '-c' o '--printf'. macOS usa '-f'.
# Se usi i flag di Linux su Mac, lo script fallirà.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. UTILIZZO BASE (OUTPUT STANDARD)
# ------------------------------------------------------------------------------
# Mostra tutte le informazioni disponibili in formato predefinito (verboso).
stat file_di_test.txt

# Output tipico Mac:
# 16777220 8645558 -rw-r--r-- 1 mlazoi814 staff 0 0 "Jan 25 10:00:00 2024" ...
# (Difficile da leggere per un umano, ottimo per il sistema).


# ------------------------------------------------------------------------------
# 2. OUTPUT LEGGIBILE LINUX-STYLE (FLAG -x)
# ------------------------------------------------------------------------------
# Su macOS, il flag -x ("eXtended") formatta l'output in modo molto simile
# al comando 'stat' standard di Linux. È il modo più veloce per leggere i dati.
stat -x file_di_test.txt

# Mostrerà chiaramente:
# File: "file_di_test.txt"
# Size: 1024       FileType: Regular File
# Mode: (0644/-rw-r--r--)         Uid: (501/mlazoi)  Gid: (20/staff)
# Device: 1,4   Inode: 8645558    Links: 1
# Access: ...
# Modify: ...
# Change: ...


# ------------------------------------------------------------------------------
# 3. FORMATTAZIONE PERSONALIZZATA (FLAG -f) - CRITICO PER SCRIPT
# ------------------------------------------------------------------------------
# Se devi estrarre UN SOLO dato (es. solo la dimensione) per usarlo in una variabile,
# devi usare il flag -f ("format").
# SINTASSI: stat -f "stringa_formato" file

# --- ESTRAZIONE DIMENSIONI ---
# %z = Size in bytes (su Linux sarebbe %s)
stat -f %z file_di_test.txt

# %b = Blocchi allocati (da 512 byte)
stat -f %b file_di_test.txt


# --- ESTRAZIONE PERMESSI ---
# %Lp = Permessi in formato Ottale (es. 644) - FONDAMENTALE PER IF/CHECK
# (La 'L' sta per Low usage, la 'p' per permissions)
stat -f %Lp file_di_test.txt

# %Sp = Permessi in formato Simbolico (es. -rw-r--r--)
stat -f %Sp file_di_test.txt


# --- ESTRAZIONE NOMI E PROPRIETARI ---
# %N = Nome del file
stat -f %N file_di_test.txt

# %Su = Nome utente proprietario (String User)
stat -f %Su file_di_test.txt

# %u = UID numerico proprietario
stat -f %u file_di_test.txt

# %Sg = Nome gruppo (String Group)
stat -f %Sg file_di_test.txt


# ------------------------------------------------------------------------------
# 4. GESTIONE TEMPO E DATE (TIMESTAMPS)
# ------------------------------------------------------------------------------
# I file hanno 4 date principali su Mac:
# %a = Access Time (ultimo accesso lettura)
# %m = Modify Time (ultima modifica contenuto)
# %c = Change Time (ultima modifica metadati/permessi)
# %B = Birth Time (data creazione file - Esclusiva Mac/BSD, Linux spesso non l'ha)

# --- FORMATO RAW (EPOCH) ---
# Secondi dal 1970 (utile per calcoli matematici e confronti)
stat -f %m file_di_test.txt

# --- FORMATO LEGGIBILE (FLAG -t) ---
# Per formattare la data, devi usare INSIEME -t (time format) e -f (campo).
# %Sm = String Modify (usa il formato definito da -t)

# Formato standard leggibile:
stat -f %Sm file_di_test.txt

# Formato personalizzato (Anno-Mese-Giorno Ora:Minuti):
stat -t "%Y-%m-%d %H:%M" -f %Sm file_di_test.txt


# ------------------------------------------------------------------------------
# 5. OUTPUT PER VARIABILI DI SHELL (FLAG -s)
# ------------------------------------------------------------------------------
# Questo flag è magico per gli script.
# Invece di stampare a video, prepara delle variabili d'ambiente pronte per 'eval'.

stat -s file_di_test.txt
# Output: st_dev=16777220 st_ino=8645558 st_mode=0100644 ...

# Esempio di utilizzo in uno script:
eval $(stat -s file_di_test.txt)
echo "Il file pesa $st_size bytes e ha permessi $st_mode"


# ------------------------------------------------------------------------------
# 6. GESTIONE LINK SIMBOLICI (FLAG -L)
# ------------------------------------------------------------------------------
# Default: stat analizza il LINK STESSO, non il file a cui punta.
# Flag -L: stat segue il link e analizza il FILE DI DESTINAZIONE.

# Crea un link di test
ln -s file_di_test.txt link_al_file

# Analizza il link (dimensione piccola, tipo file "Symbolic Link")
stat -x link_al_file

# Analizza la destinazione (dimensione reale, tipo file "Regular File")
stat -x -L link_al_file


# ==============================================================================
# 📊 TABELLA FORMATI 'stat' (SPECIFICA MACOS / BSD)
# ==============================================================================
# | CODICE | DESCRIZIONE                                | ESEMPIO OUTPUT       |
# |--------|--------------------------------------------|----------------------|
# | %N     | Nome del file                              | pippo.txt            |
# | %z     | Dimensione in bytes (Linux: %s)            | 1024                 |
# | %b     | Numero di blocchi allocati                 | 8                    |
# | %Lp    | Permessi ottali (Linux: %a)                | 644                  |
# | %Sp    | Permessi simbolici (Linux: %A)             | -rw-r--r--           |
# | %u     | UID numerico proprietario                  | 501                  |
# | %Su    | Username proprietario                      | mlazoi814            |
# | %g     | GID numerico gruppo                        | 20                   |
# | %Sg    | Nome gruppo                                | staff                |
# | %m     | Modify Time (Raw Epoch)                    | 1698345600           |
# | %Sm    | Modify Time (Leggibile)                    | Oct 26 10:00:00 2023 |
# | %a / %Sa| Access Time                               | ...                  |
# | %c / %Sc| Change Time (Metadati)                    | ...                  |
# | %B / %SB| Birth Time (Creazione)                    | ...                  |
# | %Y     | Target del Symlink (se è un link)          | -> file_reale.txt    |


# ==============================================================================
# 💡 SCENARI D'ESAME E TRUCCHI
# ==============================================================================

# --- SCENARIO 1: "Verifica se un file è vuoto (0 bytes)" ---
# size=$(stat -f %z mio_file.txt)
# if [ "$size" -eq 0 ]; then echo "File vuoto!"; fi

# --- SCENARIO 2: "Ottieni i permessi ottali per un chmod rapido" ---
# Copiare i permessi da file A a file B:
# perms=$(stat -f %Lp file_sorgente)
# chmod $perms file_destinazione

# --- SCENARIO 3: "Calcola l'età di un file in secondi" ---
# adesso=$(date +%s)
# file_time=$(stat -f %m file.txt)
# eta=$((adesso - file_time))
# echo "Il file ha $eta secondi."

# --- SCENARIO 4: "Differenza Linux vs Mac (Errore Classico)" ---
# Se in esame scrivi: stat -c %s file
# Su Mac otterrai: "stat: illegal option -- c"
# DEVI scrivere: stat -f %z file

# --- TRUCCO PER NON IMPAZZIRE CON I FORMATI ---
# Se non ricordi %z, %u, etc., usa `stat -x` e poi `grep` o `awk`.
# È meno elegante e meno efficiente, ma funziona se hai un blocco di memoria.
# stat -x file.txt | grep "Size:" | awk '{print $2}'