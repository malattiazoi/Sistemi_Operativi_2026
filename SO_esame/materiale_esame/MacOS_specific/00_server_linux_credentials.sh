#!/bin/bash

# ==============================================================================
# CONFIGURAZIONE (Modifica questi dati il giorno dell'esame)
# ==============================================================================
USER="mlazoi814"
IP="10.0.14.23"
REMOTE_DIR="/home/mlazoi814"
#PASSWORD: la stessa del Lenovo con Ubuntu

# NOME CARTELLA E ZIP (Se il prof dice un altro nome, cambialo qui)
NOME_PROGETTO="esame_mlazoi"
DATA_OGGI=$(date "+%Y-%m-%d")
NOME_ZIP="esame_mlazoi_$DATA_OGGI.tar.gz"


# ==============================================================================
# FASE 1: CREAZIONE CARTELLA E PRIMO CARICAMENTO (Test Accesso)
# ==============================================================================
# 1. Crea la cartella
# mkdir $NOME_PROGETTO

# 2. Crea un file di test dentro la cartella
# touch $NOME_PROGETTO/test_connessione.txt

# 3. Zippa la cartella
# tar -cvzf $NOME_ZIP $NOME_PROGETTO

# 4. Verifica dimensione
# du -sh $NOME_ZIP

# 5. Carica sul server
# scp $NOME_ZIP $USER@$IP:$REMOTE_DIR

echo "--- COMANDI FASE 1 (TEST ACCESSO) ---"
echo "mkdir $NOME_PROGETTO"
echo "tar -cvzf $NOME_ZIP $NOME_PROGETTO"
echo "scp $NOME_ZIP $USER@$IP:$REMOTE_DIR"
echo -e "------------------------------------------------------------------\n"

# ==============================================================================
# FASE 2: CONSEGNA FINALE (Sovrascrittura e Ricaricamento)
# ==============================================================================
# Una volta finiti gli esercizi, copia i file .sh dentro la cartella $NOME_PROGETTO
# cp *.sh $NOME_PROGETTO/

# Poi ricrea lo zip (sovrascrive automaticamente quello vecchio)
# tar -cvzf $NOME_ZIP $NOME_PROGETTO

# Ricarica la versione definitiva
# scp $NOME_ZIP $USER@$IP:$REMOTE_DIR

echo "--- COMANDI FASE 2 (CONSEGNA FINALE) ---"
echo "cp *.sh $NOME_PROGETTO/"
echo "tar -cvzf $NOME_ZIP $NOME_PROGETTO"
echo "scp $NOME_ZIP $USER@$IP:$REMOTE_DIR"
echo -e "------------------------------------------------------------------\n"

# ==============================================================================
# ACCESSO RAPIDO SSH
# ==============================================================================
echo "--- ACCESSO AL SERVER ---"
echo "ssh $USER@$IP"