#!/bin/bash

# ==============================================================================
# 32. GUIDA UNIVERSALE ALLE CODIFICHE (BASE64, HEX, CHARSETS) - MACOS
# ==============================================================================
# OBIETTIVO:
# Gestire qualsiasi richiesta di trasformazione dati: da binario a testo,
# cambio di set di caratteri, analisi di file corrotti o "strani".
#
# AMBIENTE: macOS (BSD Tools)
# Le flag qui usate sono specifiche per Mac. Se usate su Linux potrebbero fallire.
# ==============================================================================

# ------------------------------------------------------------------------------
# CAPITOLO 1: BASE64 (IL RE DELLE CODIFICHE)
# ------------------------------------------------------------------------------
# COS'È: Un metodo per rappresentare dati binari (immagini, eseguibili)
# usando solo 64 caratteri ASCII sicuri (A-Z, a-z, 0-9, +, /).
# USO ESAME: "Trova la stringa nascosta encoded", "Trasmetti questo file via email".

# 1.1 CODIFICA DI UNA STRINGA
# Nota: echo -n serve per non codificare anche il carattere "a capo" finale.
echo -n "SegretoEsame" | base64

# 1.2 DECODIFICA DI UNA STRINGA (FLAG -D su Mac)
# ATTENZIONE: Su Linux è -d. Su Mac è -D (Maiuscolo).
echo "U2VncmV0b0VzYW1l" | base64 -D

# 1.3 CODIFICA DI UN INTERO FILE
# Crea un file di output testuale che rappresenta il binario.
# L'opzione -i (input) e -o (output) è specifica BSD/Mac.
base64 -i immagine.jpg -o immagine_encoded.txt

# 1.4 DECODIFICA DI UN FILE
base64 -D -i immagine_encoded.txt -o immagine_ripristinata.jpg

# 1.5 DEBUGGING BASE64 (BREAK LINES)
# A volte le stringhe lunghe vengono spezzate. Per decodificare stream continui:
# base64 -D -i file_lungo.txt


# ------------------------------------------------------------------------------
# CAPITOLO 2: HEXADECIMAL (XXD E HEXDUMP)
# ------------------------------------------------------------------------------
# COS'È: Ogni byte viene rappresentato da 2 caratteri esadecimali (0-F).
# USO ESAME: "Analizza l'header del file", "Cerca byte nascosti".

# 2.1 CREARE UN DUMP ESADECIMALE
# Mostra offset, byte hex e rappresentazione ASCII a lato.
xxd file_da_analizzare.bin

# 2.2 DUMP PURO (SOLO ESADECIMALE, SENZA INDIRIZZI)
# Utile per script che devono cercare pattern specifici.
xxd -p file_da_analizzare.bin

# 2.3 REVERSING (DA HEX A BINARIO)
# Hai una stringa hex e vuoi tornare al file originale.
echo "48656c6c6f" | xxd -r -p

# 2.4 HEXDUMP (ALTERNATIVA NATIVA)
# -C visualizza la modalità "Canonical" (Hex + ASCII).
hexdump -C file_da_analizzare.bin


# ------------------------------------------------------------------------------
# CAPITOLO 3: CHARACTER SETS E CONVERSIONI (ICONV)
# ------------------------------------------------------------------------------
# COS'È: Convertire file da Windows (ISO-8859-1) a Mac/Linux (UTF-8).
# USO ESAME: "Il file visualizza caratteri strani, correggilo".

# 3.1 IDENTIFICARE LA CODIFICA DI UN FILE
# ATTENZIONE: Su Mac il flag è -I (i maiuscola). Su Linux è -i.
file -I documento_strano.txt

# Output tipico:
# documento_strano.txt: text/plain; charset=iso-8859-1

# 3.2 CONVERTIRE DA ISO-8859-1 A UTF-8
# Sintassi: iconv -f SORGENTE -t DESTINAZIONE
iconv -f ISO-8859-1 -t UTF-8 documento_strano.txt > documento_fix.txt

# 3.3 ELENCARE TUTTE LE CODIFICHE SUPPORTATE
iconv -l

# 3.4 RIPARARE NOMI FILE (MAC NFD vs LINUX NFC)
# Se i nomi file hanno accenti "rotti", usa iconv sulle stringhe.
echo "nometrotto" | iconv -f UTF-8-MAC -t UTF-8


# ------------------------------------------------------------------------------
# CAPITOLO 4: URL ENCODING (PERCENT ENCODING)
# ------------------------------------------------------------------------------
# COS'È: Lo spazio diventa %20, @ diventa %40.
# USO ESAME: "Codifica questo parametro per una richiesta curl".

# Su Mac non c'è un comando 'urlencode' nativo. Si usa Python3 (preinstallato).

# 4.1 URL ENCODE
python3 -c "import urllib.parse; print(urllib.parse.quote('Mario Rossi & Co.'))"
# Output: Mario%20Rossi%20%26%20Co.

# 4.2 URL DECODE
python3 -c "import urllib.parse; print(urllib.parse.unquote('Mario%20Rossi%26Co.'))"


# ------------------------------------------------------------------------------
# CAPITOLO 5: LINE ENDINGS (DOS vs UNIX)
# ------------------------------------------------------------------------------
# COS'È: Windows usa CRLF (\r\n), Mac/Linux usano LF (\n).
# USO ESAME: "Lo script bash non parte e dà errore interpret".

# 5.1 VEDERE I CARATTERI NASCOSTI
# cat -e (su Mac mostra $ a fine riga, ma non sempre \r in modo chiaro)
# Meglio usare 'od -c' (Octal Dump a caratteri)
od -c script_win.sh
# Se vedi '\r' '\n', è formato DOS.

# 5.2 CONVERTIRE DA DOS A MAC (SENZA DOS2UNIX)
# Spesso 'dos2unix' non è installato all'esame. Usa 'tr'.
# Rimuove (delete) il carattere Carriage Return (\r).
tr -d '\r' < script_win.sh > script_mac.sh


# ------------------------------------------------------------------------------
# CAPITOLO 6: CIFRARI A SOSTITUZIONE (ROT13 / CAESAR)
# ------------------------------------------------------------------------------
# COS'È: Spostare le lettere di N posizioni. Rot13 sposta di 13.
# USO ESAME: "Decodifica questo messaggio offuscato semplice".

# 6.1 ROT13 (A->N, B->O...)
echo "Cebina" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
# Output: Prova


# ==============================================================================
# 🧩 SCENARI COMPLESSI D'ESAME (SCRIPT PRONTI)
# ==============================================================================

# SCENARIO A: "Trova tutti i file che contengono la stringa 'CIAO' codificata in Base64"
# ------------------------------------------------------------------------------
# Logica:
# 1. Codifico "CIAO" in Base64 -> "Q0lBTw=="
# 2. Cerco quella stringa dentro i file.
# Nota: Base64 ha padding (=), a volte la stringa cambia se non è allineata.
# Cerchiamo la parte "sicura" (Q0lBT).

TARGET_STR="CIAO"
B64_STR=$(echo -n "$TARGET_STR" | base64)
# Rimuoviamo il padding '=' finale per sicurezza nella ricerca
SEARCH_TERM=${B64_STR%=*}

echo "Cerco la stringa Base64: $SEARCH_TERM nei file..."
grep -r "$SEARCH_TERM" .


# SCENARIO B: "Decodifica un file che è stato codificato 10 volte in Base64"
# ------------------------------------------------------------------------------
# Logica: Loop while finché non smette di sembrare Base64 o per N volte.

cp file_super_encoded.txt temp.txt
for i in {1..10}; do
    base64 -D -i temp.txt -o temp_decoded.txt 2>/dev/null
    if [ $? -eq 0 ]; then
        mv temp_decoded.txt temp.txt
        echo "Livello $i decodificato..."
    else
        echo "Errore o fine decodifica al livello $i"
        break
    fi
done
cat temp.txt


# SCENARIO C: "Trova file con codifica ISO-8859-1 e convertili in UTF-8"
# ------------------------------------------------------------------------------
# Questo è un classico compito di "Sanitizzazione".

# 1. Trova i file (file -I outputta "charset=iso-8859-1")
# 2. Estrai il nome
# 3. Converti

find . -name "*.txt" -type f | while read file; do
    encoding=$(file -I "$file" | grep "iso-8859-1")
    if [ -n "$encoding" ]; then
        echo "Trovato file ISO: $file - Converto..."
        # Creo temp file
        iconv -f ISO-8859-1 -t UTF-8 "$file" > "${file}.utf8"
        # Sovrascrivo originale
        mv "${file}.utf8" "$file"
    fi
done


# SCENARIO D: "Cerca una sequenza di BYTE esadecimali specifica in file binari"
# ------------------------------------------------------------------------------
# Obiettivo: Trovare file che contengono la firma hex "FF D8 FF" (inizio JPEG).

SEQ_HEX="ffd8ff"

find . -type f | while read file; do
    # xxd -p crea un dump continuo. tr -d rimuove gli a capo.
    # grep -q silenzioso verifica se c'è la stringa.
    if xxd -p "$file" | tr -d '\n' | grep -q "$SEQ_HEX"; then
        echo "Il file $file contiene la sequenza JPEG header!"
    fi
done


# ==============================================================================
# 💡 RIASSUNTO FLAG VITALI (MACOS)
# ==============================================================================
# base64 -D       -> Decode (NON usare -d)
# base64 -i       -> Input file
# base64 -o       -> Output file
# file -I         -> Mime-type e Charset (NON usare -i)
# xxd -r          -> Reverse (da Hex a Binario)
# xxd -p          -> Plain (solo dump esadecimale continuo)
# iconv -l        -> List (lista codifiche disponibili)
# tr -d '\r'      -> Cancella i caratteri DOS (Carriage Return)