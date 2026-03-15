#!/bin/bash

# ==============================================================================
# 13.5. MASTER CLASS SUGLI ID: PID, PPID, UID, GID, EUID (MACOS)
# ==============================================================================
# OBIETTIVO:
# Capire l'identità di un processo e dell'utente che lo esegue.
#
# PERCHÉ SERVE ALL'ESAME:
# 1. "Lo script deve essere eseguito solo da root" (Controllo UID).
# 2. "Lo script deve uccidere il processo che lo ha lanciato" (Controllo PPID).
# 3. "Creare file con lo stesso gruppo della cartella" (Controllo GID).
#
# LEGENDA ID:
# PID  = Process ID (Identificativo del processo corrente).
# PPID = Parent Process ID (Identificativo del processo genitore).
# UID  = User ID (Identificativo numerico dell'utente reale).
# GID  = Group ID (Identificativo numerico del gruppo principale).
# EUID = Effective User ID (Chi il sistema "pensa" che tu sia, es. con sudo).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. IDENTITÀ DEL PROCESSO (PID e PPID)
# ------------------------------------------------------------------------------
# Ogni script è un processo. Ogni processo ha un padre.

echo "--- 1. PROCESSO CORRENTE (PID) E GENITORE (PPID) ---"

# Variabile $$ : Contiene il PID dello script attuale.
echo "Io sono il processo PID: $$"

# Variabile $PPID : Contiene il PID del genitore (la Shell che ti ha lanciato).
echo "Mio padre (la shell) è il PID: $PPID"

# Variabile $! : PID dell'ultimo job lanciato in background.
sleep 1 &
LAST_BG_PID=$!
echo "Ho appena lanciato un processo figlio in background con PID: $LAST_BG_PID"

# Esempio pratico: Verificare chi è mio padre
# Usiamo ps con flag -p (PID) e -o (output personalizzato)
# comm = nome comando
echo "Verifica del genitore tramite ps:"
ps -p "$PPID" -o pid,ppid,comm


# ------------------------------------------------------------------------------
# 2. IDENTITÀ DELL'UTENTE (UID e GID)
# ------------------------------------------------------------------------------
# I computer non leggono i nomi ("mario"), leggono i numeri (501).
# Su macOS, il primo utente creato ha solitamente UID 501. Root è sempre 0.

echo "----------------------------------------------------------------"
echo "--- 2. UTENTE E GRUPPO (UID / GID) ---"

# Variabile $UID : Variabile di sola lettura di Bash (Standard).
echo "Il mio UID numerico è: $UID"

# Comando 'id' : Lo strumento principale per queste info.
# -u = User ID
# -n = Name (mostra il nome invece del numero)
# -g = Group ID (principale)
# -G = Tutti i gruppi a cui appartengo

MY_USER_NAME=$(id -un)
MY_USER_ID=$(id -u)
MY_GROUP_ID=$(id -g)

echo "Nome Utente (id -un): $MY_USER_NAME"
echo "ID Utente (id -u):    $MY_USER_ID"
echo "ID Gruppo (id -g):    $MY_GROUP_ID"

# ------------------------------------------------------------------------------
# 3. REAL UID vs EFFECTIVE UID (EUID) - SICUREZZA
# ------------------------------------------------------------------------------
# UID (Real): Chi ha lanciato il processo.
# EUID (Effective): Quali permessi sta usando il processo.
#
# Scenario: Esegui 'passwd'. Tu sei "mario" (UID 501), ma 'passwd' deve modificare
# file di sistema, quindi gira come "root" (EUID 0). Questo è il SetUID.

echo "----------------------------------------------------------------"
echo "--- 3. EFFECTIVE UID (EUID) ---"

# Bash fornisce la variabile $EUID.
echo "Il mio Effective UID è: $EUID"

# SCENARIO ESAME: "Controlla se lo script è eseguito come root"
# Root ha sempre ID 0.

if [ "$EUID" -eq 0 ]; then
    echo "STATUS: Sono ROOT (Superuser). Posso fare tutto."
else
    echo "STATUS: Sono un utente normale (UID $EUID). Accesso limitato."
    # Negli script di amministrazione, qui metteresti: exit 1
fi


# ------------------------------------------------------------------------------
# 4. OTTENERE ID DAI FILE (STAT SU MACOS)
# ------------------------------------------------------------------------------
# Scenario: "Verifica che il proprietario del file X sia lo stesso che esegue lo script".
# ATTENZIONE: 'stat' su macOS è DIVERSO da Linux.
# Linux: stat -c "%u" file
# macOS: stat -f "%u" file

echo "----------------------------------------------------------------"
echo "--- 4. ID DEI FILE (STAT BSD) ---"

touch file_prova.txt

# Ottenere UID proprietario del file
FILE_OWNER_ID=$(stat -f "%u" file_prova.txt)
FILE_GROUP_ID=$(stat -f "%g" file_prova.txt)

# Ottenere Nome proprietario (Human Readable)
# %Su = String User, %Sg = String Group
FILE_OWNER_NAME=$(stat -f "%Su" file_prova.txt)

echo "Il file 'file_prova.txt' appartiene a UID: $FILE_OWNER_ID ($FILE_OWNER_NAME)"

# Confronto Scripting
if [ "$UID" -eq "$FILE_OWNER_ID" ]; then
    echo "Perfetto: Il file è mio."
else
    echo "Attenzione: Il file non è mio."
fi


# ------------------------------------------------------------------------------
# 5. LISTA NUMERICA (LS -N)
# ------------------------------------------------------------------------------
# Quando fai script, non vuoi parsare nomi che possono contenere spazi.
# Vuoi i numeri.
# ls -l mostra i nomi.
# ls -n mostra i numeri (Numeric UID/GID).

echo "----------------------------------------------------------------"
echo "--- 5. LS NUMERICO (-n) ---"

echo "ls -l (Nomi):"
ls -l file_prova.txt

echo "ls -n (Numeri):"
ls -n file_prova.txt


# ------------------------------------------------------------------------------
# 6. SCRIPT AVANZATO: CAMBIO D'IDENTITÀ (SU / SUDO)
# ------------------------------------------------------------------------------
# Come eseguire un comando "come qualcun altro" dentro uno script.

echo "----------------------------------------------------------------"
echo "--- 6. ESECUZIONE COME ALTRO UTENTE ---"

# Scenario: Sei root, ma devi creare un file nella home di 'mario' con i SUOI permessi.
# Se lo fai come root, il file sarà di root e mario non potrà toccarlo.

TARGET_USER=$(id -un) # In questo test siamo noi stessi, ma immagina sia "mario"

# Esegui comando 'touch' come l'utente TARGET_USER
# sudo -u UTENTE COMANDO
# (Commentato perché richiede password se non configurato)
# sudo -u "$TARGET_USER" touch file_di_mario.txt

# Metodo 'su' (Switch User) - Meno usato negli script non interattivi
# su - "$TARGET_USER" -c "ls -l"


# ==============================================================================
# 🧩 SCENARI D'ESAME REALI E TRUCCHI
# ==============================================================================

echo "----------------------------------------------------------------"
echo "--- SCENARI D'ESAME ---"

# SCENARIO A: SCRIPT "SOLO ROOT"
# ------------------------------
# "Lo script deve interrompersi se non lanciato con sudo."
# Codice da copiare:
# if [ "$(id -u)" -ne 0 ]; then
#    echo "Errore: Questo script richiede privilegi di root."
#    exit 1
# fi

# SCENARIO B: "UCCIDI IL PADRE"
# ------------------------------
# "Se si verifica un errore critico, termina anche la shell che ha lanciato lo script."
# kill -9 $PPID

# SCENARIO C: TROVARE TUTTI I FILE DI UN UTENTE (UID)
# ------------------------------
# "Trova tutti i file che appartengono all'utente corrente nella cartella /tmp"
# find /tmp -user "$UID" 2>/dev/null

# SCENARIO D: CONTROLLO APPARTENENZA GRUPPO
# ------------------------------
# "Verifica se l'utente corrente fa parte del gruppo 'admin' (GID 80 su Mac)."
# id -G stampa tutti i gruppi. grep cerca 80.
if id -G | grep -q "\b80\b"; then
    echo "L'utente è un amministratore (Gruppo 80)."
else
    echo "L'utente è standard."
fi


# ==============================================================================
# ⚠️ TABELLA RIEPILOGATIVA VARIABILI E COMANDI
# ==============================================================================
# | ENTITÀ | VARIABILE BASH | COMANDO PER OTTENERLO  | FORMATO STAT (MAC) |
# |--------|----------------|------------------------|--------------------|
# | PID    | $$             | -                      | -                  |
# | PPID   | $PPID          | ps -p $$ -o ppid       | -                  |
# | UID    | $UID           | id -u                  | %u                 |
# | EUID   | $EUID          | id -u (spesso uguale)  | -                  |
# | GID    | -              | id -g                  | %g                 |
# | Nome   | $USER          | id -un                 | %Su                |

# Pulizia
rm -f file_prova.txt
echo "----------------------------------------------------------------"
echo "Tutorial 13.5 (IDs) Completato."