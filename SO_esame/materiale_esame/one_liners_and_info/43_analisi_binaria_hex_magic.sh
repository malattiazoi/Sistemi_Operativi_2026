#!/bin/bash

# ==============================================================================
# 43. ANALISI BINARIA, MAGIC BYTES E CONVERSIONI (MACOS)
# ==============================================================================
# OBIETTIVO:
# 1. Identificare file dal CONTENUTO (Magic Bytes) e non dall'estensione.
# 2. Convertire dati tra Decimale, Esadecimale e ASCII.
#
# UTILIZZO NEGLI ESAMI:
# - ESAME 191d: "Conta file che iniziano con hex 255044462d (PDF)".
# - ESAME 191b: "Decodifica questa stringa numerica in testo".
# - ESAME 62/191a: Brute force e confronto Hash.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. LEGGERE L'HEADER DI UN FILE (MAGIC BYTES)
# ------------------------------------------------------------------------------
# I primi byte di un file identificano il formato.
# PDF inizia con: %PDF- (Hex: 25 50 44 46 2d)
# PNG inizia con: .PNG (Hex: 89 50 4e 47)

echo "--- 1. ANALISI HEADER (XXD) ---"

# Creiamo un finto PDF
printf "%PDF-1.4...fake content" > documento.pdf

# 1.1 Visualizzare i primi byte in HEX
# head -c N: Prende i primi N byte.
# xxd -p: Converte in esadecimale puro (Plain).
HEADER=$(head -c 5 documento.pdf | xxd -p)
echo "Header Hex del file: $HEADER"

# 1.2 Confronto (SOLUZIONE ESAME 191d)
TARGET_SIG="255044462d" # Firma PDF data dalla traccia

if [ "$HEADER" == "$TARGET_SIG" ]; then
    echo "Match! Questo è un file PDF."
else
    echo "Nessun match."
fi


# ------------------------------------------------------------------------------
# 2. CONVERSIONE NUMERO -> TESTO (DECIMALE TO ASCII)
# ------------------------------------------------------------------------------
# Esame 191b ci dà un numero enorme (es. 10669...) e dice che è testo.
# Bisogna convertirlo in Hex e poi in ASCII.

echo "----------------------------------------------------------------"
echo "--- 2. DECIMAL TO ASCII (BC + XXD) ---"

DECIMAL_INPUT="1262573229" # Esempio (equivale a "KKOO" in ascii)

# PASSO 1: Convertire Decimale -> Hex
# Usiamo 'bc' (Calculator) impostando obase=16 (Output Base Hex).
HEX_VAL=$(echo "obase=16; $DECIMAL_INPUT" | bc)
echo "Valore Hex: $HEX_VAL"

# PASSO 2: Convertire Hex -> ASCII (Caratteri stampabili)
# xxd -r -p fa il reverse (da hex plain a binario/testo).
# Attenzione: 'bc' outputta maiuscolo, xxd lo gestisce bene.
TEXT_OUTPUT=$(echo "$HEX_VAL" | xxd -r -p)
echo "Testo Decodificato: $TEXT_OUTPUT"

# Funzione completa per Esame 191b
decode_decimal() {
    INPUT=$1
    # bc converte, xxd -r -p stampa i caratteri
    echo "obase=16; $INPUT" | bc | xxd -r -p
    echo "" # Newline finale
}


# ------------------------------------------------------------------------------
# 3. RICERCA FILE PER MAGIC BYTES (SCRIPT COMPLETO)
# ------------------------------------------------------------------------------
# Esame 191d chiede di cercare in una directory ricorsivamente.
# Non possiamo usare 'file', dobbiamo verificare i byte grezzi.

echo "----------------------------------------------------------------"
echo "--- 3. SCANNER MAGIC BYTES (RECURSIVE) ---"

# Simuliamo struttura
mkdir -p test_scan/sub
cp documento.pdf test_scan/sub/doc1.pdf
touch test_scan/fake.txt

MAGIC="255044462d"
COUNT=0

# Loop su tutti i file (-type f) trovati da find
# Nota: Usiamo while read per gestire spazi nei nomi
while IFS= read -r -d '' FILE; do
    # Leggiamo i primi 5 byte (10 caratteri hex per il PDF)
    # Calcoliamo quanti byte leggere: 1 byte = 2 char hex.
    # La firma è lunga 10 char -> 5 byte.
    CURRENT_SIG=$(head -c 5 "$FILE" | xxd -p)
    
    if [ "$CURRENT_SIG" == "$MAGIC" ]; then
        echo "Trovato PDF: $FILE"
        ((COUNT++))
    fi
done < <(find test_scan -type f -print0)

echo "Totale PDF trovati: $COUNT"


# ------------------------------------------------------------------------------
# 4. GENERAZIONE BRUTE FORCE (MD5 MATCHING)
# ------------------------------------------------------------------------------
# Esame 191a: "Trova una stringa il cui MD5 inizia con XX".
# Bisogna provare stringhe a caso finché non esce l'hash giusto.

echo "----------------------------------------------------------------"
echo "--- 4. BRUTE FORCE HASH ---"

TARGET_PREFIX="8b" # Esempio: Cerchiamo hash che inizia con 8b
FOUND=0
I=0

echo "Cerco stringa con MD5 che inizia per $TARGET_PREFIX..."

# Loop limitato per evitare blocco tutorial
while [ $I -lt 1000 ]; do
    # Generiamo stringa candidata (es. numero progressivo)
    CANDIDATE="$I"
    
    # Calcoliamo MD5 (su Mac md5 -q)
    HASH=$(md5 -q -s "$CANDIDATE")
    
    # Controlliamo se inizia con il target
    # ${HASH:0:2} prende i primi 2 caratteri
    if [ "${HASH:0:2}" == "$TARGET_PREFIX" ]; then
        echo "TROVATO!"
        echo "Stringa: $CANDIDATE"
        echo "Hash:    $HASH"
        FOUND=1
        break
    fi
    ((I++))
done

if [ $FOUND -eq 0 ]; then
    echo "Non trovato in 1000 tentativi (Normale in un test breve)."
fi


# ==============================================================================
# ⚠️ STRUMENTI FONDAMENTALI
# ==============================================================================
# | COMANDO          | DESCRIZIONE                                       |
# |------------------|---------------------------------------------------|
# | head -c N        | Legge solo i primi N byte del file.               |
# | xxd -p           | Dump esadecimale continuo (senza indirizzi).      |
# | xxd -r -p        | Reverse: Da Hex a Testo/Binario.                  |
# | bc               | Calcolatrice. 'obase=16' converte in Hex.         |
# | md5 -q -s "str"  | Calcola hash di una stringa (veloce).             |
# | od -t x1         | Alternativa a xxd (Octal Dump in Hex mode).       |

# Pulizia
rm -f documento.pdf
rm -rf test_scan
echo "----------------------------------------------------------------"
echo "Tutorial 43 (Binary/Hex) Completato."