#!/bin/bash

# ==============================================================================
# 30. GUIDA A PRINTF, UNICODE E UTF-8 (GESTIONE CARATTERI)
# ==============================================================================
# FONTE: Appunti forniti + Adattamento critico per macOS (Bash 3.2 vs Zsh)
#
# DESCRIZIONE:
# Come stampare caratteri speciali, emoji e simboli matematici manipolando
# direttamente i "Code Points" (U+XXXX) o i byte esadecimali.
# Fondamentale per script che devono gestire input internazionali o binari.
# ==============================================================================

# ------------------------------------------------------------------------------
# ⚠️ AVVERTENZA IMPORTANTE PER UTENTI MACOS (BASH 3.2)
# ------------------------------------------------------------------------------
# Il comando `printf "\uXXXX"` funziona nativamente su Bash 4+ e Zsh.
# Sulla vecchia Bash 3.2 di default del Mac, spesso stampa letteralmente "\uXXXX".
#
# SOLUZIONE MACOS:
# Usa la sintassi ANSI-C Quoting: $'\uXXXX'
# Oppure usa /usr/bin/printf (il binario) invece del builtin.

echo "--- 1. STAMPARE CARATTERI TRAMITE CODE POINT (\u e \U) ---"

# Esempio 1: Code point a 4 cifre (es. é = U+00E9)
# Su Linux/Zsh: printf "\u00E9\n"
# Su MacOS Bash 3.2 (Metodo Sicuro):
printf $'\u00E9\n'

# Esempio 2: Code point a 8 cifre per EMOJI (es. 😀 = U+1F600)
# Le emoji risiedono fuori dal "Basic Multilingual Plane" (BMP).
printf $'\U0001F600\n'

# Regole (dal tuo file):
# - \u : vuole ESATTAMENTE 4 cifre esadecimali.
# - \U : vuole ESATTAMENTE 8 cifre esadecimali.
# - Le lettere A-F sono case-insensitive (A=a).


# ------------------------------------------------------------------------------
# 2. USARE VARIABILI PER I CODE POINT
# ------------------------------------------------------------------------------
# Non puoi scrivere "\u$var" direttamente in modo sicuro su tutte le shell.
# Bisogna formattare la stringa esadecimale.

codice_hex="00E9"  # La 'é'

# Metodo Avanzato: Costruire la stringa di escape dinamicamente
# %04X assicura che ci siano 4 cifre (padding con zeri)
printf "La variabile contiene: "
printf "\\u%04X\n" "0x$codice_hex"


# ------------------------------------------------------------------------------
# 3. OTTENERE IL CODE POINT DI UN CARATTERE (REVERSE LOOKUP)
# ------------------------------------------------------------------------------
# Bash ha una sintassi speciale: 'c (apice singolo + carattere)
# restituisce il valore numerico del carattere.

echo "--- Analisi Caratteri ---"

# ASCII Semplice ('A')
printf "Il codice decimale di A è: %d\n" "'A"

# Unicode Base ('é' -> U+00E9)
# %04X lo formatta come esadecimale a 4 cifre (stile U+XXXX)
printf "Il code point di é è: U+%04X\n" "'é"

# Nota: Questo metodo funziona bene per caratteri nel range U+0000 - U+00FF.
# Per caratteri multibyte (emoji) su Bash vecchia, il comportamento può variare.


# ------------------------------------------------------------------------------
# 4. LAVORARE DIRETTAMENTE CON I BYTE UTF-8
# ------------------------------------------------------------------------------
# A volte devi scrivere byte grezzi (raw bytes) invece di caratteri logici.

echo "--- Byte UTF-8 ---"

# A) ANALISI (Vedere i byte di un carattere)
# Usiamo 'hexdump -C' (Canonical hex+ASCII display) standard su Mac.
printf "é" | hexdump -C
# Output atteso per é in UTF-8: c3 a9

# B) GENERAZIONE (Scrivere byte esadecimali)
# Se sai che "é" è "C3 A9", puoi stamparlo così:

# Metodo con echo (flag -e abilita l'interpretazione dei backslash)
echo -e "\xC3\xA9"

# Metodo con printf (più portabile)
printf "\xC3\xA9\n"

# Esempio Euro (€) -> Code point U+20AC -> Byte UTF-8: E2 82 AC
printf "\xE2\x82\xAC\n"


# ------------------------------------------------------------------------------
# 5. ESEMPI DIDATTICI E AVANZATI
# ------------------------------------------------------------------------------

echo "--- Composizione e Emoji ---"

# 1. Caratteri Composti (Combining Characters)
# Stampiamo 'a' (U+0061) seguita dall'accento acuto combinante (U+0301)
# Visivamente sembra una sola lettera 'á', ma sono due code point.
printf $'\u0061\u0301\n'

# 2. Emoji (Richiede terminale che supporti UTF-8)
# Unicorno (U+1F984)
printf $'\U0001F984\n'

# 3. Simbolo Tedesco (Eszett ß) -> U+00DF
printf "Code point ß: U+%04X\n" "'ß"


# ==============================================================================
# ⚠️ SPECIFICA MACOS: NFD vs NFC (NORMALIZATION)
# ==============================================================================
# MacOS usa una normalizzazione Unicode chiamata NFD (Normalization Form Decomposed)
# per i nomi dei file.
#
# Se crei un file "caffè.txt" su Mac, il sistema lo salva come:
# caff + e + ` (accento separato).
# Su Linux/Windows è solitamente NFC (Composed: è un carattere unico).
#
# Esempio pratico per capire la differenza:
echo "--- Test Normalizzazione Mac ---"
# Creiamo due versioni visivamente identiche di "è"
e_composta=$(printf $'\u00E8')       # NFC (Standard Linux/Web)
e_scomposta=$(printf $'\u0065\u0300') # NFD (Standard Filesystem Mac)

echo "Visivamente uguali: $e_composta vs $e_scomposta"

if [ "$e_composta" == "$e_scomposta" ]; then
    echo "Per Bash sono uguali."
else
    echo "Per Bash sono DIVERSI! (Attenzione ai confronti di stringhe!)"
fi
# Questo if fallirà quasi sempre. FONDAMENTALE PER L'ESAME se confronti nomi file.


# ==============================================================================
# 📊 TABELLA OPZIONI E SINTASSI
# ==============================================================================
# | SINTASSI       | DESCRIZIONE                                | ESEMPIO BASH 3.2 ($'') |
# |----------------|--------------------------------------------|------------------------|
# | \uXXXX         | Code Point Unicode a 4 cifre (Hex)         | printf $'\u00A9' (©)   |
# | \UXXXXXXXX     | Code Point Unicode a 8 cifre (Hex)         | printf $'\U0001F600'   |
# | \xNN           | Byte esadecimale crudo (2 cifre)           | printf "\xC3\xA9"      |
# | %04X           | Formattatore Printf per Hex 4 cifre        | printf "%04X" 233      |
# | 'c             | Valore numerico del carattere c            | printf "%d" "'A"       |
# | iconv          | Convertitore encoding (utile su Mac)       | iconv -f UTF-8 -t ASCII|

# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Lo script si rompe con i file accentati su Mac" ---
# Causa: Tu cerchi "città" (NFC) ma il file system ti dà "citta`" (NFD).
# Soluzione: Usa 'iconv' per normalizzare prima di confrontare.
# nome_normalizzato=$(echo "$nome_file_mac" | iconv -f UTF-8-MAC -t UTF-8)

# --- SCENARIO 2: "Creare un file con caratteri non stampabili" ---
# Se devi creare un file che contiene il byte NULL o caratteri di controllo:
# printf "\x00\x0A\x0D" > file_binario.bin

# --- SCENARIO 3: "Debuggare caratteri invisibili" ---
# Se una stringa sembra vuota ma non lo è, controlla i byte:
# echo -n "$variabile_strana" | hexdump -C