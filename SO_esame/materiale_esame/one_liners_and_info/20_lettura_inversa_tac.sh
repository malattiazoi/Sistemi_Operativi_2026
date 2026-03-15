#!/bin/bash

# ==============================================================================
# GUIDA COMPLETA AL COMANDO 'tac' (REVERSE CAT)
# ==============================================================================
# FONTE: Appunti lezioni + Integrazioni Exam Kit
# DESCRIZIONE:
# Il comando "tac" (che è "cat" scritto al contrario) concatena e stampa i file
# in ordine inverso: dall'ultima riga alla prima.
#
# È fondamentale per l'analisi dei LOG (vedere prima gli errori recenti) o per
# invertire liste di priorità.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SINTASSI E FUNZIONAMENTO BASE (Dal file originale)
# ------------------------------------------------------------------------------
# Sintassi:
# tac [OPZIONI] [FILE]...

# Esempio Semplice:
# tac file.txt
# (Mostra il contenuto di file.txt partendo dall'ultima riga fino alla prima).

# ------------------------------------------------------------------------------
# 2. UTILIZZO NELLE PIPELINE (Dal file originale)
# ------------------------------------------------------------------------------
# Leggere l'input da una pipe e invertirne l'ordine.
# Molto utile quando l'output di un comando è ordinato cronologicamente (vecchio -> nuovo)
# e tu vuoi vedere prima i dati recenti.

# Esempio: Invertire l'output di 'cat'
# cat file.txt | tac

# Esempio: Invertire un elenco ordinato numericamente
# seq 5 | tac
# Output:
# 5
# 4
# 3
# 2
# 1

# ------------------------------------------------------------------------------
# 3. ANALISI DEI LOG (Uso comune citato nel file)
# ------------------------------------------------------------------------------
# Visualizzare un log dall'evento più recente al più vecchio.
# Se il file di log appende le nuove righe alla fine, tac ti permette di vedere
# subito cosa è successo per ultimo senza scorrere tutto il file.

# tac /var/log/syslog | head -n 10
# (Mostra gli ultimi 10 eventi registrati, partendo dal più recente)

# ------------------------------------------------------------------------------
# 4. GESTIONE DEI SEPARATORI (Opzione -s) (Dal file originale)
# ------------------------------------------------------------------------------
# Di default, tac usa il "newline" (\n) come separatore di record.
# Puoi cambiare questo comportamento con l'opzione -s.

# Esempio con separatore personalizzato (citato nel tuo file):
# tac -s ";" file.csv
# (Inverte il file considerando il punto e virgola ';' come fine della riga,
#  invece dell'invio a capo. Utile per file di dati strutturati in modo strano).

# ------------------------------------------------------------------------------
# 5. REGEX E POSIZIONAMENTO SEPARATORE (Approfondimento Tecnico)
# ------------------------------------------------------------------------------
# Se usi il separatore -s, puoi decidere DOVE attaccarlo (prima o dopo il record).

# -b (before): Il separatore viene attaccato all'inizio del record invece che alla fine.
# Esempio: Immagina un file dove i record sono separati da "---".
# tac -b -s "---" file_log_strano.txt

# -r (regex): Tratta il separatore -s come un'espressione regolare (REGEX).
# tac -r -s "[0-9]+ " file.txt
# (Usa qualsiasi numero seguito da spazio come separatore).

# ==============================================================================
# ⚠️ IL GRANDE PROBLEMA DI MACOS (Exam Alert!)
# ==============================================================================
# Su molti sistemi MacOS (BSD), il comando 'tac' NON È INSTALLATO di default.
# Se all'esame ti trovi su un Mac e scrivi 'tac' ricevendo "command not found":

# SOLUZIONE 1: Usa 'tail -r' (Esclusiva BSD/Mac)
# tail -r file.txt
# (Fa esattamente la stessa cosa di tac).

# SOLUZIONE 2: Usa 'sed' (Universale ma complesso)
# sed '1!G;h;$!d' file.txt

# SOLUZIONE 3: Usa 'perl' (Se il prof è sadico)
# perl -e 'print reverse <>' file.txt

# ==============================================================================
# 📊 TABELLA RIEPILOGATIVA OPZIONI (FLAG)
# ==============================================================================
# | FLAG CORTA | FLAG LUNGA      | DESCRIZIONE DETTAGLIATA                      |
# |------------|-----------------|----------------------------------------------|
# | -s [STR]   | --separator=STR | Usa STR come separatore invece del newline.  |
# | -b         | --before        | Attacca il separatore all'INIZIO del record  |
# |            |                 | invece che alla fine (default).              |
# | -r         | --regex         | Tratta la stringa del separatore come REGEX. |
# |            | --help          | Mostra la guida (solo su Linux GNU).         |
# |            | --version       | Mostra la versione installata.               |

# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Trova l'ultimo utente che ha fatto login" ---
# Il comando 'last' mostra i login dal più recente, ma se tu avessi un file
# ordinato per data (vecchio -> nuovo) e volessi l'ultimo:
# tac access_log.txt | grep "Login" | head -n 1

# --- SCENARIO 2: "Invertire l'ordine dei caratteri vs Invertire le righe" ---
# DOMANDA TRABOCCHETTO: "Inverti il contenuto del file".
# - Se devi invertire l'ordine delle RIGHE (Line 1 diventa Line N): Usa 'tac'.
# - Se devi invertire i CARATTERI in ogni riga (Ciao -> oaiC): Usa 'rev'.
# Esempio combinato (Caos totale):
# tac file.txt | rev
# (Ultima riga diventa la prima, e scritta al contrario).

# --- SCENARIO 3: "Processing di blocchi XML/JSON semplici" ---
# Se hai un file con record separati da una riga vuota e vuoi invertirli,
# ma 'tac' normale inverte riga per riga rompendo i blocchi...
# Devi usare il separatore giusto. Ma attenzione: tac carica il file in memoria.
# Per file enormi (>2GB), tac potrebbe fallire.

# --- RICORDA ---
# "tac" è semplicemente "cat" al contrario.
# Se l'esame è su Linux -> usa 'tac'.
# Se l'esame è sul Mac -> prova 'tac', se fallisce usa 'tail -r'.