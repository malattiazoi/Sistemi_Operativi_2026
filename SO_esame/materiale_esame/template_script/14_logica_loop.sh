#!/bin/bash

# ==============================================================================
#   MANUALE DI RIFERIMENTO RAPIDO BASH 3.2 (READ-ONLY)
#   Struttura: Sintassi, Operatori, Cicli, Variabili Speciali.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. TEST SUI FILE (File Operators)
# Da usare dentro [ ... ] o [[ ... ]]
# ------------------------------------------------------------------------------
file="./mio_file.txt"

if [ -e "$file" ]; then   # -e : EXIST (Esiste? File, dir, link, qualsiasi cosa)
    :
fi
if [ -f "$file" ]; then   # -f : FILE (È un file regolare? No directory)
    :
fi
if [ -d "$dir" ];  then   # -d : DIRECTORY (È una cartella?)
    :
fi
if [ -s "$file" ]; then   # -s : SIZE (Ha dimensione > 0? Non è vuoto?)
    :
fi
if [ -r "$file" ]; then   # -r : READABLE (Posso leggerlo?)
    :
fi
if [ -w "$file" ]; then   # -w : WRITABLE (Posso scriverci/cancellarlo?)
    :
fi
if [ -x "$file" ]; then   # -x : EXECUTABLE (È eseguibile/script?)
    :
fi
if [ -L "$file" ]; then   # -L : LINK (È un collegamento simbolico?)
    :
fi

# ------------------------------------------------------------------------------
# 2. TEST SULLE STRINGHE (String Operators)
# IMPORTANTE: Metti sempre le virgolette "$var" dentro [ ... ]
# ------------------------------------------------------------------------------
str=""

if [ -z "$str" ]; then    # -z : ZERO length (Vero se la stringa è VUOTA "")
    :
fi
if [ -n "$str" ]; then    # -n : NON-ZERO (Vero se la stringa contiene qualcosa)
    :
fi
if [ "$a" == "$b" ]; then # == : UGUALE (In Bash si usa ==, in sh standard =)
    :
fi
if [ "$a" != "$b" ]; then # != : DIVERSO
    :
fi

# SOLO CON DOPPIE QUADRE [[ ... ]]
# < e > per ordine alfabetico richiedono [[ ]] altrimenti vanno escapati
if [[ "$a" < "$b" ]]; then  # Minore alfabetico (ASCII)
    :
fi
if [[ "$str" =~ ^[0-9]+$ ]]; then # =~ : REGEX MATCH (Niente virgolette a destra!)
    :
fi

# ------------------------------------------------------------------------------
# 3. TEST NUMERICI (Integer Operators)
# Bash 3.2 gestisce SOLO interi. Niente virgole.
# ------------------------------------------------------------------------------

# METODO A: Sintassi Classica [ ... ]
# Richiede le lettere (-eq, -lt...)
n=10
if [ "$n" -eq 10 ]; then  # -eq : EQUAL (Uguale)
    :
fi
if [ "$n" -ne 5 ]; then   # -ne : NOT EQUAL (Diverso)
    :
fi
if [ "$n" -gt 5 ]; then   # -gt : GREATER THAN (Maggiore >)
    :
fi
if [ "$n" -lt 20 ]; then  # -lt : LESS THAN (Minore <)
    :
fi
if [ "$n" -ge 10 ]; then  # -ge : GREATER EQUAL (Maggiore o uguale >=)
    :
fi
if [ "$n" -le 10 ]; then  # -le : LESS EQUAL (Minore o uguale <=)
    :
fi

# METODO B: Doppie Tonde (( ... )) - Consigliato per matematica
# Qui puoi usare i simboli matematici e omettere i dollari
if (( n > 5 )); then      # >  : Maggiore
    :
fi
if (( n == 10 )); then    # == : Uguale
    :
fi
if (( n != 0 )); then     # != : Diverso
    :
fi
# Nota: (( n++ )) incrementa, (( n-- )) decrementa, (( a = b + c )) assegna

# ------------------------------------------------------------------------------
# 4. LOGICA BOOLEANA (AND / OR / NOT)
# ------------------------------------------------------------------------------

# Dentro [[ ... ]] (Consigliato)
if [[ -f "$file" && ! -w "$file" ]]; then  # && = AND, ! = NOT
    echo "Esiste ma è protetto da scrittura"
fi

if [[ "$a" == "x" || "$a" == "y" ]]; then  # || = OR
    echo "È x oppure y"
fi

# Dentro [ ... ] (Vecchio stile)
if [ -f "$file" -a -w "$file" ]; then      # -a = AND
    :
fi
if [ "$a" = "x" -o "$a" = "y" ]; then      # -o = OR
    :
fi

# ------------------------------------------------------------------------------
# 5. CICLI (LOOPS)
# ------------------------------------------------------------------------------

# FOR - Caso 1: Iterare su file (Globbing)
for file in *.txt; do
    echo "Trovato: $file"
done

# FOR - Caso 2: Iterare su lista esplicita
for nome in "Mario" "Luca" "Anna"; do
    echo "Utente: $nome"
done

# FOR - Caso 3: Numeri (Bash 3.2 Sequence)
for i in $(seq 1 10); do
    echo "Numero $i"
done

# FOR - Caso 4: Stile C (Matematico)
for (( i=0; i<10; i++ )); do
    echo "Indice $i"
done

# WHILE (Esegue finché la condizione è VERA)
count=0
while [ $count -lt 5 ]; do
    ((count++))
done

# UNTIL (Esegue finché la condizione è FALSA - Opposto di While)
until [ -f "stop.txt" ]; do
    echo "Aspetto che qualcuno crei stop.txt..."
    sleep 1
done

# LETTURA FILE RIGA PER RIGA (Pattern Standard)
while read -r line; do
    echo "Letto: $line"
done < "input.txt"

# ------------------------------------------------------------------------------
# 6. CONTROLLO FLUSSO
# ------------------------------------------------------------------------------
for i in {1..10}; do
    if [ "$i" -eq 5 ]; then
        continue  # Salta questa iterazione, passa alla 6
    fi
    if [ "$i" -eq 8 ]; then
        break     # Interrompe tutto il ciclo ed esce
    fi
done

# CASE STATEMENT (Ottimo per menu o estensioni file)
case "$1" in
    start)
        echo "Avvio..."
        ;;        # IMPORTANTE: ;; chiude il blocco
    stop|kill)    # La pipe | significa OR
        echo "Arresto..."
        ;;
    *.tar)
        echo "Archivio Tar"
        ;;
    *)            # Default (se nient'altro corrisponde)
        echo "Opzione non valida"
        exit 1
        ;;
esac

# ------------------------------------------------------------------------------
# 7. VARIABILI SPECIALI (Magic Variables)
# ------------------------------------------------------------------------------
# $0   -> Nome dello script corrente
# $1   -> Primo argomento passato allo script
# $2   -> Secondo argomento... (e così via)
# $#   -> Numero TOTALE di argomenti passati
# $@   -> Tutti gli argomenti come lista separata (per i cicli: for arg in "$@")
# $* -> Tutti gli argomenti come stringa unica
# $?   -> Exit Status ultimo comando (0=OK, 1-255=Errore)
# $$   -> PID (Process ID) dello script corrente
# $!   -> PID dell'ultimo processo lanciato in background (&)
# $USER -> Utente corrente
# $HOME -> Cartella home
# $PWD  -> Directory corrente (come comando pwd)

# ------------------------------------------------------------------------------
# 8. MANIPOLAZIONE STRINGHE E PATH (Parameter Expansion)
# ------------------------------------------------------------------------------
path="/home/user/foto.jpg"

# ${var#pattern}  -> Rimuovi da SINISTRA (Shortest match)
# ${var##pattern} -> Rimuovi da SINISTRA (Longest match)
file="${path##*/}"    # Risultato: "foto.jpg" (Toglie tutto fino all'ultimo /)

# ${var%pattern}  -> Rimuovi da DESTRA (Shortest match)
# ${var%%pattern} -> Rimuovi da DESTRA (Longest match)
ext="${file##*.}"     # Risultato: "jpg" (Prende dopo l'ultimo punto)
name="${file%.*}"     # Risultato: "foto" (Toglie l'estensione)

# ${var:offset:length} -> Sottostringa
sub="${name:0:2}"     # Risultato: "fo" (Primi 2 caratteri)

# ${var/find/replace} -> Sostituzione (Una volta)
# ${var//find/replace} -> Sostituzione (Tutte le volte)
echo "${path/user/admin}"  # /home/admin/foto.jpg

# ${#var} -> Lunghezza stringa
len=${#name}          # 4

# ==============================================================================
# 9. PARAMETER EXPANSION (Manipolazione Avanzata Variabili)
#    Nota: Funziona tutto in Bash 3.2. Molto più veloce di sed/awk.
# ==============================================================================

# Variabili di esempio per i test
FILE="archivio.tar.gz"
PATH="/usr/local/bin/script.sh"
TESTO="Il gatto mangia il topo"
NULLA=""
NON_SETTATA="" # (Questa variabile esiste ma è vuota)
# (La variabile "PIPPOLINO" non è mai stata dichiarata)

# ------------------------------------------------------------------------------
# A. GESTIONE DEI VALORI DI DEFAULT (Fondamentale per la sicurezza)
# ------------------------------------------------------------------------------

# 1. ${var:-default} -> USA DEFAULT (Se vuota o unset)
#    Se $NULLA è vuota, stampa "Default". NON assegna il valore a $NULLA.
echo "${NULLA:-Default}"      # Stampa: "Default"

# 2. ${var:=default} -> ASSEGNA DEFAULT (Se vuota o unset)
#    Se $PIPPOLINO è unset, la imposta a "NuovoValore".
echo "${PIPPOLINO:=NuovoValore}"
echo "$PIPPOLINO"             # Ora PIPPOLINO vale "NuovoValore"

# 3. ${var:?messaggio} -> STOP ERROR (Se vuota o unset)
#    Utile per bloccare lo script se manca un parametro obbligatorio.
#    Esempio: DIR=${1:?Errore: manca la directory!}

# 4. ${var:+alternativa} -> USA ALTERNATIVA (Se SETTATA e non vuota)
#    Se c'è qualcosa in $TESTO, stampa "Esiste", altrimenti nulla.
echo "${TESTO:+Esiste}"       # Stampa: "Esiste"

# ------------------------------------------------------------------------------
# B. RIMOZIONE PATTERN (Tagliare pezzi di stringa)
#    Mnemonic: 
#    # (Hash) sta a sinistra sulla tastiera -> Taglia da SINISTRA (Inizio)
#    % (Percent) sta a destra sulla tastiera -> Taglia da DESTRA (Fine)
# ------------------------------------------------------------------------------

# 1. RIMOZIONE TESTA (Dall'inizio -> #)
#    ${var#pattern}  -> Shortest Match (La corrispondenza più corta)
#    ${var##pattern} -> Longest Match (La corrispondenza più lunga)

echo "${PATH#*/}"   # usr/local/bin/script.sh (Toglie fino al primo /)
echo "${PATH##*/}"  # script.sh (Toglie tutto fino all'ultimo / -> BASENAME)

# 2. RIMOZIONE CODA (Dalla fine -> %)
#    ${var%pattern}  -> Shortest Match
#    ${var%%pattern} -> Longest Match

echo "${FILE%.*}"   # archivio.tar (Toglie l'ultima estensione .gz)
echo "${FILE%%.*}"  # archivio (Toglie dalla prima estensione in poi .tar.gz)

# ------------------------------------------------------------------------------
# C. SOSTITUZIONE TESTO (Search & Replace)
# ------------------------------------------------------------------------------

# 1. ${var/trova/sostituisci} -> Una sola volta (la prima)
echo "${TESTO/il/un}"    # "un gatto mangia il topo"

# 2. ${var//trova/sostituisci} -> Globale (tutte le occorrenze)
echo "${TESTO//il/un}"   # "un gatto mangia un topo"

# 3. ${var/trova} -> Cancellazione (Sostituisci con nulla)
echo "${TESTO// topo}"   # "Il gatto mangia il"

# 4. Ancoraggi (Funzionano in Bash 3.2?) -> SÌ
#    ${var/#pattern/replace} -> Solo se all'INIZIO della stringa
#    ${var/%pattern/replace} -> Solo se alla FINE della stringa
echo "${FILE/#archivio/backup}"  # backup.tar.gz
echo "${FILE/%gz/zip}"           # archivio.tar.zip

# ------------------------------------------------------------------------------
# D. ESTRAZIONE E LUNGHEZZA (Slicing)
# ------------------------------------------------------------------------------

# 1. ${#var} -> Lunghezza stringa
echo "Lunghezza: ${#TESTO}"   # 23

# 2. ${var:offset} -> Taglia primi N caratteri
echo "${TESTO:3}"             # "gatto mangia il topo" (Salta i primi 3)

# 3. ${var:offset:length} -> Prendi N caratteri partendo da X
echo "${TESTO:3:5}"           # "gatto" (Parte dal 3, prende 5 char)

# 4. ${var: -N} -> Prendi gli ultimi N caratteri (Nota lo SPAZIO prima del meno)
echo "${TESTO: -4}"           # "topo"

# ------------------------------------------------------------------------------
# E. COSA *NON* FUNZIONA IN BASH 3.2 (ATTENZIONE ESAME)
# ------------------------------------------------------------------------------
# Le seguenti trasformazioni funzionano SOLO su Bash 4.0+ (Linux moderno).
# Su Mac (Bash 3.2) daranno errore di sintassi. NON USARLE:
# ${var^^}  -> Tutto MAIUSCOLO (Bash 4.0) -> USA: $(echo "$var" | tr 'a-z' 'A-Z')
# ${var,,}  -> Tutto minuscolo (Bash 4.0) -> USA: $(echo "$var" | tr 'A-Z' 'a-z')
# Associative Arrays (declare -A)         -> NON ESISTONO

# ==============================================================================
# 10. WILDCARDS (GLOBBING) & ESPANSIONI
#     ATTENZIONE: Questi NON sono Regex. Si usano per i nomi dei FILE.
# ==============================================================================

# ------------------------------------------------------------------------------
# A. GLOBBING STANDARD (Funziona sempre)
# ------------------------------------------------------------------------------

# * -> Match di QUALSIASI stringa (anche vuota)
#           Esempio: rm *.txt (Tutti i txt)
#           Attenzione: NON matcha i file nascosti (che iniziano con .)

# ?      -> Match di UN SOLO carattere esatto
#           Esempio: ls file?.txt
#           Trova: file1.txt, fileA.txt
#           NON trova: file10.txt (perché 10 sono due caratteri)

# [...]  -> Match di UN carattere incluso nella lista
#           Esempio: rm foto[123].jpg
#           Cancella solo foto1.jpg, foto2.jpg, foto3.jpg.

# [!..]  -> Match di UN carattere che NON è nella lista (Negazione)
#           (In alcune shell si usa [^..], ma [!..] è lo standard POSIX/Bash)
#           Esempio: rm foto[!9].jpg
#           Cancella tutto tranne foto9.jpg.

# ------------------------------------------------------------------------------
# B. BRACE EXPANSION (Espansione Graffe)
#    Non cerca file, ma GENERA stringhe. Utile per creare cartelle o loop.
# ------------------------------------------------------------------------------

# Liste Esplicite {a,b,c}
# cp file.txt file_{backup,old}.txt
# -> Diventa: cp file.txt file_backup.txt file_old.txt

# Sequence {start..end}
# for i in {1..5}; do ...
# -> Genera: 1 2 3 4 5

# Sequence con combinazioni
# mkdir {A,B}_{1,2}
# -> Crea: A_1, A_2, B_1, B_2

# ------------------------------------------------------------------------------
# C. EXTENDED GLOBBING (extglob) - BASH 3.2 ADVANCED
#    Richiede: shopt -s extglob
#    Fondamentale per la "Negazione Completa".
# ------------------------------------------------------------------------------
# shopt -s extglob  <-- Attivare prima di usare!

# ?(pattern-list) -> Zero o una occorrenza (Opzionale)
#                    ls file.?(txt|jpg) -> file.txt, file.jpg, file.

# *(pattern-list) -> Zero o più occorrenze
#                    rm img_*(0).jpg -> img_.jpg, img_0.jpg, img_00.jpg...

# +(pattern-list) -> Una o più occorrenze (Obbligatorio almeno uno)
#                    ls +([0-9]).jpg -> 1.jpg, 99.jpg (NO .jpg senza numeri)

# @(pattern-list) -> Esattamente una delle opzioni
#                    ls @(mario|luigi).txt -> Solo mario.txt o luigi.txt

# !(pattern-list) -> TUTTO TRANNE questo pattern (NEGATE) - IL PIÙ IMPORTANTE
#                    rm !(*.cfg) -> Cancella tutto TRANNE i file .cfg
#                    ls !(test|backup) -> Mostra tutto tranne 'test' e 'backup'

# ------------------------------------------------------------------------------
# D. TRUCCHI SALVAVITA
# ------------------------------------------------------------------------------
# 1. File nascosti (Dotfiles)
#    Di base '*' ignora i file che iniziano con punto (es. .bashrc).
#    Per vederli devi usare '.*' oppure attivare: shopt -s dotglob

# 2. Spazi nei nomi
#    Se un file generato dal glob ha spazi, il ciclo 'for' si rompe se non usi
#    le virgolette sulla variabile, ma il glob in sé è sicuro.
#    OK:  for f in *.mp3; do echo "$f"; done