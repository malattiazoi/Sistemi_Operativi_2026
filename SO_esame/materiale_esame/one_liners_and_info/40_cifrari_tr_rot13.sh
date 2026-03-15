#!/bin/bash

# ==============================================================================
# 40. TRASFORMAZIONI E CIFRARI: TR E ROT13 (MACOS / BSD)
# ==============================================================================
# OBIETTIVO:
# Risolvere l'ESAME 23: "Trasformare i caratteri A-M in N-Z e viceversa".
# Eseguire sostituzioni massive di caratteri (non stringhe, CARATTERI).
#
# COMANDO CHIAVE: tr (Translate)
# Sintassi: echo "testo" | tr 'SET1' 'SET2'
#
# CONCETTO ROT13 (Rotazione di 13 caratteri):
# L'alfabeto ha 26 lettere. 13 è la metà.
# A -> N
# B -> O
# ...
# M -> Z
# N -> A (Si ricomincia)
#
# AMBIENTE: macOS (BSD tr).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. IL CONCETTO DI MAPPATURA (SET1 -> SET2)
# ------------------------------------------------------------------------------
# tr sostituisce il 1° carattere di SET1 con il 1° di SET2, il 2° col 2°, ecc.

echo "--- 1. MAPPATURA BASE ---"

# Esempio Semplice: Cambia 'a' in '1', 'b' in '2', 'c' in '3'
echo "abc def" | tr 'abc' '123'
# Output: 123 def

# Esempio Range: Cambia tutte le minuscole in maiuscole
# SET1: a-z (tutte le minuscole)
# SET2: A-Z (tutte le maiuscole)
echo "ciao mondo" | tr 'a-z' 'A-Z'


# ------------------------------------------------------------------------------
# 2. SOLUZIONE ESAME 23: IL CIFRARIO ROT13
# ------------------------------------------------------------------------------
# La traccia chiede di "Traslare A-M in N-Z".
# Questo implica che N-Z deve diventare A-M (altrimenti perdi informazioni).
#
# SET1 (Input):  A-Z a-z
# SET2 (Output): N-Z A-M n-z a-m
#
# Spiegazione SET2:
# N-Z: Le prime 13 lettere (A-M) diventano la seconda metà (N-Z).
# A-M: Le ultime 13 lettere (N-Z) diventano la prima metà (A-M).

echo "----------------------------------------------------------------"
echo "--- 2. ROT13 (SOLUZIONE ESAME 23) ---"

MESSAGGIO="Esame Superato"

# Cifratura
CIFRATO=$(echo "$MESSAGGIO" | tr 'A-Za-z' 'N-ZA-Mn-za-m')

echo "Messaggio Originale: $MESSAGGIO"
echo "Messaggio Cifrato:   $CIFRATO"

# Decifratura (ROT13 è simmetrico: riapplica lo stesso comando!)
DECIFRATO=$(echo "$CIFRATO" | tr 'A-Za-z' 'N-ZA-Mn-za-m')

echo "Messaggio Decifrato: $DECIFRATO"

# Verifica integrità
if [ "$MESSAGGIO" == "$DECIFRATO" ]; then
    echo "TEST OK: La decifratura ha ripristinato il testo originale."
else
    echo "ERRORE: Qualcosa è andato storto."
fi


# ------------------------------------------------------------------------------
# 3. CANCELLARE CARATTERI (-d)
# ------------------------------------------------------------------------------
# Scenario Esame: "Rimuovi tutti i numeri dal file" o "Rimuovi gli spazi".
# Flag: -d (Delete).
# Cancella tutto ciò che appare nel SET1.

echo "----------------------------------------------------------------"
echo "--- 3. CANCELLAZIONE (-d) ---"

TESTO_SPORCO="H3ell0o 123 World456"

# Rimuovi tutte le cifre (0-9)
echo "$TESTO_SPORCO" | tr -d '0-9'

# Rimuovi gli spazi bianchi
echo "Ciao Mondo Come Va" | tr -d ' '


# ------------------------------------------------------------------------------
# 4. COMPRIMERE CARATTERI RIPETUTI (-s)
# ------------------------------------------------------------------------------
# Scenario Esame: "Il file ha troppi spazi vuoti, riducili a uno solo".
# Flag: -s (Squeeze).
# Se un carattere del SET1 appare più volte consecutivamente, lo riduce a 1.

echo "----------------------------------------------------------------"
echo "--- 4. SQUEEZE (-s) ---"

TESTO_SPAZIATO="Ciao       Mondo    Bello"

# Riduci gli spazi multipli a uno singolo
echo "$TESTO_SPAZIATO" | tr -s ' '

# Rimuovi linee vuote multiple (newline ripetuti)
# echo -e interpreta i \n per creare l'input multilinea
echo -e "Riga 1\n\n\n\nRiga 2" | tr -s '\n'


# ------------------------------------------------------------------------------
# 5. INVERTIRE IL SET (-c) - COMPLEMENTO
# ------------------------------------------------------------------------------
# Scenario Esame: "Cancella tutto ciò che NON è una lettera" (es. tieni solo il testo).
# Flag: -c (Complement).
# Inverte il SET1. "Tutto tranne..."

echo "----------------------------------------------------------------"
echo "--- 5. COMPLEMENT (-c) ---"

TESTO_MISTO="Email: mario@test.com! (Tel: 123-456)"

# Cancella tutto ciò che NON è alfanumerico (a-z, A-Z, 0-9) e NON è a capo (\n)
# Nota: Se non metti \n nel set da salvare, tr farà un'unica riga illeggibile.
echo "$TESTO_MISTO" | tr -cd '[:alnum:]\n'
echo "" # A capo estetico

# Spiegazione:
# -c = Inverti il set (Tutto tranne...)
# -d = Cancella
# '[:alnum:]\n' = Lettere, numeri e a capo.
# Risultato: Cancella simboli, spazi, parentesi.


# ------------------------------------------------------------------------------
# 6. GESTIONE NEWLINE (DA MULTILINEA A RIGA SINGOLA)
# ------------------------------------------------------------------------------
# Scenario: Hai una lista di IP in colonna e li vuoi separati da virgola.
# Input:
# 192.168.1.1
# 192.168.1.2
#
# Output desiderato: 192.168.1.1,192.168.1.2

echo "----------------------------------------------------------------"
echo "--- 6. GESTIONE NEWLINE (\n) ---"

# Creiamo file lista
printf "Mela\nPera\nBanana\n" > lista.txt

echo "Lista Originale:"
cat lista.txt

echo "Lista trasformata (CSV):"
cat lista.txt | tr '\n' ','
echo "" # A capo finale manuale

# Spiegazione: Sostituisce ogni "A capo" (\n) con una "Virgola" (,).


# ==============================================================================
# 🧩 SIMULAZIONE INTERATTIVA ESAME 23
# ==============================================================================
# Traccia: "Script che chiede una stringa all'utente e la cifra in ROT13"

echo "----------------------------------------------------------------"
echo "--- SIMULAZIONE ESAME 23 (INTERATTIVO) ---"

# 1. Chiediamo input (compatibile macOS)
echo "Inserisci il testo da cifrare:"
read INPUT_USER

# 2. Controllo input vuoto
if [ -z "$INPUT_USER" ]; then
    echo "Errore: Nessun testo inserito. Uso 'Test Default'."
    INPUT_USER="Test Default"
fi

# 3. Applicazione ROT13
# Mappatura: A-M -> N-Z  |  N-Z -> A-M (e uguale per minuscole)
OUTPUT_ROT13=$(echo "$INPUT_USER" | tr 'A-Za-z' 'N-ZA-Mn-za-m')

# 4. Stampa risultato
echo "--- RISULTATO ---"
echo "Input:   $INPUT_USER"
echo "ROT13:   $OUTPUT_ROT13"

# 5. Verifica inversa (Opzionale, per dimostrare che funziona)
VERIFICA=$(echo "$OUTPUT_ROT13" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
echo "Verifica:$VERIFICA"


# ==============================================================================
# ⚠️ CLASSI DI CARATTERI POSIX (TR SU MACOS)
# ==============================================================================
# Su macOS BSD, è meglio usare le classi POSIX invece di a-z se devi gestire
# lingue diverse (anche se ROT13 è strettamente A-Z).
#
# | CLASSE      | SIGNIFICATO             | EQUIVALENTE RANGE |
# |-------------|-------------------------|-------------------|
# | [:alnum:]   | Alfanumerico            | [a-zA-Z0-9]       |
# | [:alpha:]   | Solo lettere            | [a-zA-Z]          |
# | [:digit:]   | Solo numeri             | [0-9]             |
# | [:space:]   | Spazi, Tab, Newline     | [ \t\n]           |
# | [:upper:]   | Maiuscole               | [A-Z]             |
# | [:lower:]   | Minuscole               | [a-z]             |
# | [:punct:]   | Punteggiatura           | (.,;! ecc)        |

echo "----------------------------------------------------------------"
echo "Esempio POSIX: Tutto Maiuscolo"
echo "ciao mondo" | tr '[:lower:]' '[:upper:]'

# Pulizia
rm -f lista.txt
echo "----------------------------------------------------------------"
echo "Tutorial ROT13 e TR Completato."