#!/bin/bash

# ==============================================================================
# 25. GUIDA COMPLETA AL COMANDO 'yes' (AUTOMAZIONE E STRESS TEST)
# ==============================================================================
# FONTE: Appunti lezioni + Integrazioni Exam Kit (Specifiche MacOS)
# DESCRIZIONE:
# Il comando `yes` stampa ripetutamente una stringa finché non viene ucciso.
#
# USI PRINCIPALI IN ESAME:
# 1. Automazione: Rispondere "y" (o "n") automaticamente a script interattivi.
# 2. Stress Test: Portare la CPU al 100% per testare ventole o stabilità.
# 3. Generazione Dati: Creare file pieni di dati ripetitivi per test.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. FUNZIONAMENTO BASE (LOOP INFINITO)
# ------------------------------------------------------------------------------
# Se lanciato senza argomenti, stampa "y" all'infinito.
# Per fermarlo devi premere CTRL + C.

# Esempio limitato a 5 righe per non bloccare questo script:
yes | head -n 5

# Esempio con stringa personalizzata (stampa "accetto" all'infinito):
yes "accetto" | head -n 5


# ------------------------------------------------------------------------------
# 2. AUTOMAZIONE CONFERME (PIPING) - CRITICO PER SCRIPT
# ------------------------------------------------------------------------------
# Molti comandi (come rm -i, fsck, o installazioni) chiedono "Are you sure? [y/N]"
# Se lanci uno script di notte, si bloccherebbe su quella domanda.
# `yes` risolve il problema "iniettando" la risposta nella pipe.

# SCENARIO: Cancellare file protetti senza interazione
# (rm -i chiede conferma per ogni file. yes risponde "y" a tutti).
# Creiamo dei file di test prima:
touch file_test_1 file_test_2
yes | rm -i file_test_1 file_test_2

# SCENARIO: IL "NON-MAN" (AUTOMATIC NO)
# A volte vuoi rispondere "no" a tutto per sicurezza.
# yes "n" | comando_pericoloso


# ------------------------------------------------------------------------------
# 3. GENERAZIONE FILE DI TEST (DUMMY DATA)
# ------------------------------------------------------------------------------
# Utile se devi creare un file pesante per testare la rete o il disco.

# Crea un file 'test.txt' con 1000 righe contenenti la parola "LOG_DATA"
yes "LOG_DATA" | head -n 1000 > test_dummy.txt

# Verifica dimensione
ls -lh test_dummy.txt


# ------------------------------------------------------------------------------
# 4. STRESS TEST CPU (MACBOOK HEATING)
# ------------------------------------------------------------------------------
# `yes` è così veloce che occupa il 100% di un core della CPU.
# Su MacOS, questo è utile per vedere se le ventole partono o testare il thermal throttling.

# ATTENZIONE: Questo comando scalda il Mac.
# > /dev/null serve per non stampare nulla a video (che rallenterebbe il test).
# La '&' lo manda in background.

yes > /dev/null &
PID_STRESS=$!
echo "Stress test avviato sul PID $PID_STRESS. Attendi 5 secondi..."
sleep 5
echo "Termino lo stress test."
kill $PID_STRESS


# ------------------------------------------------------------------------------
# 5. CURIOSITÀ MACOS: LA TRAPPOLA DELL'HELP
# ------------------------------------------------------------------------------
# Su Linux GNU, `yes --help` ti mostra la guida.
# Su MacOS (BSD), `yes` non ha opzioni. Interpreta "--help" come la stringa da ripetere!

# Se esegui questo su Mac, stamperà "--help" all'infinito:
# yes --help


# ==============================================================================
# 📊 TABELLA OPZIONI (FLAG)
# ==============================================================================
# | FLAG         | DESCRIZIONE                                                     |
# |--------------|-----------------------------------------------------------------|
# | Nessuna      | Stampa "y" seguito da un a capo, per sempre.                    |
# | [STRINGA]    | Stampa la [STRINGA] seguita da un a capo, per sempre.           |
# | --version    | (Solo Linux GNU) Stampa la versione. Su Mac stampa "--version". |
# | --help       | (Solo Linux GNU) Guida. Su Mac stampa "--help".                 |

# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Installa questo pacchetto senza chiedermi nulla" ---
# Su Linux useresti apt-get -y. Ma se il comando non ha la flag -y?
# yes | comando_installazione

# --- SCENARIO 2: "Riempi il disco fino a che non scoppia (Test Quota)" ---
# yes "JUNK" > file_gigante.txt
# (Lascialo girare finché non vedi "Disk full", poi ferma con Ctrl+C).
# *Attenzione: Farlo sul server dell'esame potrebbe far arrabbiare il prof!*

# --- SCENARIO 3: "Stress Test Multi-Core" ---
# Un solo `yes` occupa una sola CPU (es. Core 1).
# Se il tuo Mac ha 8 core e vuoi testarli tutti:
# for i in {1..8}; do yes > /dev/null & done
# (Ricorda poi di fare 'killall yes' per fermarli tutti!)

# --- SCENARIO 4: "Debug interattivo" ---
# Se hai uno script che legge input dall'utente con 'read', puoi testarlo
# passandogli valori fissi con yes.
# yes "valore_test" | ./mio_script_con_read.sh