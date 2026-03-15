#!/bin/bash

# ==============================================================================
# 50. ARCHIVIAZIONE E TRASFERIMENTO: TAR, GZIP, SSH, SCP
# ==============================================================================
# OBIETTIVO:
# 1. Creare archivi compressi (.tgz, .tar.gz) per la consegna esame.
# 2. Trasferire file tra Mac e Linux Server (SCP).
# 3. Collegarsi al server remoto (SSH).
#
# ATTENZIONE:
# Questa è la parte PIÙ CRITICA dell'esame. Se fallisce la consegna, il voto è 0.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. CREAZIONE ARCHIVI (TAR)
# ------------------------------------------------------------------------------
# Sintassi Esame Tipica: tar cvfz NOME.tgz CARTELLA
# c = Create (Crea nuovo archivio)
# v = Verbose (Mostra i file mentre li aggiunge)
# f = File (Specifica il nome del file archivio)
# z = Gzip (Comprimi con algoritmo gzip)

echo "--- 1. ARCHIVIAZIONE (TAR) ---"

DIR_DA_CONSEGNARE="mario.esame123"
mkdir -p "$DIR_DA_CONSEGNARE"
touch "$DIR_DA_CONSEGNARE/esercizio1.sh"

NOME_ARCHIVIO="$USER.esame123.tgz"

echo "Creo archivio '$NOME_ARCHIVIO' dalla cartella '$DIR_DA_CONSEGNARE'..."

# NOTA FONDAMENTALE:
# Esegui tar stando nella cartella PADRE, non dentro la cartella stessa.
# Altrimenti l'archivio conterrà percorsi strani o sarà vuoto.

tar cvfz "$NOME_ARCHIVIO" "$DIR_DA_CONSEGNARE"

echo "Verifica contenuto archivio (senza estrarre):"
# t = List (Test/Table of contents)
tar tvf "$NOME_ARCHIVIO"


# ------------------------------------------------------------------------------
# 2. ESTRAZIONE ARCHIVI
# ------------------------------------------------------------------------------
# x = Extract (Estrai)
# Se scarichi un file .tgz o .tar.gz, usa questo.

echo "----------------------------------------------------------------"
echo "--- 2. ESTRAZIONE ---"

# tar xvfz "$NOME_ARCHIVIO"


# ------------------------------------------------------------------------------
# 3. TRASFERIMENTO FILE (SCP)
# ------------------------------------------------------------------------------
# SCP (Secure Copy) funziona come cp, ma attraverso la rete.
# Sintassi: scp [OPZIONI] SORGENTE DESTINAZIONE
#
# Indirizzo Server Esame tipico: 10.0.14.23
# Utente: tuousername

echo "----------------------------------------------------------------"
echo "--- 3. SCP (SECURE COPY) ---"

REMOTE_USER="tuousername"
REMOTE_HOST="10.0.14.23"
REMOTE_DIR="~"  # Tilde = Home directory remota

# CASO A: UPLOAD (Dal mio Mac -> Al Server Linux)
# Copiare una CARTELLA intera (-r = Recursive)
# scp -r "$DIR_DA_CONSEGNARE" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}"

# Copiare un FILE singolo
# scp "$NOME_ARCHIVIO" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}"


# CASO B: DOWNLOAD (Dal Server Linux -> Al mio Mac)
# La sintassi si inverte: PRIMA il remoto, POI il locale (.).
# scp -r "${REMOTE_USER}@${REMOTE_HOST}:cartella_remota" .


# ------------------------------------------------------------------------------
# 4. CONNESSIONE REMOTA (SSH)
# ------------------------------------------------------------------------------
# Per lavorare direttamente sul server Linux (es. per dare il comando tar finale).

echo "----------------------------------------------------------------"
echo "--- 4. SSH (SECURE SHELL) ---"

# ssh "${REMOTE_USER}@${REMOTE_HOST}"

# Una volta dentro, sei su Linux. I comandi sono gli stessi visti finora
# (ls, cd, tar, ecc.).
# Per uscire: exit


# ------------------------------------------------------------------------------
# 5. ZIP E UNZIP (FORMATO ALTERNATIVO)
# ------------------------------------------------------------------------------
# A volte capita di dover gestire file .zip invece di .tar.gz.

echo "----------------------------------------------------------------"
echo "--- 5. ZIP / UNZIP ---"

# Creare zip
# zip -r archivio.zip cartella/

# Estrarre zip
# unzip archivio.zip

# Listare contenuto zip senza estrarre
# unzip -l archivio.zip


# ==============================================================================
# ⚠️ CHECKLIST CONSEGNA ESAME
# ==============================================================================
# 1. Ho creato la cartella "nome.esameX"? [SI/NO]
# 2. Ho messo dentro il file "leggimi.txt"? [SI/NO]
# 3. Gli script hanno i permessi +x? (chmod +x *.sh) [SI/NO]
# 4. Ho trasferito la cartella su Linux? (scp -r ...) [SI/NO]
# 5. Mi sono collegato a Linux? (ssh ...) [SI/NO]
# 6. Ho creato il tar finale SU LINUX? (tar cvfz ...) [SI/NO]

# Pulizia
rm -rf "$DIR_DA_CONSEGNARE" "$NOME_ARCHIVIO"
echo "----------------------------------------------------------------"
echo "Tutorial 50 (Consegna) Completato."