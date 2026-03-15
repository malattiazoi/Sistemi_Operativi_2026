#!/bin/bash

# ==============================================================================
# 47. CONFRONTO AVANZATO: DIFF (MACOS / BSD)
# ==============================================================================
# OBIETTIVO:
# Confrontare due file o due directory riga per riga.
# Capire cosa è stato aggiunto, rimosso o modificato.
#
# UTILIZZO ESAMI:
# - Monitoraggio modifiche: "Avvisa se il file config è cambiato".
# - Backup differenziale: "Trova solo i file nuovi rispetto a ieri".
#
# DIFFERENZE CHIAVE:
# - diff (Standard): Output criptico (< e >).
# - diff -u (Unified): Output leggibile (+ e -), standard per git/patch.
# - diff -r (Recursive): Confronta intere strutture di directory.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. SETUP AMBIENTE DI TEST
# ------------------------------------------------------------------------------
echo "--- 0. CREAZIONE FILE DI TEST ---"
mkdir -p test_diff

# File A (Originale)
cat <<EOF > test_diff/originale.txt
Riga 1: Intatta
Riga 2: Questa verrà modificata
Riga 3: Questa verrà cancellata
Riga 4: Intatta
EOF

# File B (Modificato)
cat <<EOF > test_diff/modificato.txt
Riga 1: Intatta
Riga 2: Questa è la MODIFICA
Riga 4: Intatta
Riga 5: Questa è nuova (Aggiunta)
EOF

echo "File creati in ./test_diff"


# ==============================================================================
# 1. DIFF BASE (FORMATO CLASSICO)
# ==============================================================================
# Output:
# < = Linea presente nel PRIMO file (che non c'è nel secondo).
# > = Linea presente nel SECONDO file (che non c'era nel primo).
# 2c2 = Riga 2 Changed in Riga 2.
# 3d2 = Riga 3 Deleted (siamo alla riga 2 del nuovo).

echo "----------------------------------------------------------------"
echo "--- 1. DIFF CLASSICO ---"

diff test_diff/originale.txt test_diff/modificato.txt

# Spiegazione Output Probabile:
# 2c2           -> Modifica alla riga 2
# < Riga 2...   -> Com'era
# ---
# > Riga 2...   -> Com'è diventata
# 3d2           -> Cancellazione riga 3
# < Riga 3...   -> Cosa è sparito
# 4a5           -> Append dopo la riga 4 (diventa riga 5)
# > Riga 5...   -> Cosa è stato aggiunto


# ==============================================================================
# 2. DIFF UNIFIED (-u) - LO STANDARD MODERNO
# ==============================================================================
# Molto più facile da leggere. Usato da GIT e per creare PATCH.
# - (meno) = Riga rimossa
# + (più)  = Riga aggiunta
#   (spazio)= Riga invariata (contesto)

echo "----------------------------------------------------------------"
echo "--- 2. DIFF UNIFIED (-u) ---"

diff -u test_diff/originale.txt test_diff/modificato.txt


# ==============================================================================
# 3. CONFRONTO DIRECTORY (-r)
# ==============================================================================
# Scenario Esame: "Verifica quali file sono stati aggiunti o tolti dalla cartella backup".

echo "----------------------------------------------------------------"
echo "--- 3. DIFF RECURSIVE (-r) ---"

mkdir -p test_diff/dirA
mkdir -p test_diff/dirB

touch test_diff/dirA/file_comune.txt
touch test_diff/dirB/file_comune.txt

touch test_diff/dirA/solo_in_A.txt
touch test_diff/dirB/solo_in_B.txt

# -r : Ricorsivo
# -q : Brief (Dice solo "Files differ", non mostra il contenuto diverso).
echo "Confronto Directory:"
diff -rq test_diff/dirA test_diff/dirB

# Output atteso:
# Only in test_diff/dirA: solo_in_A.txt
# Only in test_diff/dirB: solo_in_B.txt


# ==============================================================================
# 4. IGNORARE SPAZI E FORMATTAZIONE (-w, -i, -B)
# ==============================================================================
# A volte un file sembra diverso solo perché hai aggiunto uno spazio o una riga vuota.
# -w : Ignore all whitespace (spazi e tab).
# -i : Ignore case (maiuscole/minuscole).
# -B : Ignore Blank lines (righe vuote).

echo "----------------------------------------------------------------"
echo "--- 4. DIFF TOLLERANTE (-w) ---"

echo "Ciao Mondo" > test_diff/spazi1.txt
echo "Ciao    Mondo" > test_diff/spazi2.txt

echo "Diff normale (rileva differenza):"
diff test_diff/spazi1.txt test_diff/spazi2.txt

echo "Diff -w (ignora spazi):"
diff -w test_diff/spazi1.txt test_diff/spazi2.txt && echo "Per diff -w sono IDENTICI."


# ==============================================================================
# 5. SCRIPTING: USARE L'EXIT CODE
# ==============================================================================
# diff ritorna:
# 0 = File Identici
# 1 = File Diversi
# 2 = Errore

echo "----------------------------------------------------------------"
echo "--- 5. SCRIPTING EXIT CODES ---"

if diff -q test_diff/originale.txt test_diff/modificato.txt > /dev/null; then
    echo "I file sono uguali."
else
    echo "I file sono DIVERSI (Exit Code 1)."
fi


# ==============================================================================
# 6. CREARE E APPLICARE PATCH
# ==============================================================================
# Una patch è un file che contiene le istruzioni per trasformare File A in File B.
# Comando: patch

echo "----------------------------------------------------------------"
echo "--- 6. PATCHING ---"

# 1. Creiamo il file patch
diff -u test_diff/originale.txt test_diff/modificato.txt > test_diff/aggiornamento.patch

echo "Patch creata. Applicazione su originale..."

# 2. Applichiamo la patch all'originale
# Ora 'originale.txt' diventerà identico a 'modificato.txt'
patch test_diff/originale.txt < test_diff/aggiornamento.patch

echo "Verifica post-patch:"
diff -s test_diff/originale.txt test_diff/modificato.txt
# -s report identical files


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (DIFF)
# ==============================================================================
# | FLAG | SIGNIFICATO                                            |
# |------|--------------------------------------------------------|
# | -u   | Unified format (leggibile, stile git).                 |
# | -r   | Recursive (per directory).                             |
# | -q   | Brief (dice solo se differiscono, non mostra righe).   |
# | -w   | Ignora spazi bianchi (whitespace).                     |
# | -i   | Ignora case (maiuscole/minuscole).                     |
# | -y   | Side-by-side (mostra file affiancati in due colonne).  |

# Pulizia
rm -rf test_diff
echo "----------------------------------------------------------------"
echo "Tutorial 47 (Diff) Completato."