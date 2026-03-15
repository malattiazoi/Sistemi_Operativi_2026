#!/bin/bash

# ==============================================================================
# 08. GREP MASTER CLASS: RICERCA E REGEX (MACOS EDITION)
# ==============================================================================
# OBIETTIVO:
# Diventare maestri nel filtrare testo.
# grep = Global Regular Expression Print.
#
# DIFFERENZE MACOS (BSD) vs LINUX (GNU):
# 1. Regex Estese: Su Mac DEVI usare 'grep -E' per usare simboli come +, ?, |.
#    Senza -E, vengono trattati come testo normale.
# 2. Perl Regex (-P): Su Mac NON ESISTE di default. Usa -E.
# 3. Colori: Su Mac si usa --color=auto (spesso di default, ma buono saperlo).
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. SETUP AMBIENTE DI TEST
# ------------------------------------------------------------------------------
# Creiamo file sporchi pieni di dati eterogenei per testare i filtri.

echo "--- Creazione File di Test ---"

mkdir -p logs
cat <<EOF > logs/server.log
[INFO] 2024-01-01 10:00:01 - Server avviato con successo.
[DEBUG] Variabile x = 10
[ERROR] 2024-01-01 10:05:00 - Connessione al DB fallita (Timeout).
[INFO] Utente 'mario' loggato da IP 192.168.1.50
[WARNING] Spazio disco basso: 95% utilizzato.
[ERROR] 2024-01-01 10:15:00 - NullPointerException nel modulo Auth.
[INFO] Utente 'luigi' loggato da IP 10.0.0.1
EOF

cat <<EOF > logs/utenti.txt
mario.rossi@email.com
luigi.verdi@test.it
anna-bianchi@studio.org
account_falso_senza_chiocciola.com
admin@localhost
EOF

cat <<EOF > logs/codici.txt
ID: AB-123
ID: XY-999
ID: ERR-000
Codice segreto: 445566
EOF

echo "File creati in ./logs/"


# ==============================================================================
# 1. I FLAG FONDAMENTALI (BASI)
# ==============================================================================
# Questi salvano la vita nel 90% dei casi semplici.

echo "----------------------------------------------------------------"
echo "--- 1. FLAG BASE ---"

# 1.1 Case Insensitive (-i)
# Ignora la differenza tra maiuscole e minuscole.
echo "Cerca 'error' (minuscolo) ignorando il case:"
grep -i "error" logs/server.log

# 1.2 Invert Match (-v)
# Mostra tutto ciò che NON corrisponde. Utile per pulire i log.
echo "Mostra tutto tranne le righe [INFO]:"
grep -v "\[INFO\]" logs/server.log

# 1.3 Count (-c)
# Conta le righe invece di mostrarle.
echo "Numero di errori trovati:"
grep -c "ERROR" logs/server.log

# 1.4 Line Number (-n)
# Ti dice a che riga si trova il match (utile per andare a modificare il file).
echo "Dove sono i WARNING?"
grep -n "WARNING" logs/server.log


# ==============================================================================
# 2. OUTPUT MIRATO (ESTRAZIONE DATI)
# ==============================================================================
# A volte non vuoi tutta la riga, vuoi solo il pezzo che combacia.

echo "----------------------------------------------------------------"
echo "--- 2. OUTPUT CONTROLLATO (-o, -l) ---"

# 2.1 Only Matching (-o) - FONDAMENTALE
# Stampa SOLO la parte della riga che corrisponde al pattern.
# Esempio: Estrarre solo gli indirizzi IP.
# Regex IP base: [0-9]+.[0-9]+.[0-9]+.[0-9]+
echo "Estraggo solo gli IP:"
grep -E -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" logs/server.log

# 2.2 Files with Matches (-l) - FONDAMENTALE PER SCRIPT
# Non mostra il contenuto, ma solo il NOME DEL FILE che contiene la stringa.
# Utile se cerchi "quale file contiene la password?".
echo "Quali file contengono la parola 'mario'?"
grep -l "mario" logs/*

# 2.3 Files WITHOUT Matches (-L)
# Il contrario: quali file NON contengono la stringa?
echo "Quali file NON contengono 'ERROR'?"
grep -L "ERROR" logs/*


# ==============================================================================
# 3. REGEX ESTESE (-E) - LA POTENZA VERA
# ==============================================================================
# Su macOS, grep base è limitato.
# Per usare +, ?, |, {}, () DEVI usare -E.
# Mettilo SEMPRE. È buona pratica.

echo "----------------------------------------------------------------"
echo "--- 3. REGEX EXTENDED (-E) ---"

# 3.1 OR Logico (|)
# Cerca "ERROR" OPPURE "WARNING".
grep -E "ERROR|WARNING" logs/server.log

# 3.2 Quantificatori (+, ?, *)
# + = Uno o più (es. [0-9]+ significa "un numero intero intero")
# ? = Zero o uno (opzionale)
# * = Zero o più (qualsiasi cosa)

echo "Cerca codici formati da lettere, trattino e numeri (es. AB-123):"
# [A-Z]+  = Una o più maiuscole
# -       = Un trattino
# [0-9]+  = Uno o più numeri
grep -E "[A-Z]+-[0-9]+" logs/codici.txt

# 3.3 Ancore (^ e $)
# ^ = Inizio riga
# $ = Fine riga
echo "Righe che INIZIANO con [INFO]:"
grep -E "^\[INFO\]" logs/server.log

# 3.4 Gruppi e Ripetizioni {}
# Cerca esattamente 3 cifre: {3}
echo "Codici con esattamente 3 cifre finali:"
grep -E "[0-9]{3}" logs/codici.txt


# ==============================================================================
# 4. CONTESTO (-A, -B, -C) - LEGGERE INTORNO
# ==============================================================================
# Se trovi un errore, vuoi sapere cosa è successo PRIMA e DOPO.

echo "----------------------------------------------------------------"
echo "--- 4. CONTESTO (After, Before, Context) ---"

# -A N : After (Mostra N righe DOPO il match)
# -B N : Before (Mostra N righe PRIMA del match)
# -C N : Context (Mostra N righe PRIMA e DOPO)

echo "Mostra l'errore e la riga successiva (-A 1):"
grep -A 1 "NullPointerException" logs/server.log


# ==============================================================================
# 5. RICERCA RICORSIVA (-r) - CERCARE NELLE CARTELLE
# ==============================================================================
# Cerca in tutti i file dentro una directory e sottodirectory.

echo "----------------------------------------------------------------"
echo "--- 5. RICORSIONE (-r) ---"

# Cerca "mario" in tutta la cartella logs
grep -r "mario" logs/

# Escludere file o cartelle (--exclude)
# Utile per non cercare nei file .log o nelle cartelle .git
grep -r --exclude="*.log" "mario" logs/


# ==============================================================================
# 6. GREP NEGLI SCRIPT (EXIT CODES e -q)
# ==============================================================================
# Come usare grep dentro un 'if'?
# grep restituisce:
# Exit Code 0: Trovato match.
# Exit Code 1: Nessun match.
# Exit Code 2: Errore (file non trovato).

echo "----------------------------------------------------------------"
echo "--- 6. GREP NEGLI SCRIPT (-q) ---"

# -q (Quiet/Silent): Non stampa nulla, esce solo con 0 o 1.
# Perfetto per gli if.

USER_CHECK="admin"
if grep -q "$USER_CHECK" logs/utenti.txt; then
    echo "L'utente $USER_CHECK esiste nel sistema."
else
    echo "L'utente $USER_CHECK NON trovato."
fi


# ==============================================================================
# 🧩 SCENARI D'ESAME REALI
# ==============================================================================

echo "----------------------------------------------------------------"
echo "--- SCENARI D'ESAME ---"

# SCENARIO A: Validazione Email (Regex Complessa)
# Pattern: testo @ testo . estensione
# [a-zA-Z0-9._-]+  = Utente
# @                = Chiocciola
# [a-zA-Z0-9.-]+   = Dominio
# \.               = Punto (escapato)
# [a-zA-Z]{2,}     = Estensione (almeno 2 lettere)

echo "Validazione Email:"
grep -E "^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" logs/utenti.txt

# SCENARIO B: Trovare Errori in una fascia oraria
# Supponiamo di cercare errori tra le 10:00 e le 10:09.
# Pattern Regex: 10:0[0-9] (copre 10:00 - 10:09)
echo "Errori tra le 10:00 e le 10:09:"
grep "ERROR" logs/server.log | grep -E "10:0[0-9]"

# SCENARIO C: Parola Intera (-w)
# Se cerchi "ID", non vuoi trovare "VALIDO" o "ANDROID".
# -w (Word match): Cerca solo parole intere.
echo "Word Match (-w):"
echo "VALIDO" > test_word.txt
echo "ID" >> test_word.txt
grep -w "ID" test_word.txt
rm test_word.txt


# ==============================================================================
# ⚠️ TABELLA RIEPILOGATIVA (FLAG MACOS)
# ==============================================================================
# | FLAG | NOME ESTESO  | DESCRIZIONE                                |
# |------|--------------|--------------------------------------------|
# | -i   | --ignore-case| Ignora maiuscole/minuscole.                |
# | -v   | --invert     | Inverte il match (stampa cosa non matcha). |
# | -r   | --recursive  | Cerca nelle sottocartelle.                 |
# | -E   | --extended   | Abilita Regex Avanzate (+ ? | {}). CRITICO.|
# | -o   | --only       | Stampa solo il pezzo trovato (non la riga).|
# | -l   | --files-with | Stampa solo i NOMI dei file.               |
# | -n   | --line-number| Stampa il numero di riga.                  |
# | -c   | --count      | Conta i match totali.                      |
# | -q   | --quiet      | Silenzioso (solo Exit Code per if).        |
# | -w   | --word-regexp| Cerca parole intere (no sottostringhe).    |

# Pulizia
rm -rf logs
echo "----------------------------------------------------------------"
echo "Tutorial Grep Completato."

# ==============================================================================
# GUIDA AL COMANDO 'grep' (RICERCA E FILTRO TESTO)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SINTASSI BASE
# ------------------------------------------------------------------------------
# grep [OPZIONI] "PATTERN" [FILE]

# Cerca la parola "errore" (case sensitive) nel file log.txt
# grep "errore" log.txt

# ------------------------------------------------------------------------------
# 2. OPZIONI "MUST-HAVE" PER L'ESAME
# ------------------------------------------------------------------------------
# -i : Ignore case (non distingue tra maiuscole e minuscole)
# -v : Invert match (mostra le righe che NON contengono il pattern)
# -n : Line number (mostra il numero della riga dove è stata trovata la parola)
# -c : Count (conta quante righe corrispondono, NON stampa le righe)
# -r : Recursive (cerca in tutti i file di una cartella e sottocartelle)
# -l : List files (mostra solo i nomi dei file che contengono il pattern)
# -w : Word (cerca la parola esatta, non come parte di un'altra parola)

# ------------------------------------------------------------------------------
# 3. ESEMPI AVANZATI E COMBINAZIONI
# ------------------------------------------------------------------------------

# Cerca ricorsivamente "TODO" in tutti i file .c della cartella corrente:
grep -r "TODO" *.c

# Conta quanti utenti hanno la shell /bin/bash nel sistema:
grep -c "/bin/bash" /etc/passwd

# Escludi tutte le righe di commento (che iniziano con #) e le righe vuote:
grep -v "^#" file.conf | grep -v "^$"

# ------------------------------------------------------------------------------
# 4. IL CONTESTO (Utilissimo per il Debug)
# ------------------------------------------------------------------------------
# -A N : Mostra N righe DOPO (After) la riga trovata
# -B N : Mostra N righe PRIMA (Before) la riga trovata
# -C N : Mostra N righe PRIMA e DOPO (Context)

# Esempio: trova "ERROR" e mostrami anche le 3 righe successive per capire la causa
grep -A 3 "ERROR" log_sistema.txt

# ------------------------------------------------------------------------------
# 5. GREP E LE REGEX (ERE)
# ------------------------------------------------------------------------------
# Usa sempre -E per poter usare i metacaratteri moderni (+, ?, |, parentesi)
# senza doverli "escapare" con il backslash.

# Trova righe che contengono "mela" OPPURE "pera"
grep -E "mela|pera" inventario.txt

# Grep in Pipe: È il re delle pipe. Se devi contare quanti processi di sistema sono attivi:
ps aux | grep -v "grep" | grep "root" | wc -l (Nota: grep -v #"grep" serve a non contare il 
#comando grep stesso nella lista dei processi!).

# Colori: Se sei al terminale e non capisci dove sia la parola, usa 
grep --color=auto.

# Regex e Ancore: Ricorda sempre ^ (inizio riga) e $ (fine riga). 
# Se cerchi grep "^admin" trovi l'utente admin, se cerchi grep "admin$" 
# trovi chi ha admin alla fine (magari un percorso).