#!/bin/bash

# ==============================================================================
# 48. GENERARE SEQUENZE: IL COMANDO SEQ (MACOS / GNU)
# ==============================================================================
# OBIETTIVO:
# Generare liste di numeri per cicli for, creazione file massiva o calcoli.
#
# SINTASSI:
# 1. seq LAST        (da 1 a LAST)
# 2. seq FIRST LAST  (da FIRST a LAST)
# 3. seq FIRST STEP LAST (con salto/incremento)
#
# FORMATTAZIONE:
# Fondamentale l'uso di -f o -w per creare file ordinati (file_01, file_02...).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. UTILIZZO BASE
# ------------------------------------------------------------------------------

echo "--- 1. SEQ BASE ---"

echo "Contare fino a 3:"
seq 3

echo "Contare da 5 a 8:"
seq 5 8

echo "Contare dispari (Step 2) da 1 a 10:"
# Start=1, Step=2, End=10
seq 1 2 10

echo "Conto alla rovescia (Step Negativo):"
seq 5 -1 1


# ------------------------------------------------------------------------------
# 2. FORMATTAZIONE E PADDING (-w, -f) - CRITICO ESAME 35
# ------------------------------------------------------------------------------
# Se crei file 1.txt ... 10.txt, l'ordinamento sarà 1, 10, 2, 3... Sbagliato.
# Devi creare 01.txt ... 10.txt.

echo "----------------------------------------------------------------"
echo "--- 2. FORMATTAZIONE (PADDING) ---"

# METODO A: Larghezza Fissa (-w)
# Aggiunge zeri automaticamente per pareggiare la larghezza del numero più grande.
echo "Padding automatico (-w) fino a 100:"
seq -w 98 100
# Output: 098, 099, 100

# METODO B: Formattazione Printf (-f)
# Più potente. %g è il numero. %03g significa "3 cifre con zeri".
# Puoi aggiungere testo attorno.
echo "Formattazione avanzata (-f):"
seq -f "immagine_%03g.jpg" 1 3


# ------------------------------------------------------------------------------
# 3. SEPARATORI (-s)
# ------------------------------------------------------------------------------
# Di default seq va a capo (\n). Puoi cambiare il separatore.
# Utile per creare liste CSV o stringhe lunghe.

echo "----------------------------------------------------------------"
echo "--- 3. SEPARATORI ---"

echo "Lista orizzontale (spazio):"
seq -s " " 1 5

echo "Lista CSV (virgola):"
seq -s "," 1 5


# ------------------------------------------------------------------------------
# 4. UTILIZZO NEI CICLI FOR
# ------------------------------------------------------------------------------
# Il caso d'uso principale negli script.

echo "----------------------------------------------------------------"
echo "--- 4. SEQ NEI LOOP ---"

# Esempio: Pingare 3 IP in sequenza
# Nota: $(...) esegue il comando e sostituisce l'output.
for I in $(seq 1 3); do
    IP="192.168.1.$I"
    echo "Simulazione Ping verso $IP..."
done


# ==============================================================================
# 5. DECIMAL/FLOAT SEQUENCES
# ==============================================================================
# seq supporta i numeri con la virgola (punto).

echo "----------------------------------------------------------------"
echo "--- 5. DECIMALI ---"

echo "Incremento 0.5:"
seq 0 0.5 1.5


# ==============================================================================
# ⚠️ TABELLA FLAG (SEQ)
# ==============================================================================
# | FLAG | SIGNIFICATO                                     |
# |------|-------------------------------------------------|
# | -w   | Equal width (Padding automatico con zeri).      |
# | -f   | Format (stile printf, es. "%03g").              |
# | -s   | Separator (cambia il newline con altro char).   |

echo "----------------------------------------------------------------"
echo "Tutorial 48 (Seq) Completato."