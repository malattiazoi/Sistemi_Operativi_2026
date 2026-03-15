#!/bin/bash

# ==============================================================================
# 03. GESTIONE SPAZIO DISCO: DU (USAGE) E DF (FREE) - MACOS EDITION
# ==============================================================================
# OBIETTIVO:
# Capire quanto spazio è occupato (du) e quanto ne rimane libero (df).
# Fondamentale per script di monitoraggio e backup.
#
# DIFFERENZE CRITICHE LINUX vs MACOS:
# 1. Profondità: Linux usa `--max-depth=1`. MacOS usa `-d 1`.
# 2. Blocchi: I calcoli dei blocchi possono variare (512 byte vs 1K).
# 3. Inode: Monitorare non solo i GB ma anche i "file slot" (Inode).
# ==============================================================================

# Prepariamo dei file di test per vedere i comandi in azione
echo "--- CREAZIONE FILE DI TEST ---"
mkdir -p test_spazio/cartella_A
mkdir -p test_spazio/cartella_B
# Creiamo file di dimensioni specifiche usando 'mkfile' (comando nativo macOS)
# mkfile crea un file esattamente della dimensione richiesta.
mkfile 10m test_spazio/cartella_A/file_10MB.dat
mkfile 5m  test_spazio/cartella_A/file_5MB.dat
mkfile 20m test_spazio/cartella_B/file_20MB.dat
mkfile 1k  test_spazio/piccolo.txt

echo "File creati. Inizio analisi..."
echo "----------------------------------------------------------------"


# ==============================================================================
# PARTE 1: DF (DISK FREE) - SPAZIO LIBERO SUL FILESYSTEM
# ==============================================================================
# Risponde alla domanda: "Quanto spazio ho ancora sul disco intero?"

echo "--- 1. DF: DISK FREE ---"

# 1.1 Utilizzo Base (Blocchi da 512 byte - Illeggibile)
# Questo è l'output grezzo standard BSD.
df

echo "--- 1.2 Output Umano (-h) ---"
# Flag -h (Human Readable): Mostra G (Gigabyte), M (Megabyte).
# Questo è quello da usare all'esame per leggere i dati.
df -h

echo "--- 1.3 Controllo cartella corrente (.) ---"
# Ti dice su quale disco/partizione risiede la cartella dove ti trovi.
df -h .

echo "--- 1.4 Controllo INODE (-i) - DOMANDA TRABOCCHETTO ---"
# A volte il disco NON è pieno (ha GB liberi), ma non puoi creare file.
# Causa: Hai finito gli INODE (il numero massimo di file gestibili).
# df -i mostra la capacità in termini di numero di file.
df -i .


# ==============================================================================
# PARTE 2: DU (DISK USAGE) - PESO DI FILE E CARTELLE
# ==============================================================================
# Risponde alla domanda: "Chi sta occupando tutto il mio spazio?"

echo "----------------------------------------------------------------"
echo "--- 2. DU: DISK USAGE ---"

# 2.1 Utilizzo Base (Ricorsivo, blocchi default)
# Elenca TUTTE le sottocartelle. Se lanciato in /home non finisce più.
# du test_spazio

echo "--- 2.2 Output Umano (-h) ---"
# Mostra K, M, G. Molto più leggibile.
du -h test_spazio

echo "--- 2.3 SOMMARIO (-s) ---"
# Mostra SOLO il totale della cartella indicata, senza elencare il contenuto.
# Combinazione classica: -sh (Summary Human)
du -sh test_spazio

echo "--- 2.4 PROFONDITÀ (-d) - CRITICO SU MACOS ---"
# Voglio vedere quanto pesano le cartelle di primo livello, ma non scendere oltre.
# SU LINUX: du --max-depth=1 (Errore su Mac!)
# SU MACOS: du -d 1 (Corretto!)
du -h -d 1 test_spazio

echo "--- 2.5 Mostrare anche i FILE (-a) ---"
# Di default 'du' mostra solo le dimensioni delle directory.
# Con -a (All), mostra anche i singoli file.
du -ah test_spazio


# ==============================================================================
# PARTE 3: ORDINAMENTO E RICERCA (SORTING)
# ==============================================================================
# Trovare i file/cartelle più grandi.
# Problema: 'sort' normale non capisce che 1G > 500M.

echo "----------------------------------------------------------------"
echo "--- 3. ORDINAMENTO (TROVA I PIÙ GRANDI) ---"

# METODO 1: USARE KILOBYTE (-k) E SORT NUMERICO (-n)
# Questo è il metodo PIÙ SICURO e COMPATIBILE su tutti i sistemi Unix/BSD.
# du -k = output in Kilobyte
# sort -nr = Numeric Reverse (dal più grande al più piccolo)
echo "Classifica (in KB):"
du -k -d 1 test_spazio | sort -nr

# METODO 2: SORT HUMAN (-h) - SOLO SU MACOS RECENTI
# sort -h è in grado di ordinare 1K, 1M, 1G correttamente.
# Se all'esame il Mac è vecchio, potrebbe non funzionare.
echo "Classifica (Human Readable):"
du -h -d 1 test_spazio | sort -hr 2>/dev/null || echo "Sort -h non supportato, usa metodo 1."


# ==============================================================================
# 🧩 ESEMPI DI SCRIPT PER L'ESAME
# ==============================================================================

# SCENARIO A: "Trova le 3 cartelle più pesanti nella home"
# --------------------------------------------------------
echo "--- Scenario A: Top 3 Cartelle ---"
# Usa -d 1 per non scendere troppo, -k per ordinare sicuro.
du -k -d 1 test_spazio | sort -nr | head -n 3


# SCENARIO B: "Avvisami se lo spazio libero è sotto il 10%"
# --------------------------------------------------------
echo "--- Scenario B: Check Spazio Libero ---"
# 1. df /       -> Prende info disco principale
# 2. awk 'NR==2'-> Prende la seconda riga (salta intestazione)
# 3. awk '{print $5}' -> Prende la colonna % (es. 45%)
# 4. tr -d '%'  -> Toglie il simbolo % (es. 45)

PERCENTUALE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
SOGLIA=90 # Facciamo finta che l'allarme sia se PIENO > 90% (cioè libero < 10%)

echo "Disco pieno al: $PERCENTUALE%"

if [ "$PERCENTUALE" -gt "$SOGLIA" ]; then
    echo "ALLARME: Spazio in esaurimento!"
else
    echo "Tutto OK: Spazio sufficiente."
fi


# SCENARIO C: "Trova tutti i file più grandi di 10MB"
# --------------------------------------------------------
# Qui usiamo 'find' perché 'du' è bravo a sommare cartelle,
# ma 'find' è bravo a filtrare file singoli.
echo "--- Scenario C: File > 10MB ---"
# -size +10M funziona su Mac
find test_spazio -type f -size +10M -exec ls -lh {} \; | awk '{print $5, $9}'


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS EDITION)
# ==============================================================================
# | COMANDO | FLAG | SIGNIFICATO                                     |
# |---------|------|-------------------------------------------------|
# | df      | -h   | Human readable (GB, MB)                         |
# | df      | -i   | Mostra utilizzo Inode (Numero file massimi)     |
# | df      | .    | Analizza solo il disco della cartella corrente  |
# |---------|------|-------------------------------------------------|
# | du      | -h   | Human readable (GB, MB)                         |
# | du      | -s   | Summary (Solo totale, niente elenco dettagli)   |
# | du      | -d N | Depth (Profondità ricorsione). Linux usa --max-depth |
# | du      | -k   | Output in Kilobyte (Perfetto per `sort -n`)     |
# | du      | -a   | All (Mostra anche i file, non solo cartelle)    |
# | du      | -c   | Grand Total (Aggiunge riga totale alla fine)    |

# Pulizia ambiente test
rm -rf test_spazio
echo "----------------------------------------------------------------"
echo "Test completato. Ambiente pulito."

# ==============================================================================
# GUIDA AI COMANDI 'du' E 'df' (MONITORAGGIO DISCO)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. IL COMANDO 'du' (Disk Usage)
# A cosa serve: A misurare lo spazio occupato da FILE e DIRECTORY.
# "Quanto pesa questa cartella?" -> Usa du.
# ------------------------------------------------------------------------------

# SINTASSI: du [OPZIONI] [PERCORSO]

# --- OPZIONI FONDAMENTALI ---
# -h : (Human-readable) Mostra i valori in KB, MB, GB invece che in blocchi. OBBLIGATORIO per l'esame!
# -s : (Summary) Mostra solo il totale finale della cartella, non ogni singolo file interno.
# -a : (All) Mostra lo spazio occupato da ogni singolo file (di default du mostra solo le directory).
# -c : (Grand Total) Aggiunge una riga alla fine con il totale complessivo di tutto ciò che hai analizzato.
# -d N : (Depth) Specifica la profondità. -d 1 mostra le cartelle nel percorso, ma non le sottocartelle.

echo "--- ESEMPI PRATICI 'du' ---"

# 1. Quanto pesa la cartella corrente (totale sintetico)?
# du -sh .

# 2. Quali sono le cartelle più pesanti in /var (profondità 1)?
# du -h -d 1 /var 2>/dev/null | sort -h
# NOTA: il '2>/dev/null' serve a nascondere gli errori di "permesso negato".

# 3. Elenca tutti i file (anche nascosti) e cartelle ordinati per dimensione:
# du -ah . | sort -h


# ------------------------------------------------------------------------------
# 2. IL COMANDO 'df' (Disk Free)
# A cosa serve: A vedere lo stato delle PARTIZIONI e dei DISCHI montati.
# "Quanto spazio libero c'è sul disco?" -> Usa df.
# ------------------------------------------------------------------------------

# SINTASSI: df [OPZIONI] [FILE/FILESYSTEM]

# --- OPZIONI FONDAMENTALI ---
# -h : (Human-readable) Come per du, rende i numeri leggibili.
# -T : (Type) Mostra il tipo di filesystem (es. apfs su Mac, ext4 su Linux).
# -i : (Inodes) Mostra l'uso degli Inode invece dello spazio. 
#      IMPORTANTE: Se un disco ha spazio MB libero ma hai creato milioni di 
#      piccoli file, finirai gli Inode e il disco risulterà "pieno"!
# -t : (Type) Filtra per tipo (es. df -t ext4).

echo "--- ESEMPI PRATICI 'df' ---"

# 1. Vedere lo stato di tutti i dischi montati in modo leggibile:
# df -h

# 2. Vedere quanto spazio resta sulla partizione dove si trova la cartella Home:
# df -h ~

# 3. Controllare se abbiamo esaurito gli Inode (molto comune in esami teorici):
# df -ih


# ------------------------------------------------------------------------------
# DIFFERENZA CHIAVE PER L'ESAME
# ------------------------------------------------------------------------------
# DU (Disk Usage) = Analizza il CONTENUTO (si basa sui file). 
#                   È più lento perché deve scansionare ogni file.
# DF (Disk Free)  = Analizza la STRUTTURA (si basa sul filesystem). 
#                   È istantaneo perché legge i metadati della partizione.
#
# Se cancelli un file enorme ma 'df' non mostra spazio libero, è perché
# un processo ha ancora quel file aperto!
