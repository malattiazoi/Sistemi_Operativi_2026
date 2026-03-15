#!/bin/bash

# ==============================================================================
# 41. LINK, INODE E FORMATTAZIONE NOMI (ESAMI 22 E 35) - MACOS
# ==============================================================================
# OBIETTIVO:
# 1. Capire la differenza tra Hard Link e Soft Link.
# 2. ESAME 22: Cancellare un file e TUTTI i suoi hard link sparsi nel disco.
# 3. ESAME 35: Creare link simbolici con nomi formattati (es. "backup_001.txt").
#
# CONCETTI CHIAVE:
# - INODE: La "carta d'identità" numerica del file. Il nome del file è solo un'etichetta.
# - HARD LINK: Un secondo nome per lo STESSO Inode. Se cancelli l'originale, il link RESTA.
# - SOFT LINK: Un puntatore (shortcut) a un percorso. Se cancelli l'originale, il link si ROMPE.
#
# AMBIENTE: macOS (BSD find / BSD stat)
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. PREPARAZIONE AMBIENTE (SANDBOX)
# ------------------------------------------------------------------------------
echo "--- 0. SETUP AMBIENTE ---"
RM_DIR="test_esame_link"
rm -rf "$RM_DIR"
mkdir -p "$RM_DIR/documenti"
mkdir -p "$RM_DIR/backup"

# Creiamo un file originale
ORIGINALE="$RM_DIR/documenti/progetto.txt"
echo "Dati Importanti del Progetto X" > "$ORIGINALE"

echo "Ambiente creato in ./$RM_DIR"


# ==============================================================================
# 1. TEORIA: CREARE HARD LINK E VERIFICARE INODE
# ==============================================================================
# Sintassi Hard Link: ln TARGET LINK_NAME
# Sintassi Soft Link: ln -s TARGET LINK_NAME

echo "----------------------------------------------------------------"
echo "--- 1. CREAZIONE LINK ---"

# Creiamo un Hard Link nella cartella backup
HARD_LINK="$RM_DIR/backup/copia_sicura.txt"
ln "$ORIGINALE" "$HARD_LINK"

# Creiamo un Soft Link (Simbolico)
SOFT_LINK="$RM_DIR/backup/collegamento_rapido.txt"
ln -s "$ORIGINALE" "$SOFT_LINK"

echo "Link creati."

# VERIFICA DEGLI INODE (ls -i)
# Noterai che Originale e Hard Link hanno LO STESSO numero.
# Il Soft Link ha un numero diverso.
echo "--- Verifica Inode (ls -li) ---"
ls -li "$RM_DIR/documenti/" "$RM_DIR/backup/"

# ESEMPIO OUTPUT ATTESO:
# 123456 ... progetto.txt
# 123456 ... copia_sicura.txt  <-- STESSO NUMERO (È lo stesso file!)
# 987654 ... collegamento_rapido.txt <-- NUMERO DIVERSO (È solo un puntatore)


# ==============================================================================
# 2. SOLUZIONE ESAME 22: CANCELLAZIONE TOTALE (HARD LINKS)
# ==============================================================================
# TRACCIA: "Dato un file, trova tutti i suoi hard link nel sistema e cancellali tutti."
# PROBLEMA: Se fai 'rm file', gli hard link rimangono e i dati non vengono liberati.
# SOLUZIONE: Usare 'find' per cercare l'Inode.

echo "----------------------------------------------------------------"
echo "--- 2. ESAME 22: CANCELLAZIONE TOTALE ---"

TARGET_FILE="$ORIGINALE"

# PASSO A: Ottenere il numero di Inode del file target.
# Su macOS si usa 'stat -f %i'. (Su Linux sarebbe stat -c %i).
TARGET_INODE=$(stat -f %i "$TARGET_FILE")

echo "Il file target '$TARGET_FILE' ha Inode: $TARGET_INODE"

# PASSO B: Trovare tutti i file con quello stesso Inode.
# Usiamo 'find' con il flag -inum (Inode Number).
echo "Cerco tutti i cloni (hard links) di questo file..."
find "$RM_DIR" -inum "$TARGET_INODE"

# PASSO C: Cancellazione Automatica
# Aggiungiamo il flag -delete (specifico Mac/BSD e molto comodo).
# Oppure -exec rm {} \;
echo "Cancello tutto ciò che corrisponde all'inode $TARGET_INODE..."
find "$RM_DIR" -inum "$TARGET_INODE" -delete

# VERIFICA
if [ -f "$HARD_LINK" ]; then
    echo "ERRORE: L'hard link esiste ancora!"
else
    echo "SUCCESSO: Hard link eliminato. Nessuna traccia rimasta."
fi

# NOTA ALTERNATIVA PIÙ MODERNA (-samefile)
# find "$RM_DIR" -samefile "$TARGET_FILE" -delete
# (Fa la stessa cosa senza dover estrarre l'inode manualmente).


# ==============================================================================
# 3. SOLUZIONE ESAME 35: FORMATTAZIONE NOMI E LOOP
# ==============================================================================
# TRACCIA: "Per ogni file nella cartella, crea un link simbolico chiamato 'link_001', 'link_002'..."
# DIFFICOLTÀ: Generare i numeri con lo zero davanti (padding).
# SOLUZIONE: Usare 'printf' dentro un ciclo.

echo "----------------------------------------------------------------"
echo "--- 3. ESAME 35: LINK SEQUENZIALI (PRINTF) ---"

# 3.1 Rigeneriamo dati di test (perché li abbiamo cancellati sopra)
mkdir -p "$RM_DIR/imgs"
touch "$RM_DIR/imgs/foto_vacanze.jpg"
touch "$RM_DIR/imgs/foto_lavoro.png"
touch "$RM_DIR/imgs/foto_gatto.bmp"

# 3.2 Script di rinomina/link
echo "Creo link simbolici sequenziali in $RM_DIR/sequenza/..."
mkdir -p "$RM_DIR/sequenza"

COUNT=1

# Ciclo su tutti i file nella cartella immagini
for FILE in "$RM_DIR/imgs/"*; do
    
    # FORMATTAZIONE NUMERO (001, 002...)
    # %03d significa: Numero intero (d), largo 3 cifre, riempito con 0.
    NOME_LINK=$(printf "link_%03d" $COUNT)
    
    # Otteniamo l'estensione del file originale (opzionale ma elegante)
    # ${FILE##*.} è un trucco bash per prendere l'estensione.
    ESTENSIONE="${FILE##*.}"
    
    TARGET_LINK="$RM_DIR/sequenza/$NOME_LINK.$ESTENSIONE"
    
    echo "Creo link: $TARGET_LINK -> $FILE"
    
    # Creazione Soft Link (-s)
    # Usiamo il percorso assoluto o relativo con attenzione.
    # Qui usiamo "$FILE" che è il percorso completo.
    ln -s "$FILE" "$TARGET_LINK"
    
    # Incremento contatore
    ((COUNT++))
done

echo "--- Risultato ls -l ---"
ls -l "$RM_DIR/sequenza/"


# ==============================================================================
# 4. DIAGNOSTICA AVANZATA: LINK COUNT
# ==============================================================================
# Come faccio a sapere SE un file ha degli hard link nascosti senza cercarli?
# 'ls -l' me lo dice nella seconda colonna!

echo "----------------------------------------------------------------"
echo "--- 4. DIAGNOSTICA (LINK COUNT) ---"

# Creiamo file e link
touch "$RM_DIR/test_count.txt"
ln "$RM_DIR/test_count.txt" "$RM_DIR/test_link1.txt"
ln "$RM_DIR/test_count.txt" "$RM_DIR/test_link2.txt"

# Analizziamo con stat (macOS)
# Flag %l (elle minuscola) in stat mostra il "Link Count".
LINK_COUNT=$(stat -f %l "$RM_DIR/test_count.txt")

echo "Il file ha $LINK_COUNT nomi (hard links) nel sistema."

if [ "$LINK_COUNT" -gt 1 ]; then
    echo "ATTENZIONE: Cancellare questo file non libererà lo spazio disco subito."
    echo "Ci sono altri $link_count riferimenti in giro."
fi


# ==============================================================================
# 5. TROVARE LINK ROTTI (BROKEN SYMLINKS)
# ==============================================================================
# Scenario: Hai cancellato i file originali, ma i soft link sono rimasti.
# Come trovarli e pulirli?

echo "----------------------------------------------------------------"
echo "--- 5. PULIZIA LINK ROTTI ---"

# Creiamo un link rotto
touch "$RM_DIR/effimero.txt"
ln -s "$RM_DIR/effimero.txt" "$RM_DIR/broken_link.txt"
rm "$RM_DIR/effimero.txt"

echo "Creato un link rotto: broken_link.txt"

# Find non ha un flag nativo semplice per "broken link" su tutte le versioni.
# TRUCCO: Usare -exec test -e (check if exists)
# Se il test fallisce su un link, vuol dire che la destinazione non esiste.

echo "Cerco link rotti..."
# Cerca file di tipo Link (-type l)
# Esegui test -e (Esiste il target?). ! nega il risultato.
find "$RM_DIR" -type l ! -exec test -e {} \; -print

# Per cancellarli automaticamente:
# find "$RM_DIR" -type l ! -exec test -e {} \; -delete


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS)
# ==============================================================================
# | COMANDO      | FLAG         | SIGNIFICATO                                |
# |--------------|--------------|--------------------------------------------|
# | ln           | (nessuno)    | Crea HARD LINK (Inode identico).           |
# | ln           | -s           | Crea SOFT LINK (Shortcut).                 |
# | ls           | -i           | Mostra numero Inode a sinistra.            |
# | stat         | -f %i        | Estrae solo Inode (Specifico Mac).         |
# | stat         | -f %l        | Estrae Link Count (Specifico Mac).         |
# | find         | -inum N      | Cerca file con Inode numero N.             |
# | find         | -samefile F  | Cerca hard link del file F.                |
# | find         | -delete      | Cancella ciò che trova (Specifico BSD/Mac).|
# | printf       | "%03d"       | Formatta numero a 3 cifre con zeri (005).  |

# Pulizia finale
rm -rf "$RM_DIR"
echo "----------------------------------------------------------------"
echo "Tutorial 41 (Link & Inode) Completato."