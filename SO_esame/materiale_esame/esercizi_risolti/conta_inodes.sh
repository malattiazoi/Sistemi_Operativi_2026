#!/bin/bash

# ------------------------------------------------------------------------------
# TRACCIA:
# Creare uno script chiamato "containodes" che conta il numero di inodes utilizzati 
# dal file system nel quale è stato salvato.
# ------------------------------------------------------------------------------

# 1. Individuare il file system corrente
# Il comando 'df' mostra le info del disco.
# Usiamo il flag -P (POSIX) per avere un output standard su Mac e Linux.
# L'output di 'df -iP .' sarà simile a:
# Filesystem      Inodes   IUsed   IFree %IUsed Mounted on
# /dev/disk1s1   4882452  123456 4758996    3% /

# 2. Estrazione dati
# awk 'NR==2': Prende solo la seconda riga (salta l'intestazione).
# {print $3}: Stampa la terza colonna (che nello standard POSIX è IUsed/Used Inodes).
INODES_USATI=$(df -iP . | awk 'NR==2 {print $3}')

echo "Inodes utilizzati nel file system corrente: $INODES_USATI"