#!/bin/bash

# ==============================================================================
# 05. CODIFICHE, BASE64 E CONVERSIONI (MACOS EDITION)
# ==============================================================================
# OBIETTIVO:
# Trasformare i dati da un formato all'altro.
# Fondamentale per:
# 1. Base64: Trasformare file binari (img, zip) in testo trasmissibile.
# 2. Hex (Esadecimale): Analizzare file binari o corrotti.
# 3. Charsets: Convertire file da Windows (ISO-8859-1) a Mac (UTF-8).
# 4. Cifrari Semplici (ROT13): Risolvere l'Esame 23.
#
# AMBIENTE: macOS (BSD Tools)
# ATTENZIONE AI FLAG: Su Mac `base64` usa -D per decodificare (Linux usa -d).
# ==============================================================================

# Prepariamo file di test
echo "--- Creazione file di test ---"
echo "Messaggio Segreto" > segreto.txt
# Creiamo un file con caratteri accentati (encoding UTF-8 standard)
echo "Città: è, à, ò" > accenti.txt

# ==============================================================================
# PARTE 1: BASE64 (IL RE DELLE CODIFICHE)
# ==============================================================================
# Base64 converte QUALSIASI dato (anche binario) in caratteri ASCII stampabili
# (A-Z, a-z, 0-9, +, /).
# È reversibile al 100%. NON È CIFRATURA (non serve password).

echo "----------------------------------------------------------------"
echo "--- 1. BASE64 (Encoding/Decoding) ---"

# 1.1 CODIFICARE UNA STRINGA
# echo -n serve per non codificare il carattere "a capo" finale.
echo -n "Ciao Mondo" | base64
# Output: Q2lhbyBNb25kbw== (Il == finale è il padding tipico)

# 1.2 DECODIFICARE UNA STRINGA (FLAG -D)
# ATTENZIONE MACOS: Si usa -D (Maiuscolo). Su Linux è -d.
echo "Q2lhbyBNb25kbw==" | base64 -D
echo "" # A capo estetico

# 1.3 CODIFICARE UN FILE INTERO (-i, -o)
# Sintassi Mac: base64 -i INPUT -o OUTPUT
echo "Codifico segreto.txt..."
base64 -i segreto.txt -o segreto.b64

cat segreto.b64
# Output: TWVzc2FnZ2lvIFNlZ3JldG8K

# 1.4 DECODIFICARE UN FILE
# Sintassi Mac: base64 -D -i INPUT -o OUTPUT
base64 -D -i segreto.b64 -o segreto_decodificato.txt
cat segreto_decodificato.txt

# 1.5 DEBUGGING (STRINGHE SPEZZATE)
# A volte base64 spezza le righe lunghe (wrap).
# Per decodificare stream continui senza errori, l'opzione -D di solito gestisce
# automaticamente le righe, ma se hai problemi usa 'tr -d' per pulire i newline.
# cat file_sporco.b64 | tr -d '\n' | base64 -D


# ==============================================================================
# PARTE 2: ESADECIMALE (XXD E HEXDUMP)
# ==============================================================================
# Ogni byte viene rappresentato da 2 caratteri hex (00-FF).
# Utile per cercare pattern binari (es. cercare header di file JPG o PDF).

echo "----------------------------------------------------------------"
echo "--- 2. HEXADECIMAL (XXD) ---"

# 2.1 CREARE DUMP ESADECIMALE
# Mostra: Offset | Hex Bytes | ASCII Representation
xxd segreto.txt

# 2.2 DUMP PURO (SOLO HEX CONTINUO)
# Utile per script di ricerca (grep).
# -p = Plain (niente indirizzi, niente ASCII a lato)
xxd -p segreto.txt
# Output: 4d657373616767696f205365677265746f0a

# 2.3 REVERSING (DA HEX A BINARIO/TESTO)
# -r = Revert (Torna indietro)
# -p = Plain input
echo "4d6172696f" | xxd -r -p
echo "" # A capo

# 2.4 HEXDUMP (ALTERNATIVA NATIVA)
# -C = Canonical (Simile a xxd default)
hexdump -C segreto.txt


# ==============================================================================
# PARTE 3: CHARSETS E CONVERSIONI (ICONV e FILE)
# ==============================================================================
# Problema: Apri un file e vedi caratteri strani ().
# Causa: Il file è in ISO-8859-1 (Windows/Latin1) ma tu leggi in UTF-8.

echo "----------------------------------------------------------------"
echo "--- 3. CHARSETS E ICONV ---"

# 3.1 IDENTIFICARE LA CODIFICA (FILE)
# ATTENZIONE MACOS: Si usa il flag -I (i maiuscola). Su Linux è -i.
file -I accenti.txt
# Output atteso: text/plain; charset=utf-8

# 3.2 CONVERTIRE DA UTF-8 A ISO-8859-1
# iconv -f SORGENTE -t DESTINAZIONE
iconv -f UTF-8 -t ISO-8859-1 accenti.txt > accenti_iso.txt

# Verifichiamo il nuovo charset
file -I accenti_iso.txt
# Output atteso: text/plain; charset=iso-8859-1

# 3.3 RIPARARE UN FILE (DA ISO A UTF-8)
# Se trovi un file vecchio che si legge male, convertilo così:
iconv -f ISO-8859-1 -t UTF-8 accenti_iso.txt > accenti_fixed.txt

# 3.4 LISTA CODIFICHE DISPONIBILI
# iconv -l


# ==============================================================================
# PARTE 4: ROT13 E TR (SOLUZIONE ESAME 23)
# ==============================================================================
# ROT13 è un cifrario a sostituzione: A diventa N, B diventa O (+13 posizioni).
# Traccia Esame 23: "Trasformare A-M in N-Z e viceversa".

echo "----------------------------------------------------------------"
echo "--- 4. ROT13 (Cifrario Semplice) ---"

TESTO="Esame Superato"

# Mappatura:
# A-Z (Input)  -> N-ZA-M (Output: A->N ... N->A)
# a-z (Input)  -> n-za-m (Output: a->n ... n->a)

CIFRATO=$(echo "$TESTO" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
echo "Originale: $TESTO"
echo "Cifrato:   $CIFRATO"

# Decifrare (Riapplicare lo stesso comando)
DECIFRATO=$(echo "$CIFRATO" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
echo "Decifrato: $DECIFRATO"

# TRUCCO MACOS:
# tr su Mac è BSD e a volte non gradisce i range tipo [:upper:] nei mix complessi.
# Usa sempre 'A-Z' esplicito per sicurezza all'esame.


# ==============================================================================
# PARTE 5: URL ENCODING (PER SCRIPT CURL/WEB)
# ==============================================================================
# Se devi passare parametri a un URL, lo spazio diventa %20.
# Bash non ha un comando nativo 'urlencode', usiamo Python (sempre presente su Mac).

echo "----------------------------------------------------------------"
echo "--- 5. URL ENCODING (Python Helper) ---"

RAW="Mario Rossi & Co."

# Encode
ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$RAW'))")
echo "Encoded: $ENCODED"
# Output: Mario%20Rossi%20%26%20Co.

# Decode
DECODED=$(python3 -c "import urllib.parse; print(urllib.parse.unquote('$ENCODED'))")
echo "Decoded: $DECODED"


# ==============================================================================
# 🧩 ESEMPI PRATICI PER L'ESAME
# ==============================================================================

# SCENARIO A: "Trova la password nascosta in Base64 dentro un file di log"
# ------------------------------------------------------------------------
echo "--- Scenario A: Cerca & Decodifica ---"
# Creiamo un log finto
echo "Error: 404" > server.log
echo "AuthToken: c2VzYW1v" >> server.log # "sesamo" in b64

# 1. Grep trova la riga con AuthToken
# 2. Awk o Cut estrae la seconda parola (il token)
# 3. Base64 decodifica
TOKEN=$(grep "AuthToken" server.log | awk '{print $2}' | base64 -D)
echo "Il token decodificato è: $TOKEN"


# SCENARIO B: "Sanitizzazione nomi file (Mac NFD Problem)"
# ------------------------------------------------------------------------
# macOS usa una codifica Unicode decomposta (NFD) per i file (è + `).
# Linux usa composta (NFC) (è).
# Se uno script di confronto nomi fallisce, prova a normalizzare.

# echo "$NOME_FILE_MAC" | iconv -f UTF-8-MAC -t UTF-8
# (Questo trasforma il nome nel formato standard Linux-friendly)


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS)
# ==============================================================================
# | COMANDO | FLAG | SIGNIFICATO                                     |
# |---------|------|-------------------------------------------------|
# | base64  | -D   | Decode (Linux usa -d). FONDAMENTALE.            |
# | base64  | -i   | Input file.                                     |
# | base64  | -o   | Output file.                                    |
# | file    | -I   | Mostra Mime-Type e Charset (Linux usa -i).      |
# | xxd     | -p   | Plain dump (solo esadecimale continuo).         |
# | xxd     | -r   | Reverse (da Hex a Binario).                     |
# | tr      | -d   | Delete (cancella caratteri dal set).            |

# Pulizia
rm -f segreto* accenti* server.log
echo "----------------------------------------------------------------"
echo "Tutorial Codifiche Completato."

# ==============================================================================
# GUIDA AL COMANDO 'base64' (CODIFICA E DECODIFICA)
# ==============================================================================

# ------------------------------------------------------------------------------
# COS'È BASE64?
# Trasforma gruppi di 3 byte in 4 caratteri leggibili (A-Z, a-z, 0-9, +, /).
# Il simbolo '=' alla fine è il "padding" (serve a tappare i buchi se i dati
# non sono multipli di 3).
# ------------------------------------------------------------------------------

# 1. CODIFICARE TESTO SEMPLICE (da stringa a base64)
# Utile per nascondere velocemente una password o un dato in uno script.
echo "Ciao Studente" | base64
# Output previsto: Q2lhbyBTdHVkZW50ZQo=

# 2. DECODIFICARE (da base64 a testo)
# L'opzione --decode (o -d su molti sistemi) riporta al file originale.
echo "Q2lhbyBTdHVkZW50ZQo=" | base64 --decode

# ------------------------------------------------------------------------------
# OPERAZIONI SU FILE (Molto probabili in sede d'esame)
# ------------------------------------------------------------------------------

# 3. CODIFICARE UN FILE INTERO (es. un'immagine o un PDF)
# base64 nome_file.jpg > file_codificato.txt

# 4. DECODIFICARE UN FILE E SALVARLO
# base64 --decode file_codificato.txt > file_originale.jpg

# ------------------------------------------------------------------------------
# ATTENZIONE: DIFFERENZE MACOS (BSD) vs LINUX (GNU)
# ------------------------------------------------------------------------------
# Questo è un punto critico per l'esame se passi dal Mac al server Linux!

# Su LINUX (Server):
# - Per decodificare si usa: base64 -d  OPPURE  base64 --decode
# - Per andare a capo dopo N caratteri: base64 -w 0 (disabilita il wrapping)

# Su MACOS (Locale):
# - Per decodificare si usa: base64 -D (D maiuscola!) o base64 --decode
# - Per il wrapping si usa: base64 -b 0

# Integrità dati: A volte si usa base64 per "immergere" un piccolo file binario dentro 
# uno script Bash sotto forma di testo, per poi estrarlo con base64 --decode durante l'esecuzione.
# Esercizio di Pipeline: Spesso viene chiesto di leggere un file, filtrarlo con grep, ordinarlo con
# sort e infine codificare il risultato in base64.
# Esempio: cat utenti.txt | grep "admin" | base64