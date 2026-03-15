#!/bin/bash

# ==============================================================================
# 49. JOT: SEQUENZE, RANDOM E DATI (MACOS / BSD POWERHOUSE)
# ==============================================================================
# OBIETTIVO:
# Generare numeri sequenziali, CASUALI (Random) o ripetuti.
# È lo strumento nativo di macOS (BSD) molto più potente di 'seq'.
#
# SINTASSI STRANA (Posizionale):
# jot [reps [begin [end [s]]]]
# 1. reps  = Quanti numeri generare (Ripetizioni).
# 2. begin = Da dove iniziare.
# 3. end   = Dove finire.
# 4. s     = Step (o seed).
#
# Se metti '-', jot calcola quel valore automaticamente.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SEQUENZE STANDARD (COME SEQ)
# ------------------------------------------------------------------------------

echo "--- 1. JOT SEQUENZIALE ---"

# Genera 5 numeri, partendo da 1.
# (jot calcola automaticamente la fine o lo step)
echo "5 numeri partendo da 1:"
jot 5 1

# Genera 3 numeri, da 10 a 20.
echo "3 numeri da 10 a 20 (Step calcolato auto):"
jot 3 10 20

# Genera numeri da 1 a 5 (Se vuoi specificare inizio e fine ma non quanti)
# Il primo argomento '-' dice "calcola tu quante ripetizioni servono".
# jot - 1 5
echo "Da 1 a 3 (Stile seq):"
jot - 1 3


# ------------------------------------------------------------------------------
# 2. GENERAZIONE RANDOM (-r) - IL VERO POTERE
# ------------------------------------------------------------------------------
# seq non può fare random. jot sì.
# Indispensabile per creare dati di test o simulare eventi.
# Sintassi: jot -r [QUANTI] [MIN] [MAX]

echo "----------------------------------------------------------------"
echo "--- 2. RANDOM DATA (-r) ---"

echo "Un numero casuale tra 1 e 100:"
jot -r 1 1 100

echo "3 Numeri casuali tra 1000 e 9999 (PIN generator):"
jot -r 3 1000 9999

# Generare un file di dati casuali per test (es. per sort o calcoli)
echo "Genero 5 numeri random in 'random.dat'..."
jot -r 5 1 100 > random.dat
cat random.dat
rm random.dat


# ------------------------------------------------------------------------------
# 3. DATI RIPETUTI E ASCII (-b, -c)
# ------------------------------------------------------------------------------
# Vuoi creare un file pieno di "A"? O ripetere una parola 10 volte?

echo "----------------------------------------------------------------"
echo "--- 3. RIPETIZIONE E CARATTERI ---"

# -b : Word to print (Ripete una parola)
echo "Ripeti 'Ciao' 3 volte:"
jot -b "Ciao" 3

# -c : Character mode (Converte numeri in ASCII)
# Genera lettere dalla A (65) alla E (69)
echo "ASCII da 65 a 69:"
jot -c 5 65


# ------------------------------------------------------------------------------
# 4. GENERAZIONE PASSWORD CASUALE (MIX -r e -c)
# ------------------------------------------------------------------------------
# Generiamo 8 caratteri ASCII casuali tra 33 (!) e 126 (~).
# -r = Random
# -c = Output come carattere
# -s = Separatore (stringa vuota "" per unirli)

echo "----------------------------------------------------------------"
echo "--- 4. PASSWORD GENERATOR ---"

# Genera 8 caratteri, tra ASCII 33 e 126, separati da nulla
echo "Password Casuale:"
jot -r -c -s "" 8 33 126
echo "" # A capo


# ------------------------------------------------------------------------------
# 5. FORMATTAZIONE (-w)
# ------------------------------------------------------------------------------
# Come seq -f, ma usa % come placeholder del numero se la stringa contiene altro.

echo "----------------------------------------------------------------"
echo "--- 5. FORMATTAZIONE (-w) ---"

echo "File sequenziali:"
jot -w "log_%d.txt" 3 1
# Output: log_1.txt, log_2.txt...


# ==============================================================================
# 🧩 SCENARIO ESAME: BRUTE FORCE (191a)
# ==============================================================================
# "Trova una stringa casuale il cui MD5 inizia per..."
# Usiamo jot -r per generare candidati infiniti (o tanti) in pipe.

echo "----------------------------------------------------------------"
echo "--- SCENARIO BRUTE FORCE ---"
# Genera 5 candidati random e calcola il loro hash
jot -r 5 10000 99999 | while read NUM; do
    HASH=$(md5 -q -s "$NUM")
    echo "Num: $NUM -> Hash: $HASH"
done


# ==============================================================================
# ⚠️ TABELLA JOT vs SEQ
# ==============================================================================
# | FUNZIONE         | SEQ (LINUX/BREW)      | JOT (MACOS BSD)      |
# |------------------|-----------------------|----------------------|
# | Sequenza 1-10    | seq 1 10              | jot 10 1             |
# | Random           | shuf -i 1-10 -n 1     | jot -r 1 1 10        |
# | Caratteri ASCII  | (complesso con printf)| jot -c ...           |
# | Ripetizione      | yes "txt" \| head -n N| jot -b "txt" N       |

echo "----------------------------------------------------------------"
echo "Tutorial 49 (Jot) Completato."