#!/bin/bash

# ==============================================================================
# 36. INODE, HARD LINK E SOFT LINK (STRUTTURA DEL FILESYSTEM)
# ==============================================================================
# OBIETTIVO:
# Risolvere gli Esami 22 ("Elimina file e tutti i suoi link") e 
# Esame 35 ("Crea link con nome formattato in base alla dimensione").
#
# CONCETTI CHIAVE:
# 1. INODE: La carta d'identità del file (metadati). Il nome del file è solo un'etichetta.
# 2. HARD LINK: Un secondo nome per lo STESSO Inode (stessi dati).
# 3. SOFT LINK: Un file speciale che "punta" al percorso di un altro file.
#
# AMBIENTE: macOS (BSD stat e find)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. ANALISI INODE (STAT SU MACOS)
# ------------------------------------------------------------------------------
# Ogni file ha un numero univoco nel filesystem chiamato Inode.
# Se due file hanno lo stesso Inode, SONO LO STESSO FILE (Hard Link).

echo "--- 1. Creazione file e analisi Inode ---"
echo "Contenuto Originale" > file_target.txt

# Visualizzare il numero di Inode con 'ls' (flag -i)
ls -i file_target.txt

# Visualizzare Inode con 'stat' (Metodo Scripting macOS)
# Linux usa: stat -c %i
# macOS usa: stat -f %i
INODE=$(stat -f %i file_target.txt)
echo "Il numero Inode è: $INODE"


# ------------------------------------------------------------------------------
# 2. HARD LINK (LN senza flag)
# ------------------------------------------------------------------------------
# Crea un clone perfetto. I dati sul disco sono unici, ma hanno due nomi.
# Se cancelli l'originale, l'Hard Link RIMANE e i dati sono salvi.
# I permessi e l'owner sono identici e sincronizzati.

echo "--- 2. Hard Link ---"
ln file_target.txt hard_link.txt

# Verifica: Devono avere lo stesso numero Inode
ls -li file_target.txt hard_link.txt

# Verifica Link Count (Seconda colonna di ls -l)
# Ora dovrebbe essere '2' perché ci sono due nomi per questi dati.
ls -l file_target.txt


# ------------------------------------------------------------------------------
# 3. SOFT LINK / SYMLINK (LN -s)
# ------------------------------------------------------------------------------
# È una scorciatoia. Punta al PERCORSO del file, non all'Inode.
# Ha un suo Inode diverso.
# Se cancelli l'originale, il Soft Link si ROMPE (Broken Link).

echo "--- 3. Soft Link ---"
ln -s file_target.txt soft_link.txt

# Verifica: Inode diversi e permessi indicati con 'l' (link)
ls -li file_target.txt soft_link.txt

# Analisi del puntamento (Dove porta il link?)
# readlink mostra la destinazione
readlink soft_link.txt


# ------------------------------------------------------------------------------
# 4. TROVARE I LINK (FIND -SAMEFILE / -INUM) - SOLUZIONE ESAME 22
# ------------------------------------------------------------------------------
# SCENARIO ESAME 22: "Elimina il file e tutti i link (hard e soft) ad esso".
# Problema: Come trovo tutti i file che sono Hard Link del mio file?
# Metodo 1: Cerca per numero di inode.
# Metodo 2: Usa flag -samefile (più semplice).

echo "--- 4. Ricerca Link (Simulazione Esame 22) ---"

TARGET="file_target.txt"

# A. Trovare Hard Links (condividono l'inode)
echo "Cerco tutti gli Hard Link di $TARGET..."
find . -type f -samefile "$TARGET"

# B. Trovare Soft Links (puntano al nome)
# Questo è difficile perché il soft link contiene solo il testo del nome.
# Dobbiamo cercare file di tipo 'l' (link) che puntano a quel nome.
# Nota: Questo trova solo link diretti nella cartella corrente.
echo "Cerco Soft Link che puntano a $TARGET..."
find . -type l -exec readlink {} \; | grep "$TARGET"


# ------------------------------------------------------------------------------
# 5. ELIMINAZIONE TOTALE (HARD + SOFT) - SCRIPT ELIMINA
# ------------------------------------------------------------------------------
# Bozza di soluzione per l'esercizio "elimina" dell'Esame 22.

echo "--- 5. Simulazione Script 'elimina' ---"
# Argomento passato allo script
FILE_DA_ELIMINARE="file_target.txt"

# 1. Recupero Inode (per sicurezza sugli hard link)
TARGET_INODE=$(stat -f %i "$FILE_DA_ELIMINARE")

echo "Eliminazione Hard Links (Inode $TARGET_INODE)..."
# find . -inum $TARGET_INODE -exec rm {} \; 
# (Commentato per non distruggere l'esempio durante l'esecuzione dello script)
echo "Comando pronto: find . -inum $TARGET_INODE -exec rm {} \;"

# 2. Recupero Soft Links
# Cerchiamo file di tipo link (-type l) il cui target è il nome del file
echo "Eliminazione Soft Links..."
# find . -type l -exec test "$(readlink {})" = "$FILE_DA_ELIMINARE" \; -delete
# (Logica: Per ogni link, leggi dove punta. Se punta al nostro file, cancellalo).


# ------------------------------------------------------------------------------
# 6. FORMATTAZIONE NOMI LINK (PRINTF) - SOLUZIONE ESAME 35
# ------------------------------------------------------------------------------
# SCENARIO ESAME 35:
# "Creare link con nome: 12 cifre dimensione in bytes + trattino + nome originale".
# Esempio: file pesa 1024 bytes -> "000000001024-file.txt"

echo "--- 6. Formattazione Nomi Link (Esame 35) ---"

# Creiamo un file dummy
echo "Dati di prova per esame 35" > pippo.txt

# 1. Ottenere dimensione in bytes (stat -f %z su Mac)
DIMENSIONE=$(stat -f %z pippo.txt)

# 2. Ottenere nome file (basename)
NOME="pippo.txt"

# 3. Formattare stringa a 12 cifre con zeri iniziali (Padding)
# %012d significa: Intero decimale, 12 spazi, riempi vuoti con 0.
LINK_NAME=$(printf "%012d-%s" "$DIMENSIONE" "$NOME")

echo "Nome link generato: $LINK_NAME"

# 4. Creazione Link
ln -s "$NOME" "$LINK_NAME"

ls -l "$LINK_NAME"


# ------------------------------------------------------------------------------
# 7. DIFFERENZE CRITICHE LINUX VS MACOS (RIEPILOGO)
# ------------------------------------------------------------------------------
# Se usi i comandi Linux all'esame su Mac, lo script fallisce.

# OBIETTIVO           | LINUX (GNU)         | MACOS (BSD)
# ------------------- | ------------------- | -------------------
# Dimensione Byte     | stat -c %s file     | stat -f %z file
# Numero Inode        | stat -c %i file     | stat -f %i file
# Permessi Ottali     | stat -c %a file     | stat -f %Lp file
# Trova stesso file   | find -samefile      | find -samefile (OK)
# Trova per Inode     | find -inum          | find -inum (OK)
# Dimensione in Find  | find -size +1k      | find -size +1k (OK)


# ==============================================================================
# 💡 SCRIPT COMPLETO: SOLUZIONE ESAME 35 (Esercizio 1)
# ==============================================================================
# "Script che prende N come parametro e crea N soft link ai file più grandi"
# Ecco come si scrive davvero.

# !/bin/bash
# N=$1
# if [ -z "$N" ]; then N=1; fi
#
# # find . -type f            -> Trova file
# # stat -f "%z %N"           -> Stampa "BYTES NOME" (Specifico Mac)
# # sort -nr                  -> Ordina numerico decrescente (i più grandi su)
# # head -n $N                -> Prendi i primi N
#
# find . -type f -exec stat -f "%z %N" {} + | sort -nr | head -n "$N" | while read size nome; do
#     # Pulisci il nome (stat %N su mac a volte mette virgolette? No, ma path relativo sì)
#     base=$(basename "$nome")
#     
#     # Crea il nome del link (12 cifre)
#     linkname=$(printf "%012d-%s" "$size" "$base")
#     
#     echo "Creo link $linkname -> $nome"
#     ln -s "$nome" "$linkname"
# done

# Nota: Questo snippet sopra usa 'stat' dentro find che è molto efficiente su Mac.