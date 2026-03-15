#!/bin/bash

# ==============================================================================
# 12. GESTIONE PRIORITÀ PROCESSI: NICE E RENICE (MACOS EDITION)
# ==============================================================================
# OBIETTIVO:
# Capire come il sistema operativo decide quale processo eseguire per primo
# e come manipolare questa decisione manualmente.
#
# CONCETTI CHIAVE:
# - NI (Niceness): Un valore da -20 (Alta priorità) a +19 (Bassa priorità).
# - Default: I processi partono con nice = 0.
# - NICE: Avvia un NUOVO processo con una priorità data.
# - RENICE: Cambia la priorità a un processo GIÀ ESISTENTE.
#
# REGOLA MNEMONICA "IL RAGAZZO GENTILE":
# Un processo con Nice ALTO (+19) è "Molto Gentile" (Nice).
# Lascia passare tutti gli altri prima di lui. Quindi ha BASSA PRIORITÀ.
#
# Un processo con Nice BASSO (-20) è "Sgarbato" (Not Nice).
# Vuole passare davanti a tutti. Quindi ha ALTA PRIORITÀ.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. VISUALIZZARE LA PRIORITÀ (PS)
# ------------------------------------------------------------------------------
# Prima di modificare, dobbiamo saper leggere il valore NI.
# Su macOS, il comando ps standard è BSD.
# Flag: -o (Output format) -> pid,ni,comm

echo "--- 1. MONITORAGGIO PRIORITÀ ---"

# Lanciamo un processo "dummy" che dura 10 secondi in background
sleep 10 &
PID_TEST=$!

echo "Ho lanciato un processo 'sleep' con PID: $PID_TEST"

# Verifichiamo il suo valore Nice (NI)
# Di default dovrebbe essere 0.
echo "Valore Nice attuale:"
ps -o pid,ni,comm -p "$PID_TEST"


# ------------------------------------------------------------------------------
# 2. IL COMANDO NICE (AVVIARE NUOVI PROCESSI)
# ------------------------------------------------------------------------------
# Sintassi: nice -n <VALORE> <COMANDO>
# Utile per script di backup, conversioni video o compilazioni pesanti.

echo "----------------------------------------------------------------"
echo "--- 2. NICE (AVVIO) ---"

# Esempio A: Avviare con BASSA PRIORITÀ (+10)
# Questo processo sarà "gentile" e lascerà risorse agli altri.
# Perfetto per script di background che non devono disturbare l'utente.
nice -n 10 sleep 5 &
PID_LOW=$!
echo "Avviato processo Low Priority (Nice +10) PID: $PID_LOW"
ps -o pid,ni,comm -p "$PID_LOW"

# Esempio B: Avviare con ALTA PRIORITÀ (-10)
# ATTENZIONE: Solo l'utente root (sudo) può dare priorità negativa (sgarbata).
# Se ci provi senza sudo, macOS ignorerà la richiesta o darà errore.

echo "Tentativo Alta Priorità senza sudo (Fallirà o metterà 0):"
nice -n -10 sleep 5 &
PID_HIGH_FAIL=$!
ps -o pid,ni,comm -p "$PID_HIGH_FAIL"

# Esempio C: Alta Priorità CON SUDO (Funziona)
# Decommenta la riga sotto se vuoi testarlo (chiederà password)
# sudo nice -n -10 sleep 5 &


# ------------------------------------------------------------------------------
# 3. IL COMANDO RENICE (MODIFICARE PROCESSI ESISTENTI)
# ------------------------------------------------------------------------------
# Sintassi: renice <NUOVO_VALORE> -p <PID>
# Scenario: Hai lanciato un rendering video e il Mac è lento. Lo "renici" a +19.

echo "----------------------------------------------------------------"
echo "--- 3. RENICE (MODIFICA) ---"

# Lanciamo un processo infinito (simulato) per modificarlo
# Usiamo una subshell che non fa nulla di pesante
sh -c 'while true; do sleep 1; done' &
PID_TARGET=$!
echo "Processo target avviato (PID $PID_TARGET) con Nice 0."

# Controllo iniziale
ps -o pid,ni,comm -p "$PID_TARGET"

# 3.1 Aumentare la "Gentilezza" (Abbassare priorità)
# Qualsiasi utente può farlo sui propri processi.
echo "Modifico priorità a +15 (Bassa)..."
renice 15 -p "$PID_TARGET"

# Verifica
ps -o pid,ni,comm -p "$PID_TARGET"

# 3.2 Diminuire la "Gentilezza" (Alzare priorità)
# SOLO ROOT può farlo. Anche per tornare da +15 a 0 serve root.
# L'utente normale non può mai "riprendersi" la priorità che ha ceduto.
echo "Tentativo di ripristinare a 0 senza sudo (Dovrebbe fallire):"
renice 0 -p "$PID_TARGET" || echo "Errore previsto: Permission Denied."


# ------------------------------------------------------------------------------
# 4. RENICE AVANZATO (UTENTI E GRUPPI)
# ------------------------------------------------------------------------------
# renice può agire su tutti i processi di un utente in un colpo solo.
# Flag: -u (User)

echo "----------------------------------------------------------------"
echo "--- 4. RENICE MASSIVO ---"

# Sintassi (Non eseguita per sicurezza):
# renice +5 -u mario
# (Imposta a +5 TUTTI i processi dell'utente 'mario')

echo "Comando dimostrativo: renice +10 -p $PID_TARGET"
# Riportiamo il processo target a +10 (se possibile) o +20 (massimo)
renice 20 -p "$PID_TARGET"
ps -o pid,ni,comm -p "$PID_TARGET"


# ------------------------------------------------------------------------------
# 5. SIMULAZIONE IMPATTO CPU (TEORIA)
# ------------------------------------------------------------------------------
# Come funziona lo scheduler del Mac?
# Se hai 2 processi che usano la CPU al 100%:
# - Processo A (Nice 0)
# - Processo B (Nice 10)
#
# La CPU non viene divisa 50/50.
# Il Processo A prenderà circa il 70-80% della CPU.
# Il Processo B prenderà il restante 20-30%.
#
# Se c'è SOLO il Processo B (e A finisce), B prenderà il 100%.
# Il valore Nice ha effetto SOLO quando c'è CONTESA per la CPU.


# ==============================================================================
# 🧩 SCENARI D'ESAME REALI
# ==============================================================================

# SCENARIO A: "Lancia uno script di backup che non rallenti il PC"
# Soluzione: nice -n 19 ./backup.sh
# Spiegazione: +19 è la priorità più bassa. Il backup userà la CPU solo
# quando nessun altro programma la vuole.

# SCENARIO B: "Il browser (PID 555) è bloccato. Rendilo più reattivo."
# Soluzione: sudo renice -10 -p 555
# Spiegazione: Usiamo un valore negativo (-10) per dare più cicli CPU.
# Serve sudo perché stiamo "rubando" risorse agli altri processi.

# SCENARIO C: "Trova tutti i processi con priorità non standard"
# ps -ax -o pid,ni,comm | grep -v " 0 "
# (Cerca righe dove la colonna NI non è 0).


# ==============================================================================
# ⚠️ PULIZIA FINALE (KILL PROCESS)
# ==============================================================================
# È buona norma negli script d'esame uccidere i processi di test creati.

echo "----------------------------------------------------------------"
echo "--- PULIZIA ---"
echo "Uccido il processo di test PID $PID_TARGET..."
kill "$PID_TARGET" 2>/dev/null
kill "$PID_LOW" 2>/dev/null
kill "$PID_HIGH_FAIL" 2>/dev/null


# ==============================================================================
# 📊 TABELLA RIASSUNTIVA VALORI
# ==============================================================================
# | VALORE | SIGNIFICATO                    | PERMESSI RICHIESTI    |
# |--------|--------------------------------|-----------------------|
# | -20    | Massima Priorità (Egoista)     | ROOT (sudo)           |
# | -10    | Alta Priorità                  | ROOT (sudo)           |
# | 0      | Default (Normale)              | Tutti                 |
# | +10    | Bassa Priorità (Gentile)       | Tutti                 |
# | +19    | Minima Priorità (Background)   | Tutti                 |
# |--------|--------------------------------|-----------------------|
# | nice   | Avvia processo                 | -                     |
# | renice | Modifica processo vivo         | -                     |

echo "Tutorial Nice/Renice Completato."

# ==============================================================================
# GUIDA AI COMANDI 'nice' E 'renice' (GESTIONE CPU)
# ==============================================================================

# 1. AVVIARE UN NUOVO PROCESSO CON PRIORITÀ SPECIFICA
# ------------------------------------------------------------------------------
# La scala va da -20 (massima priorità) a +19 (minima priorità). Default = 0.

# Avviare un comando con BASSA priorità (molto gentile)
nice -n 15 tar -cvzf backup.tar.gz /home/documenti

# Avviare un comando con ALTA priorità (richiede sudo!)
sudo nice -n -10 ./calcolo_pesante.sh


# 2. CAMBIARE PRIORITÀ A UN PROCESSO GIÀ ATTIVO (renice)
# ------------------------------------------------------------------------------
# Nota: nice serve per avviare, renice serve per modificare un PID esistente.

# Aumenta la gentilezza del processo 1234 (gli dai meno CPU)
renice +10 -p 1234

# Prendi tutta la CPU per il processo 1234 (richiede sudo!)
sudo renice -15 -p 1234

# Cambiare priorità a tutti i processi di un utente
sudo renice +5 -u mlazoi814


# 3. VERIFICARE IL VALORE DI "NICENESS" (NI)
# ------------------------------------------------------------------------------
# Usa 'ps' con formattazione personalizzata
ps -o pid,ni,comm -p 1234

# Oppure usa 'top' o 'htop' e guarda la colonna "NI"


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (SCENARI PRATICI)
# ==============================================================================

# --- SCENARIO 1: "Lo script deve girare senza rallentare il PC" ---
# Se l'esame ti chiede di lanciare un backup o una compressione pesante in 
# background senza disturbare l'utente:
# nice -n 19 comando_pesante &

# --- SCENARIO 2: "Trova il processo più prioritario dell'utente" ---
# ps -u $USER -o ni,pid,comm | sort -n | head -n 1

# --- ERRORE COMUNE: "Permission Denied" ---
# Ricorda: UN UTENTE NORMALE può solo AUMENTARE il valore di nice 
# (ovvero può solo rendersi più gentile e cedere CPU). 
# Solo ROOT (sudo) può DIMINUIRE il valore (prendersi più CPU).

# --- TRUCCO PER IL PID ---
# Se devi fare renice di un programma di cui sai solo il nome:
# renice +5 -p $(pgrep nome_programma)