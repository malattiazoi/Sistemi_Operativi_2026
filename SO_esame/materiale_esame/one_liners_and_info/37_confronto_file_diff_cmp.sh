#!/bin/bash

# ==============================================================================
# 37. CONFRONTO FILE E DIRECTORY: DIFF E CMP (MACOS / BSD)
# ==============================================================================
# OBIETTIVO:
# Capire se due file sono identici o diversi e DOVE sono diversi.
# Fondamentale per:
# 1. Script di backup ("Copio solo se è cambiato").
# 2. Verifica integrità ("Il file è stato manomesso?").
# 3. Patching ("Cosa ho modificato rispetto all'originale?").
#
# AMBIENTE: macOS (BSD diff e cmp)
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. PREPARAZIONE AMBIENTE DI TEST
# ------------------------------------------------------------------------------
echo "--- Creazione file di test ---"

# File A (Originale)
cat <<EOF > file_A.txt
Riga 1: Ciao
Riga 2: Questo è un test
Riga 3: Mela
Riga 4: Fine
EOF

# File B (Leggermente diverso: Modifica riga 2, Cancella riga 3)
cat <<EOF > file_B.txt
Riga 1: Ciao
Riga 2: Questo è un TEST modificato
Riga 4: Fine
EOF

# File C (Identico ad A)
cp file_A.txt file_C.txt

# File Binario (per testare cmp)
printf "\x00\x01\x02" > binario_A.bin
printf "\x00\x01\x99" > binario_B.bin

echo "File creati."


# ==============================================================================
# PARTE 1: CMP (COMPARE) - IL CONFRONTO RAPIDO / BINARIO
# ==============================================================================
# `cmp` confronta byte per byte. È velocissimo.
# Si ferma al PRIMO byte diverso.
# Perfetto per file binari (immagini, eseguibili) o per script (flag -s).

echo "----------------------------------------------------------------"
echo "--- 1. CMP (Byte per Byte) ---"

# 1.1 Confronto file identici
# Se non stampa nulla, sono uguali.
echo "Test 1: File identici"
cmp file_A.txt file_C.txt && echo "Output vuoto = Identici"

# 1.2 Confronto file diversi
# Ti dice riga e byte della prima differenza.
echo "Test 2: File diversi"
cmp file_A.txt file_B.txt

# 1.3 Modalità Silenziosa (-s) - VITALE PER GLI SCRIPT
# Non stampa nulla, usa solo l'Exit Code.
# 0 = Identici
# 1 = Diversi
# >1 = Errore (file non trovato)

echo "Test 3: Scripting con cmp -s"
if cmp -s file_A.txt file_B.txt; then
    echo "I file sono uguali."
else
    echo "I file sono diversi! (Exit code 1)"
fi

# 1.4 Modalità Verbosa (-l) - SOLO BINARI
# Stampa TUTTI i byte diversi (in decimale e ottale).
echo "Test 4: Confronto binario (-l)"
cmp -l binario_A.bin binario_B.bin
# Output atteso: "   3   2 231"
# Significa: Al byte 3, il primo file ha valore 2 (dec), il secondo 231 (dec).


# ==============================================================================
# PARTE 2: DIFF (DIFFERENCE) - IL CONFRONTO TESTUALE
# ==============================================================================
# `diff` ti dice COSA devi fare al file 1 per farlo diventare uguale al file 2.
# Legenda Output Classico:
# a = append (aggiungi)
# c = change (cambia)
# d = delete (cancella)
# < = Contenuto del file 1
# > = Contenuto del file 2

echo "----------------------------------------------------------------"
echo "--- 2. DIFF (Testuale) ---"

# 2.1 Output Classico (Default)
echo "--- Diff Classico ---"
diff file_A.txt file_B.txt

# Spiegazione Output Probabile:
# 2c2               -> Alla riga 2 (change) diventa riga 2
# < Riga 2: ...     -> Com'era in A
# ---
# > Riga 2: ...     -> Com'è in B
# 3d2               -> La riga 3 di A è stata cancellata (delete) e saremmo alla 2 di B
# < Riga 3: Mela    -> Cosa è stato cancellato

# 2.2 Output Unificato (-u) - LO STANDARD MODERNO
# Molto più leggibile (usato da git).
# - (meno) righe tolte
# + (più) righe aggiunte
echo "--- Diff Unificato (-u) ---"
diff -u file_A.txt file_B.txt


# 2.3 Ignorare Spazi bianchi (-w e -b)
# Utile se hai indentato il codice diversamente ma il contenuto è uguale.
# -w : Ignora tutti gli spazi bianchi.
# -b : Ignora differenze nella quantità di spazi.
echo "Test Spazi:"
echo "Ciao   Mondo" > spazi_1.txt
echo "Ciao Mondo"    > spazi_2.txt

echo "Senza flag:"
diff spazi_1.txt spazi_2.txt || echo "Diversi!"

echo "Con flag -w (Ignore All Whitespace):"
diff -w spazi_1.txt spazi_2.txt && echo "Uguali per diff -w!"


# 2.4 Modalità "Brief" (-q)
# Ti dice solo "Files differ", senza elencare le righe. Simile a cmp ma per testo.
diff -q file_A.txt file_B.txt


# ==============================================================================
# PARTE 3: CONFRONTO DIRECTORY (RECURSIVE)
# ==============================================================================
# Come capire se due cartelle di backup sono identiche?
# Flag -r (Recursive)

echo "----------------------------------------------------------------"
echo "--- 3. DIFF RECURSIVE (Directory) ---"

mkdir -p dir_A dir_B
echo "123" > dir_A/f1.txt
echo "123" > dir_B/f1.txt
echo "ABC" > dir_A/f2.txt
# f2.txt manca in B
# f3.txt esiste solo in B
echo "XYZ" > dir_B/f3.txt

# Esecuzione diff ricorsivo
# Ti dirà quali file sono diversi e quali file mancano in una delle due.
diff -r dir_A dir_B

# Output atteso:
# Only in dir_A: f2.txt
# Only in dir_B: f3.txt


# ==============================================================================
# 🧩 ESEMPI DI SCRIPT PER L'ESAME
# ==============================================================================

# SCENARIO A: VERIFICA INTEGRITÀ (ESAME 18)
# "Se rieseguendo lo script il risultato non cambia, la directory è integra".
#
# Logica:
# 1. Calcoli un'impronta attuale (es. elenco file + timestamp + size).
# 2. La confronti con l'impronta precedente salvata.
# 3. Se 'cmp' dice che sono uguali, niente è cambiato.

echo "--- Scenario A: Integrità Directory ---"

# Funzione simulata
check_integrity() {
    DIR_TARGET="$1"
    SNAPSHOT_FILE="snapshot.log"
    LAST_SNAPSHOT="snapshot.last"

    # Creiamo snapshot attuale (ls -lR ricorsivo mostra tutto)
    ls -lR "$DIR_TARGET" > "$SNAPSHOT_FILE"

    if [ -f "$LAST_SNAPSHOT" ]; then
        # Confrontiamo con il precedente
        if cmp -s "$SNAPSHOT_FILE" "$LAST_SNAPSHOT"; then
            echo "INTEGRITÀ OK: Nessuna modifica rilevata in $DIR_TARGET."
        else
            echo "ATTENZIONE: Modifiche rilevate!"
            # Mostriamo cosa è cambiato
            diff -u "$LAST_SNAPSHOT" "$SNAPSHOT_FILE"
        fi
    else
        echo "Primo avvio: Salvataggio stato iniziale."
    fi
    
    # Aggiorniamo lo storico
    mv "$SNAPSHOT_FILE" "$LAST_SNAPSHOT"
}

# Testiamo la funzione
check_integrity "dir_A"
# Modifichiamo qualcosa
touch dir_A/nuovo_file.txt
check_integrity "dir_A"


# SCENARIO B: BACKUP DIFFERENZIALE (CONCETTUALE)
# Copiare in una cartella "patch" solo i file modificati.
# Si usa 'diff -r -q' per trovare i nomi, poi 'cp'.

echo "--- Scenario B: Trovare file modificati ---"
# diff -r -q dir_A dir_B | grep "differ" | cut -d ' ' -f 2
# (Questo ti darebbe i nomi dei file che sono presenti in entrambe ma diversi)


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS / BSD)
# ==============================================================================
# | COMANDO | FLAG | SIGNIFICATO                                     |
# |---------|------|-------------------------------------------------|
# | cmp     | -s   | Silent (solo Exit Code). Fondamentale script.   |
# | cmp     | -l   | Verbose (stampa byte decimali diversi).         |
# |---------|------|-------------------------------------------------|
# | diff    | -u   | Unified (formato +/- molto leggibile).          |
# | diff    | -r   | Recursive (confronta intere directory).         |
# | diff    | -q   | Brief (dice solo "Files differ").               |
# | diff    | -w   | Ignore Whitespace (ignora spazi/tab).           |
# | diff    | -i   | Ignore Case (ignora maiuscole/minuscole).       |

# Pulizia
rm -rf file_*.txt binario_*.bin dir_A dir_B spazi_*.txt snapshot.last
echo "----------------------------------------------------------------"
echo "Test completato."