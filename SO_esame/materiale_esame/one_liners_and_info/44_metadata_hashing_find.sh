#!/bin/bash

# ==============================================================================
# 44. FINGERPRINTING E METADATA HASHING (MACOS STAT)
# ==============================================================================
# OBIETTIVO:
# Creare un hash univoco di una directory basato sui METADATI dei file.
# Se cambia nome, dimensione, permessi o data di QUALSIASI file, l'hash cambia.
#
# UTILIZZO NEGLI ESAMI:
# - ESAME 191f: "Hash directory basato su nome, size, perms, mtime".
#
# DIFFICOLTÀ:
# Bisogna estrarre questi dati in modo deterministico (sempre nello stesso ordine)
# per ogni file, unirli in un unico flusso e calcolare l'hash del tutto.
#
# DIFFERENZE CRITICHE STAT (MACOS vs LINUX):
# - Linux: stat -c "%n %s %a %Y"
# - macOS: stat -f "%N %z %p %m" (Flag completamente diversi!)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. ESTRARRE METADATI SU MACOS (STAT -f)
# ------------------------------------------------------------------------------
# Flag chiave per stat su BSD/macOS:
# %N = Nome file
# %z = Dimensione (Size) in bytes
# %p = Permessi (in formato ottale/decimale completo)
# %m = Modification Time (Epoch seconds)

echo "--- 1. ESTRAZIONE METADATI ---"

touch test_meta.txt

# Estraiamo i 4 campi richiesti da Esame 191f
echo "Metadati file singolo:"
stat -f "Nome:%N Size:%z Perms:%p Time:%m" test_meta.txt

# Nota: %p include anche il tipo di file.
# Se vuoi solo i permessi ottali tipo '644', su Mac è complesso con stat puro.
# Ma per l'hashing va bene usare %p intero, basta che sia costante.


# ------------------------------------------------------------------------------
# 2. COSTRUIRE L'IMPRONTA DELLA DIRECTORY (FIND + STAT)
# ------------------------------------------------------------------------------
# Per fare l'hash dell'intera cartella dobbiamo:
# 1. Trovare tutti i file (find).
# 2. Eseguire stat su ognuno.
# 3. ORDINARE il risultato (sort). CRITICO: Se find cambia ordine, l'hash cambia.
# 4. Calcolare l'hash del tutto.

echo "----------------------------------------------------------------"
echo "--- 2. FINGERPRINTING DIRECTORY ---"

mkdir -p test_dir/sub
touch test_dir/a.txt
touch test_dir/sub/b.txt

TARGET_DIR="test_dir"

echo "Calcolo fingerprint metadati..."

# COMANDO COMPLETO (SOLUZIONE ESAME 191f):
# 1. find: Trova file e cartelle
# 2. -exec stat ... : Stampa i metadati per ogni file trovato
#    Formato: Percorso(%N) Dimensione(%z) Permessi(%p) Data(%m)
# 3. sort: Ordina l'output (garantisce consistenza)
# 4. md5/shasum: Calcola l'hash finale dello stream di testo

FINGERPRINT=$(find "$TARGET_DIR" -exec stat -f "%N %z %p %m" {} \; | sort | md5)

echo "Hash Directory: $FINGERPRINT"

# ------------------------------------------------------------------------------
# 3. TEST DI SENSIBILITÀ
# ------------------------------------------------------------------------------
# Verifichiamo che l'hash cambi se tocchiamo i metadati.

echo "----------------------------------------------------------------"
echo "--- 3. VERIFICA CAMBIAMENTI ---"

OLD_HASH="$FINGERPRINT"

# CASO A: Modifica TIME (touch)
sleep 1
touch test_dir/a.txt
NEW_HASH=$(find "$TARGET_DIR" -exec stat -f "%N %z %p %m" {} \; | sort | md5)

if [ "$OLD_HASH" != "$NEW_HASH" ]; then
    echo "[OK] Modifica Time rilevata. Hash cambiato."
else
    echo "[FAIL] Modifica Time ignorata."
fi
OLD_HASH="$NEW_HASH"

# CASO B: Modifica PERMESSI (chmod)
chmod +x test_dir/a.txt
NEW_HASH=$(find "$TARGET_DIR" -exec stat -f "%N %z %p %m" {} \; | sort | md5)

if [ "$OLD_HASH" != "$NEW_HASH" ]; then
    echo "[OK] Modifica Permessi rilevata."
fi


# ------------------------------------------------------------------------------
# 4. FORMATO OUTPUT STAT: TABELLA COMPARATIVA
# ------------------------------------------------------------------------------
# Se devi adattare lo script per Linux, ecco la traduzione dei flag.
#
# | DATO         | MACOS (BSD) | LINUX (GNU) |
# |--------------|-------------|-------------|
# | Nome File    | %N          | %n          |
# | Dimensione   | %z          | %s          |
# | Permessi     | %p          | %a          |
# | Mod. Time    | %m          | %Y          |
# | Inode        | %i          | %i          |
# | User ID      | %u          | %u          |

# Pulizia
rm -f test_meta.txt
rm -rf test_dir
echo "----------------------------------------------------------------"
echo "Tutorial 44 (Metadata Hash) Completato."