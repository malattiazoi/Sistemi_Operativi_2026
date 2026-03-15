#!/bin/bash

# ==============================================================================
# MANUALE TASCABILE: BC (BASIC CALCULATOR)
# ==============================================================================
# SCOPO:
# Bash sa fare solo numeri interi (es. $((1+1))). 
# 'bc' serve per:
# 1. Numeri con la virgola (floating point).
# 2. Numeri giganti (più grandi di 64-bit).
# 3. Conversione Basi (Decimale <-> Esadecimale/Binario).
# ==============================================================================

# Per evitare esecuzioni accidentali se lanci questo file:
exit 0

# ------------------------------------------------------------------------------
# 1. MATEMATICA CON LA VIRGOLA (DIVISIONI)
# ------------------------------------------------------------------------------
# Di default bc taglia i decimali. Devi impostare la variabile 'scale'.

# ESEMPIO SBAGLIATO (Restituisce 2, perde lo 0.5)
echo "5 / 2" | bc

# ESEMPIO CORRETTO (Restituisce 2.50)
# scale=N definisce quante cifre vuoi dopo la virgola.
echo "scale=2; 5 / 2" | bc

# FUNZIONI MATEMATICHE AVANZATE
# Usa il flag -l per caricare la libreria matematica (seno, coseno, sqrt, ecc.)
# Esempio: Radice quadrata di 10
echo "scale=4; sqrt(10)" | bc -l


# ------------------------------------------------------------------------------
# 2. CONVERSIONE DECIMALE -> ESADECIMALE
# ------------------------------------------------------------------------------
# Utile per esercizi su Hash e Codifiche.
# obase = Output Base (La base in cui vuoi il risultato).
# tr -d ... = Pulisce eventuali backslash su numeri lunghi (line wrapping).

# Esempio: Convertire 255 in Hex (Risultato: FF)
echo "obase=16; 255" | bc | tr -d '\\\n'


# ------------------------------------------------------------------------------
# 3. CONVERSIONE ESADECIMALE -> DECIMALE
# ------------------------------------------------------------------------------
# Utile per decodificare stringhe.
# ibase = Input Base (La base del numero che gli passi).
# IMPORTANTE: L'input Hex deve essere MAIUSCOLO (FF, non ff).

# Esempio: Convertire FF in Decimale (Risultato: 255)
echo "ibase=16; FF" | bc

# Se hai una variabile minuscola, convertila prima:
HEX_VAR="ff"
echo "ibase=16; ${HEX_VAR^^}" | bc    # (Solo Bash 4.0+)
echo "ibase=16; $(echo "$HEX_VAR" | tr '[:lower:]' '[:upper:]')" | bc # (Compatibile Mac/Linux)


# ------------------------------------------------------------------------------
# 4. CONFRONTARE NUMERI CON LA VIRGOLA
# ------------------------------------------------------------------------------
# Bash non può fare: if [ 3.5 -gt 2.1 ]. BC sì.
# BC restituisce 1 se VERO, 0 se FALSO.

VAR1="3.5"
VAR2="2.1"

RISULTATO=$(echo "$VAR1 > $VAR2" | bc)

if [ "$RISULTATO" -eq 1 ]; then
    echo "Maggiore"
else
    echo "Minore o Uguale"
fi

# Operatori validi in bc:
# >   (Maggiore)
# <   (Minore)
# >=  (Maggiore o uguale)
# <=  (Minore o uguale)
# ==  (Uguale - nota il doppio uguale)
# !=  (Diverso)


# ------------------------------------------------------------------------------
# 5. TRAPPOLE E ERRORI COMUNI (DA RICORDARE ALL'ESAME)
# ------------------------------------------------------------------------------

# A. L'ORDINE DI OBASE E IBASE CONTA
# Se devi convertire basi strane, metti SEMPRE 'obase' PRIMA di 'ibase'.
# Altrimenti 'obase' viene interpretato nella base di 'ibase'.

# GIUSTO (Binario -> Hex):
echo "obase=16; ibase=2; 1010" | bc

# SBAGLIATO (bc legge obase=16 come se fosse scritto in binario):
echo "ibase=2; obase=16; 1010" | bc 


# B. NUMERI GIGANTI E BACKSLASH
# bc spezza le righe lunghe (oltre 70 caratteri) mettendo un '\' e andando a capo.
# Se devi usare il risultato in un altro comando (es. xxd), questo rompe tutto.
# SOLUZIONE: Aggiungi sempre '| tr -d '\\\n'' alla fine.

NUMERO_GIGANTE="10^100"
echo "$NUMERO_GIGANTE" | bc | tr -d '\\\n'


# C. ESADECIMALE MINUSCOLO
# bc non capisce 'aa' o 'ff'. Vuole 'AA' o 'FF'.
# Converti sempre prima di passare a bc.