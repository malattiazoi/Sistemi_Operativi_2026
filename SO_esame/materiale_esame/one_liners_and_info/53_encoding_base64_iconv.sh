#!/bin/bash

# ==============================================================================
# 53. ENCODING: BASE64 E ICONV (MACOS)
# ==============================================================================
# OBIETTIVO:
# 1. Codificare e Decodificare dati in Base64 (comune in crypto e web).
# 2. Convertire file tra set di caratteri diversi (es. ISO-8859-1 -> UTF-8).
#
# DIFFERENZE MACOS (BSD) vs LINUX:
# - Linux: base64 -d (decode)
# - macOS: base64 -D (decode - D maiuscola!) - OCCHIO A QUESTO DETTAGLIO!
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. BASE64 (ENCODE / DECODE)
# ------------------------------------------------------------------------------
# Trasforma dati binari o testo in caratteri ASCII stampabili (A-Z, a-z, 0-9, +, /).

echo "--- 1. BASE64 ---"

STRINGA="Ciao Mondo"

# 1.1 Encode
# echo -n evita il newline finale che cambierebbe l'hash/base64
ENCODED=$(echo -n "$STRINGA" | base64)
echo "Stringa: $STRINGA"
echo "Base64 : $ENCODED"

# 1.2 Decode (ATTENZIONE AL FLAG SU MAC)
# Prova il flag -D (Mac) o -d (Linux) dinamicamente
if base64 -h 2>&1 | grep -q "\-D"; then
    DECODE_FLAG="-D"  # Siamo su Mac
else
    DECODE_FLAG="-d"  # Siamo su Linux
fi

DECODED=$(echo "$ENCODED" | base64 $DECODE_FLAG)
echo "Decoded: $DECODED"


# ------------------------------------------------------------------------------
# 2. ICONV (CONVERSIONE CARATTERI)
# ------------------------------------------------------------------------------
# Le slide mostrano file con caratteri strani se la codifica è errata.
# iconv -f DA -t A file

echo "----------------------------------------------------------------"
echo "--- 2. ICONV ---"

# Creiamo un file UTF-8 (Standard moderno)
echo "Città: èòàù" > utf8.txt

# Simuliamo un file vecchio (ISO-8859-1 / Latin1)
iconv -f UTF-8 -t ISO-8859-1 utf8.txt > latin1.txt

echo "File Latin1 letto come UTF-8 (Dovrebbe essere rotto o strano):"
cat latin1.txt

echo "Conversione corretta (Ripristino):"
iconv -f ISO-8859-1 -t UTF-8 latin1.txt


# ------------------------------------------------------------------------------
# 3. XXD (HEX DUMP) - RIPASSO
# ------------------------------------------------------------------------------
# Spesso usato insieme a base64.
# xxd crea un dump esadecimale. xxd -r torna indietro.

echo "----------------------------------------------------------------"
echo "--- 3. XXD ---"
echo "ABC" | xxd


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI
# ==============================================================================
# | COMANDO | FLAG (MAC) | FLAG (LINUX) | AZIONE                           |
# |---------|------------|--------------|----------------------------------|
# | base64  | -D         | -d           | Decodifica stringa Base64.       |
# | base64  | (nessuno)  | (nessuno)    | Codifica (Default).              |
# | iconv   | -f         | -f           | From (Codifica sorgente).        |
# | iconv   | -t         | -t           | To (Codifica destinazione).      |
# | iconv   | -l         | -l           | List (Lista codifiche note).     |

# Pulizia
rm -f utf8.txt latin1.txt
echo "----------------------------------------------------------------"
echo "Tutorial 53 Completato."