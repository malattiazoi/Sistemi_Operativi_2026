#!/bin/bash

# ==============================================================================
# 27. ANALISI MEMORIA AVANZATA: DA PMAP (LINUX) A VMMAP (MACOS)
# ==============================================================================
# FONTE: Appunti lezioni + Adattamento per macOS (Mach Virtual Memory)
#
# OBIETTIVO:
# Capire come un processo usa la RAM: non solo "quanta" ne usa, ma "come".
# Distinguere tra memoria privata (tua), condivisa (librerie) e swap.
#
# DIFFERENZA AMBIENTALE CRITICA:
# - LINUX: Usa `pmap -X PID` o legge `/proc/PID/maps`.
# - MACOS: Usa `vmmap PID`. È lo strumento di debug memoria definitivo su Mac.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PREPARAZIONE: CREIAMO UN PROCESSO DA ANALIZZARE
# ------------------------------------------------------------------------------
# Per vedere come funziona vmmap, lanciamo un processo che sta in background
# (un semplice sleep) così abbiamo un PID stabile da analizzare.

sleep 300 &
TARGET_PID=$!
echo "--- Analisi del processo di test PID: $TARGET_PID ---"


# ------------------------------------------------------------------------------
# 2. IL COMANDO VMMAP (L'EQUIVALENTE MACOS DI PMAP)
# ------------------------------------------------------------------------------
# Sintassi: vmmap [OPZIONI] PID
# Richiede spesso privilegi di root se il processo non è tuo.

# Esempio base (Output molto lungo, usiamo head per vedere l'inizio):
echo "Esecuzione: vmmap $TARGET_PID | head -n 20"
vmmap $TARGET_PID | head -n 20

# ------------------------------------------------------------------------------
# SPIEGAZIONE DETTAGLIATA DELL'OUTPUT DI VMMAP
# ------------------------------------------------------------------------------
# L'output di vmmap è diviso in righe (regioni di memoria). Ecco come leggerle:
#
# REGION TYPE             START - END             [ VSIZE  RSDNT  DIRTY   SWAP]  PERM
# ----------------------  ----------------------  ----------------------------   -------
# __TEXT                  0000000100000000-...    [   4K     4K     0K     0K]   r-x/rwx
# __DATA                  0000000100001000-...    [   8K     8K     4K     0K]   rw-/rwx
# MALLOC_TINY             00007fe84ec00000-...    [   1M    32K    32K     0K]   rw-/rwx
# Stack                   00007ffee1234000-...    [ 8192K   16K    16K     0K]   rw-/rwx
#
# TRADUZIONE LINUX (pmap) -> MACOS (vmmap):
#
# 1. [heap] (Linux) -> MALLOC_* (Mac)
#    Su Mac l'heap è diviso in zone: MALLOC_TINY, MALLOC_SMALL, MALLOC_LARGE.
#    È la memoria dinamica allocata dal programma (malloc/new).
#
# 2. librerie .so (Linux) -> __TEXT / __DATA (Mac)
#    Il codice eseguibile delle librerie (e del programma stesso) sta nelle regioni
#    chiamate __TEXT (Read-Only) e __DATA (Read-Write).
#
# 3. [stack] (Linux) -> Stack (Mac)
#    La memoria di lavoro per le funzioni e le variabili locali.
#
# 4. [vdso] (Linux) -> Shared Memory / dyld shared cache (Mac)
#    Aree di sistema mappate nello spazio utente per velocità.

# ------------------------------------------------------------------------------
# 3. LE METRICHE DI MEMORIA (DEFINIZIONI TEORICHE)
# ------------------------------------------------------------------------------
# Queste definizioni valgono SIA per Linux che per Mac, ma si leggono diversamente.

# --- VIRTUAL SIZE (VSIZE / VSS) ---
# Definizione: Tutta la memoria che il processo "crede" di avere.
# Include memoria richiesta ma non ancora toccata.
# Utilità: Bassa. Un programma può chiedere 100GB di virtuale ma usarne 1MB reale.

# --- RESIDENT SIZE (RSS) ---
# Definizione: La memoria che è VERAMENTE caricata nella RAM fisica (chip).
# Problema: Include le librerie condivise.
# Esempio: Se 10 processi usano la libreria 'libc' (10MB), RSS la conta 10 volte.
# Su Mac: vmmap mostra la colonna "RSDNT".

# --- DIRTY SIZE (Memoria Privata Modificata) ---
# Definizione: Memoria che il processo ha scritto/modificato.
# Importanza: CRITICA. Questa è la memoria che NON può essere liberata facilmente.
# È il vero costo del processo sul sistema.
# Su Linux corrisponde spesso a "Private_Dirty".
# Su Mac: vmmap mostra la colonna "DIRTY".

# --- PSS (Proportional Set Size) ---
# Definizione: Memoria privata + (Memoria condivisa / Numero di processi che la usano).
# Esempio: Se libc (10MB) è usata da 10 processi, il PSS aggiunge solo 1MB al conto.
# Utilità: È la metrica PIÙ ONESTA per capire quanto consuma un processo.
# Su Mac: Si stima guardando il "Phys Footprint" o usando `footprint PID`.


# ------------------------------------------------------------------------------
# 4. IL RIASSUNTO FINALE (LA PARTE PIÙ IMPORTANTE DI VMMAP)
# ------------------------------------------------------------------------------
# In fondo all'output di vmmap c'è una tabella riassuntiva "Writable Regions".
# È lì che devi guardare durante l'esame.

echo "--- RIASSUNTO MEMORIA (SUMMARY) ---"
vmmap -summary $TARGET_PID

# ANALISI DEL SUMMARY (Esempio di lettura):
#
# Region Type     Virtual Size    Resident Size    Dirty Size    Swapped Size
# ===========     ============    =============    ==========    ============
# MALLOC_TINY       1.0M            32K              32K            0K
# Stack             8.0M            16K              16K            0K
# __DATA            400K            100K             50K            0K
# ...
# TOTAL             1.5G            150M             20M            0K
#
# DOMANDA D'ESAME: "Il processo ha un Memory Leak?"
# RISPOSTA: Guarda la riga MALLOC (o Heap).
# Se il "Dirty Size" o "Resident Size" della MALLOC cresce continuamente nel tempo
# mentre lo script gira, allora c'è un Memory Leak.


# ------------------------------------------------------------------------------
# 5. PERMESSI E MAPPE (R-W-X)
# ------------------------------------------------------------------------------
# Come in pmap, anche vmmap mostra i permessi (ultima colonna).
# r = read
# w = write
# x = execute
# /rwx = permessi massimi possibili per quella regione
#
# Esempio:
# __TEXT   r-x/rwx   (Codice: Si legge, Si esegue, NON si scrive. Sicurezza!)
# __DATA   rw-/rwx   (Variabili: Si leggono, Si scrivono, NON si eseguono. Anti-Hacker!)


# ------------------------------------------------------------------------------
# 6. TABELLA DI CONFRONTO METRICHE (LINUX vs MACOS)
# ------------------------------------------------------------------------------
# | CONCETTO                  | LINUX (pmap -X) COLONNA | MACOS (vmmap) COLONNA  |
# |---------------------------|-------------------------|------------------------|
# | Indirizzo Iniziale        | Address                 | START                  |
# | Dimensione Totale         | Size                    | VSIZE                  |
# | Memoria Fisica Usata      | Rss                     | RSDNT                  |
# | Memoria Privata Scritta   | Private_Dirty           | DIRTY                  |
# | Memoria Condivisa         | Shared_Clean/Dirty      | (Dedotta da __TEXT)    |
# | Swap Usato                | Swap                    | SWAP                   |
# | Percorso File/Libreria    | Mapping                 | (Nomi regione/Percorso)|


# ------------------------------------------------------------------------------
# 7. TRUCCHI AVANZATI PER L'ESAME
# ------------------------------------------------------------------------------

# --- A. VEDERE SOLO LE REGIONI SCRIVIBILI (Dove avvengono i problemi) ---
# Le regioni scrivibili sono quelle che consumano RAM reale modificata.
# vmmap -w $TARGET_PID

# --- B. VEDERE LE PAGINE CONDIVISE ---
# Se vuoi vedere quali librerie di sistema sta caricando:
# vmmap $TARGET_PID | grep ".dylib"

# --- C. VEDERE LA COMPRESSIONE (Specifico MacOS) ---
# MacOS comprime la RAM prima di swappare.
# vmmap mostra spesso regioni "COMPRESSED".
# Questo non esiste in pmap standard di Linux.

# Pulizia processo di test
kill $TARGET_PID 2>/dev/null