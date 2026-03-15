#!/bin/bash

# ==============================================================================
# 39. MATEMATICA E CALCOLI: INTERI, DECIMALI (BC) E DATE (MACOS)
# ==============================================================================
# OBIETTIVO:
# Bash nativamente supporta solo numeri INTERI.
# Per decimali (float) serve 'bc' (Basic Calculator).
# Per calcoli su date (differenza giorni/secondi), serve 'date' (versione BSD).
#
# SCENARI ESAME:
# 1. "Calcola la percentuale di spazio occupato" (Divisione).
# 2. "Calcola la media della memoria usata" (Decimali).
# 3. "Lo script deve girare per esattamente 1 ora" (Calcoli tempo).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. ARITMETICA INTERA (BUILT-IN $((...)))
# ------------------------------------------------------------------------------
# È il metodo più veloce e sicuro per contatori e matematica semplice.
# NON supporta la virgola (es. 10/3 fa 3, non 3.33).

echo "--- 1. Aritmetica Intera ---"

A=10
B=3

# Somma, Sottrazione, Moltiplicazione
SOMMA=$((A + B))
MOLT=$((A * B))

# Divisione Intera (Tronca il decimale)
DIV=$((A / B))
# Modulo (Resto della divisione) - Utile per "ogni N righe"
RESTO=$((A % B))

echo "$A + $B = $SOMMA"
echo "$A / $B = $DIV con resto $RESTO"

# Incremento variabile (stile C)
((A++))  # A diventa 11
echo "A incrementato: $A"

# Incremento in un passo
((A+=5)) # A diventa 16
echo "A + 5: $A"


# ------------------------------------------------------------------------------
# 2. ARITMETICA DECIMALE / FLOATING POINT (BC)
# ------------------------------------------------------------------------------
# Se devi calcolare percentuali o medie precise, DEVI usare 'bc'.
# Sintassi: echo "operazione" | bc

echo "--- 2. Aritmetica Decimale (bc) ---"

# Divisione semplice (bc di default tronca se non imposti 'scale')
echo "10 / 3 senza scale:"
echo "10 / 3" | bc

# Divisione con decimali (scale=N imposta N cifre dopo la virgola)
MEDIA=$(echo "scale=2; 10 / 3" | bc)
echo "10 / 3 con scale=2: $MEDIA"

# Confronto numeri decimali (bc restituisce 1 se Vero, 0 se Falso)
# Bash non può fare: if [ 3.5 -gt 2.0 ] (Dà errore integer expression expected)
VALORE=3.5
SOGLIA=2.0

# Trucco: Chiediamo a bc se è vero.
CHECK=$(echo "$VALORE > $SOGLIA" | bc)

if [ "$CHECK" -eq 1 ]; then
    echo "Check OK: $VALORE è maggiore di $SOGLIA"
else
    echo "Check FALLITO"
fi


# ------------------------------------------------------------------------------
# 3. COMANDO EXPR (LEGACY / COMPATIBILITÀ)
# ------------------------------------------------------------------------------
# Vecchio metodo, meno efficiente di $(()). Utile solo se richiesto esplicitamente.
# Attenzione: bisogna escapare il per (\*) e lasciare spazi tra operatori.

echo "--- 3. Comando Expr ---"
RES=$(expr 5 \* 2)
echo "5 * 2 con expr = $RES"


# ------------------------------------------------------------------------------
# 4. CALCOLI CON LE DATE (MACOS BSD DATE) - CRITICO
# ------------------------------------------------------------------------------
# Problema: "Calcola quanti secondi sono passati da ieri".
# Linux usa: date -d "yesterday"
# MacOS usa: date -v-1d (Adjust value)
#
# CONCETTO CHIAVE: TIMESTAMP (EPOCH)
# È il numero di secondi passati dal 1 Gennaio 1970.
# L'unico modo per fare matematica col tempo è convertire tutto in secondi.

echo "--- 4. Calcoli Temporali (BSD date) ---"

# 4.1 Ottenere timestamp attuale
NOW=$(date +%s)
echo "Timestamp attuale: $NOW"

# 4.2 Data nel passato/futuro (Flag -v)
# -v+1d = Domani
# -v-1H = Un'ora fa
IERI=$(date -v-1d +%s)
echo "Timestamp ieri: $IERI"

# Differenza in secondi (Quanto dura un giorno?)
DIFF=$((NOW - IERI))
echo "Secondi in un giorno: $DIFF"

# 4.3 Convertire una data specifica in secondi (Flag -j -f)
# Scenario Esame: "Quanti giorni sono passati dal 25 Dicembre 2023?"
# -j : Non provare a settare l'orologio (solo calcolo).
# -f : Formato di input (es. "%Y-%m-%d").
TARGET_DATE="2023-12-25"
TARGET_TS=$(date -j -f "%Y-%m-%d" "$TARGET_DATE" "+%s")

SECONDI_PASSATI=$((NOW - TARGET_TS))
GIORNI_PASSATI=$((SECONDI_PASSATI / 86400)) # 86400 secondi in un giorno

echo "Dal $TARGET_DATE sono passati $GIORNI_PASSATI giorni."


# ------------------------------------------------------------------------------
# 5. GENERARE NUMERI CASUALI (RANDOM)
# ------------------------------------------------------------------------------
# Utile per creare file di test o aspettare tempi random.

echo "--- 5. Numeri Random ---"

# $RANDOM restituisce un intero tra 0 e 32767.
R=$RANDOM
echo "Numero random grezzo: $R"

# Random tra 0 e 10
R_10=$((RANDOM % 11))
echo "Random 0-10: $R_10"

# Random in un range (es. 50-100)
# Formula: (RANDOM % (MAX-MIN+1)) + MIN
MIN=50
MAX=100
R_RANGE=$(( (RANDOM % (MAX-MIN+1)) + MIN ))
echo "Random 50-100: $R_RANGE"


# ==============================================================================
# 🧩 SCENARIO ESAME: CALCOLO TEMPO DI ESECUZIONE SCRIPT
# ==============================================================================
# Traccia: "Lo script deve stampare alla fine quanto tempo ha impiegato"

START_TIME=$(date +%s)

# Simuliamo lavoro (sleep)
sleep 1

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo "Operazione completata in $ELAPSED secondi."


# ==============================================================================
# 🧩 SCENARIO ESAME: MEDIA CONSUMO RISORSE
# ==============================================================================
# Traccia: "Dato un file con valori di CPU, calcolare la media"
# File: 10.5, 20.0, 5.5

echo "--- Calcolo Media CPU ---"
# Creiamo dati dummy
printf "10.5\n20.0\n5.5\n" > cpu.log

# Somma con AWK (più semplice per i file)
# Ma se dobbiamo farlo con shell pura e bc:

SOMMA=0
COUNT=0

while read VALORE; do
    # Bc serve per sommare float
    SOMMA=$(echo "$SOMMA + $VALORE" | bc)
    ((COUNT++))
done < cpu.log

# Calcolo media finale
MEDIA=$(echo "scale=2; $SOMMA / $COUNT" | bc)
echo "Totale: $SOMMA - Elementi: $COUNT - Media: $MEDIA"


# ==============================================================================
# ⚠️ TABELLA SINTASSI VITALE (MACOS)
# ==============================================================================
# | OPERAZIONE           | COMANDO / SINTASSI                     |
# |----------------------|----------------------------------------|
# | Interi               | $(( A + B ))                           |
# | Decimali             | echo "scale=2; 10/3" \| bc             |
# | Confronto Decimali   | echo "3.5 > 2" \| bc (1=Vero, 0=Falso) |
# | Timestamp Oggi       | date +%s                               |
# | Ieri (Mac)           | date -v-1d +%s                         |
# | Data Specifica (Mac) | date -j -f "%Y-%m-%d" "2024-01-01" +%s |
# | Random (Range)       | $(( (RANDOM % Range) + Min ))          |

# Pulizia
rm -f cpu.log