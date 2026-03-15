#!/bin/bash

# ==============================================================================
# 34. AWK: CALCOLO E SOMMA COLONNE (FONDAMENTALE PER ESAME 13)
# ==============================================================================
# DESCRIZIONE:
# AWK non è solo un comando, è un linguaggio di programmazione intero dedicato
# all'elaborazione di testi strutturati a colonne (come l'output di `ps` o `ls`).
#
# PERCHÉ SERVE ALL'ESAME:
# 1. Sommare numeri in una colonna (Es: "Totale RAM usata", "Totale %CPU").
# 2. Filtrare righe in base a condizioni numeriche ("PID > 1000").
# 3. Riformattare l'output ("Stampa solo colonna 1 e 5").
#
# AMBIENTE:
# macOS usa BSD awk. È standard POSIX e va benissimo per gli esami.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SETUP DATI DI PROVA (PER CAPIRE COME FUNZIONA)
# ------------------------------------------------------------------------------
# Creiamo un file 'processi_finti.txt' che simula l'output di un comando 'ps'.
# Colonne: UTENTE, PID, %CPU, %MEM, COMANDO

cat <<EOF > processi_finti.txt
root      1    0.5  0.1  init
mlazoi    501  12.5 4.0  chrome
mlazoi    502  8.2  3.5  chrome
mlazoi    503  0.1  0.5  bash
daemon    600  0.0  0.1  syslogd
mlazoi    999  25.0 10.0 video_editor
EOF

echo "--- File di prova creato: processi_finti.txt ---"
cat processi_finti.txt
echo "------------------------------------------------"


# ------------------------------------------------------------------------------
# 2. ESTRAZIONE DI COLONNE (LA BASE)
# ------------------------------------------------------------------------------
# awk '{print $N}' -> Stampa la colonna numero N.
# $0 indica "tutta la riga intera".
# $1 = prima parola, $2 = seconda parola, ecc.

echo "--- Esempio 1: Stampa solo Utente (col 1) e Comando (col 5) ---"
awk '{print $1, $5}' processi_finti.txt

# Esempio con testo personalizzato aggiunto nella stampa:
echo "--- Esempio 2: Aggiungere testo descrittivo ---"
awk '{print "Il processo " $5 " appartiene a " $1}' processi_finti.txt


# ------------------------------------------------------------------------------
# 3. FILTRAGGIO CONDIZIONALE (MEGLIO DI GREP)
# ------------------------------------------------------------------------------
# Grep cerca stringhe. AWK può cercare NUMERI e CONDIZIONI.
# Sintassi: awk 'CONDIZIONE { AZIONE }'

echo "--- Esempio 3: Stampa solo processi con %CPU > 5.0 ---"
# Nota: Awk gestisce automaticamente i numeri decimali.
awk '$3 > 5.0 {print $5, "usa troppa CPU:", $3}' processi_finti.txt

echo "--- Esempio 4: Stampa solo i processi dell'utente 'mlazoi' ---"
# L'operatore '==' confronta stringhe esatte.
awk '$1 == "mlazoi" {print $0}' processi_finti.txt


# ------------------------------------------------------------------------------
# 4. CALCOLI MATEMATICI E SOMME (SOLUZIONE ESAME 13)
# ------------------------------------------------------------------------------
# Questo è il cuore dell'Esame 13: "Restituisca la somma delle percentuali".
# Logica di AWK:
# BEGIN { ... } -> Eseguito PRIMA di leggere il file (inizializzazione).
# { ... }       -> Eseguito PER OGNI riga (accumulo).
# END { ... }   -> Eseguito ALLA FINE (stampa risultato).

echo "--- Esempio 5: Calcola la somma totale della colonna %CPU ($3) ---"

awk 'BEGIN {sum=0} {sum+=$3} END {print "Totale CPU usata:", sum}' processi_finti.txt

# Esempio avanzato: Calcola la MEDIA della memoria ($4)
# NR è una variabile interna che conta il numero di righe lette (Number of Records).
echo "--- Esempio 6: Calcola la media della memoria usata ---"
awk '{total += $4} END {print "Media Memoria:", total/NR}' processi_finti.txt


# ------------------------------------------------------------------------------
# 5. GESTIONE SEPARATORI (FLAG -F)
# ------------------------------------------------------------------------------
# Di default awk usa spazi/tab come separatori.
# Se hai un file CSV (virgole) o /etc/passwd (due punti), usa -F.

echo "root:x:0:0:System Administrator:/var/root:/bin/sh" > passwd_fake.txt

echo "--- Esempio 7: Parsing di file con separatore ':' ---"
# Senza -F stamperebbe tutta la riga come $1. Con -F: divide correttamente.
awk -F: '{print "Utente:", $1, "- Shell:", $7}' passwd_fake.txt


# ------------------------------------------------------------------------------
# 6. VARIABILI SPECIALI (NF e NR)
# ------------------------------------------------------------------------------
# NR = Numero Riga corrente (1, 2, 3...)
# NF = Numero Campi (Fields) totali nella riga corrente (quante colonne ha).
# $NF = Il contenuto dell'ULTIMA colonna (molto utile se il numero di colonne varia).

echo "--- Esempio 8: Stampa numero riga e ultima colonna ---"
awk '{print "Riga " NR ": Ultimo campo è " $NF}' processi_finti.txt


# ------------------------------------------------------------------------------
# 7. FORMATTAZIONE OUTPUT (PRINTF)
# ------------------------------------------------------------------------------
# 'print' stampa con formattazione standard.
# 'printf' (come in C) permette di allineare le colonne perfettamente.
# %-10s = Stringa allineata a sinistra, spazio 10 caratteri.
# %.2f  = Numero float con 2 decimali.

echo "--- Esempio 9: Tabella formattata perfettamente ---"
awk '{printf "PID: %-5s | CPU: %5.1f%% | CMD: %s\n", $2, $3, $5}' processi_finti.txt


# ==============================================================================
# 🚀 SIMULAZIONE ESAME 13: SCRIPT "PSCMD"
# ==============================================================================
# Testo Esame 13:
# "Scrivere uno script di nome pscmd che prenda come argomento il nome di un comando
# e restituisca la somma delle percentuali di CPU utilizzate da tutte le istanze..."

echo "--- SIMULAZIONE REALE ESAME 13 ---"

# Creiamo lo script pscmd.sh al volo
cat << 'EOF' > pscmd.sh
#!/bin/bash

# 1. Controllo Argomenti
# Verifichiamo se l'utente ha passato il nome del comando ($1).
# Se $1 è vuoto (-z), diamo errore e usciamo.

if [ -z "$1" ]; then
    echo "Errore: Devi specificare il nome di un comando."
    echo "Uso: ./pscmd.sh <nome_comando>"
    exit 1
fi

TARGET_CMD="$1"

# 2. Ottenimento Dati
# Usiamo 'ps -A' per tutti i processi.
# Usiamo '-o comm,%cpu' per stampare SOLO nome comando e percentuale CPU.
# (Su Linux è spesso %cpu, su Mac a volte pcpu, ma %cpu di solito va).
#
# ps output header:
# COMM      %CPU
# bash       0.0
# chrome    12.0

# 3. Pipeline di Calcolo
# - ps: genera i dati
# - grep: tiene solo le righe che contengono il comando cercato ($TARGET_CMD)
# - awk: somma la seconda colonna ($2) che contiene i numeri

echo "Calcolo CPU totale per: $TARGET_CMD..."

# Nota: grep potrebbe trovare anche se stesso o lo script pscmd.
# awk somma la colonna $2.
# Se grep non trova nulla, awk non riceve nulla e stampa 0 (o nulla).

# Soluzione robusta per Mac:
ps -A -o comm,%cpu | grep "$TARGET_CMD" | awk '{sum+=$2} END {print sum}'

EOF

# Rendiamo eseguibile lo script generato
chmod +x pscmd.sh

# Testiamo lo script con i dati finti (simulando ps tramite cat per il test)
# In un caso reale, lo script usa 'ps' vero. Qui "trucco" grep per fargli leggere il file finto
echo "Test con dati finti per 'chrome':"
grep "chrome" processi_finti.txt | awk '{sum+=$3} END {print sum}'
# Output atteso: 12.5 + 8.2 = 20.7

echo "--- Fine Simulazione ---"


# ==============================================================================
# 📊 TABELLA FLAG E VARIABILI AWK
# ==============================================================================
# | ELEMENTO       | DESCRIZIONE                                            |
# |----------------|--------------------------------------------------------|
# | -F "sep"       | Imposta il separatore di campo (es. -F: o -F,)         |
# | $0             | Intera riga corrente                                   |
# | $1, $2...      | Singoli campi (colonne)                                |
# | $NF            | Ultimo campo della riga                                |
# | NR             | Number of Records (numero riga corrente)               |
# | NF             | Number of Fields (quante colonne ha la riga)           |
# | BEGIN { ... }  | Blocco eseguito una volta sola all'INIZIO              |
# | END { ... }    | Blocco eseguito una volta sola alla FINE               |
# | length($0)     | Lunghezza della riga in caratteri                      |
# | print          | Stampa semplice (con a capo)                           |
# | printf         | Stampa formattata (come in C)                          |

# ==============================================================================
# 💡 SUGGERIMENTI E TRUCCHI PER L'ESAME
# ==============================================================================

# --- TRUCCO 1: SALTARE L'INTESTAZIONE (HEADER) ---
# Se fai 'ps aux | awk ...', la prima riga contiene i titoli ("USER", "PID"...).
# Se provi a sommare "PID" + 10, awk dà errore o ignora.
# Per saltare la prima riga usa 'NR > 1':
# awk 'NR > 1 { sum += $3 } END { print sum }' file_con_header.txt

# --- TRUCCO 2: SOMMARE CONDIZIONATA ---
# "Somma la CPU solo se l'utente è root".
# ps aux | awk '$1 == "root" { sum += $3 } END { print sum }'

# --- TRUCCO 3: USARE VARIABILI BASH DENTRO AWK ---
# Passare una variabile bash ($SOGLIA) dentro awk non è diretto.
# Metodo 1 (Flag -v):
# soglia=10
# awk -v s="$soglia" '$3 > s { print $0 }' file.txt
# (Qui 's' diventa una variabile interna di awk che vale 10).

# --- TRUCCO 4: AWK COME GREP POTENZIATO ---
# Grep trova la riga se c'è la stringa ovunque.
# Awk può cercare la stringa SOLO in una colonna specifica.
# awk '$5 == "chrome" { print $0 }' (Cerca chrome solo nella colonna 5).