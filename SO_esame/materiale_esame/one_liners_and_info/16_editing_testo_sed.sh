#!/bin/bash

# ==============================================================================
# 16. SED MASTER CLASS: STREAM EDITOR (MACOS / BSD EDITION)
# ==============================================================================
# OBIETTIVO:
# Modificare file di testo in modo automatico (senza aprirli).
# Sostituire stringhe, cancellare righe, estrarre parti specifiche.
#
# DIFFERENZE CRITICHE MACOS (BSD) vs LINUX (GNU):
# 1. Edit in-place (-i): Su Mac è OBBLIGATORIO fornire un'estensione per il backup.
#    Se non vuoi backup, DEVI passare una stringa vuota: sed -i ''
#    Su Linux basta sed -i (su Mac questo rompe tutto).
# 2. Newlines (\n): BSD sed gestisce i ritorni a capo in modo diverso nelle sostituzioni.
# 3. Case Insensitive (I): Funziona su entrambi, ma è bene testare.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. SETUP AMBIENTE DI TEST
# ------------------------------------------------------------------------------
echo "--- Creazione File di Test ---"

cat <<EOF > testo.txt
1. Questo è un file di prova.
2. Ciao Mondo.
3. La mela è rossa.
4. Windows è un sistema operativo.
5. Linux è bello.
6. macOS è basato su Unix.
7. RIGA DA CANCELLARE
8. Fine del file.
EOF

# Creiamo una copia per non distruggere l'originale subito
cp testo.txt lavoro.txt

echo "File 'lavoro.txt' pronto."


# ==============================================================================
# 1. SOSTITUZIONE BASE (s///)
# ==============================================================================
# Sintassi: s/CERCA/SOSTITUISCI/FLAGS
# Questo stampa il risultato a video (STDOUT) senza modificare il file.

echo "----------------------------------------------------------------"
echo "--- 1. SOSTITUZIONE BASE ---"

# Sostituire la prima occorrenza di "è" con "ERA" in ogni riga
sed 's/è/ERA/' lavoro.txt

# Sostituire TUTTE le occorrenze (Global flag 'g')
# Senza 'g', sed cambia solo la prima parola trovata per riga.
sed 's/è/ERA/g' lavoro.txt

# Sostituire ignorando maiuscole/minuscole (Case Insensitive flag 'I')
# Cambia "Mondo", "mondo", "MONDO" in "Universo".
sed 's/mondo/Universo/Ig' lavoro.txt


# ==============================================================================
# 2. MODIFICA SUL POSTO (-i) - CRITICO SU MACOS
# ==============================================================================
# Se vuoi salvare le modifiche nel file, devi usare -i (in-place).
# SU MACOS: sed -i '' 'comando' file

echo "----------------------------------------------------------------"
echo "--- 2. EDIT IN-PLACE (-i) ---"

# ERRORE COMUNE (Funziona su Linux, FALLISCE su Mac):
# sed -i 's/Windows/Linux/' lavoro.txt
# Output errore: "command c expects \ followed by text" o crea un file "lavoro.txt-e"

# METODO CORRETTO MACOS (Senza Backup):
# Le virgolette vuote '' dicono "non fare backup".
sed -i '' 's/Windows/Linux/g' lavoro.txt

echo "Verifica modifica (Windows -> Linux):"
grep "Linux" lavoro.txt

# METODO CORRETTO MACOS (Con Backup):
# Crea lavoro.txt.bak prima di modificare.
sed -i '.bak' 's/Linux/BSD/g' lavoro.txt

echo "Verifica backup:"
ls -l lavoro.txt.bak


# ==============================================================================
# 3. CANCELLAZIONE RIGHE (d)
# ==============================================================================
# Sintassi: sed '/PATTERN/d' oppure sed 'NUMEROd'

echo "----------------------------------------------------------------"
echo "--- 3. CANCELLAZIONE (d) ---"

# Cancellare una riga specifica (es. riga 7)
sed '7d' testo.txt

# Cancellare l'ultima riga ($d)
sed '$d' testo.txt

# Cancellare un intervallo (dalla 1 alla 3)
sed '1,3d' testo.txt

# Cancellare in base al contenuto (Regex)
# Cancella tutte le righe che contengono "CANCELLARE"
sed '/CANCELLARE/d' testo.txt

# Cancellare righe vuote (Regex ^$)
sed '/^$/d' testo.txt


# ==============================================================================
# 4. VISUALIZZAZIONE SELETTIVA (-n e p)
# ==============================================================================
# Di default sed stampa tutto.
# -n : No-print (non stampare nulla di default).
# p  : Print (stampa solo se glielo dico).
# Combinazione: sed -n '/pattern/p' (funziona come grep).

echo "----------------------------------------------------------------"
echo "--- 4. STAMPA SELETTIVA (-n p) ---"

# Stampa solo le righe che contengono "Unix"
sed -n '/Unix/p' testo.txt

# Stampa solo le righe dalla 2 alla 4
sed -n '2,4p' testo.txt


# ==============================================================================
# 5. REGEX AVANZATE E BACKREFERENCES (-E) - POTENTISSIMO
# ==============================================================================
# Usare le parentesi () per catturare gruppi e riutilizzarli con \1, \2.
# Su Mac usa SEMPRE -E (Extended Regex) per evitare backslash infernali.

echo "----------------------------------------------------------------"
echo "--- 5. BACKREFERENCES (-E) ---"

# SCENARIO: Invertire due parole.
# Input: "Ciao Mondo" -> Output: "Mondo Ciao"
# Gruppo 1: (Ciao) -> \1
# Gruppo 2: (Mondo) -> \2
# Sostituzione: \2 \1

echo "Ciao Mondo" | sed -E 's/([A-Za-z]+) ([A-Za-z]+)/\2 \1/'

# SCENARIO: Formattare un elenco
# Input: "Nome: Mario" -> Output: "Utente [Mario]"
# Pattern: Nome: (.*)
# Sostituzione: Utente [\1]

echo "Nome: Mario" | sed -E 's/Nome: (.*)/Utente [\1]/'


# ==============================================================================
# 6. INSERIMENTO E APPEND (i, a)
# ==============================================================================
# i = Insert (prima della riga)
# a = Append (dopo la riga)
# c = Change (sostituisci intera riga)

echo "----------------------------------------------------------------"
echo "--- 6. INSERT E APPEND ---"

# Inserire un titolo all'inizio (Riga 1, Insert)
# Nota: Su Mac/BSD, se vuoi andare a capo devi usare un vero newline o più -e.
sed -e '1i\' -e '--- INIZIO DOCUMENTO ---' testo.txt

# Appendere alla fine ($a)
sed -e '$a\' -e '--- FINE DOCUMENTO ---' testo.txt


# ==============================================================================
# 7. DELIMITATORI PERSONALIZZATI
# ==============================================================================
# Se devi sostituire percorsi con slash (/), usare s/// diventa un incubo: s/\/usr\/bin/\/bin/
# Sed accetta QUALSIASI carattere come delimitatore dopo la s.
# Esempio: s|CERCA|SOSTITUISCI|

echo "----------------------------------------------------------------"
echo "--- 7. DELIMITATORI ---"

PERCORSO="/usr/local/bin"
echo "$PERCORSO" | sed 's|/usr/local|/opt|'
# Output: /opt/bin


# ==============================================================================
# 🧩 SCENARI D'ESAME REALI
# ==============================================================================

echo "----------------------------------------------------------------"
echo "--- SCENARI D'ESAME ---"

# SCENARIO A: SOSTITUZIONE IN FILE DI CONFIGURAZIONE
# "Cambia la porta da 80 a 8080 nel file config.conf"
# sed -i '' 's/Port 80/Port 8080/' config.conf

# SCENARIO B: PULIZIA FILE LOG
# "Rimuovi tutte le righe di commento (che iniziano con #)"
echo "# Commento" > config.txt
echo "Setting=True" >> config.txt
sed '/^#/d' config.txt

# SCENARIO C: ESTRARRE DATI TRA TAG
# "Estrai il testo tra <nome> e </nome>"
# Input: <nome>Mario</nome>
echo "<nome>Mario</nome>" | sed -E 's/<nome>(.*)<\/nome>/\1/'

# SCENARIO D: AGGIUNGERE UN PREFISSO A TUTTE LE RIGHE
# "Aggiungi 'LOG: ' all'inizio di ogni riga"
# ^ indica l'inizio riga. Sostituisci l'inizio (nulla) con "LOG: ".
sed 's/^/LOG: /' testo.txt


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (SED MACOS)
# ==============================================================================
# | FLAG      | SIGNIFICATO                                             |
# |-----------|---------------------------------------------------------|
# | -i ''     | Edit in-place SENZA backup (OBBLIGATORIO SU MAC).       |
# | -i '.bak' | Edit in-place CON backup.                               |
# | -E        | Extended Regex (abilita (), +, ?).                      |
# | -n        | No-print (usare con p per stampare solo match).         |
# | s/A/B/g   | Sostituisci TUTTE le occorrenze (Global).               |
# | s/A/B/I   | Case Insensitive (ignora maiusc/minusc).                |
# | d         | Delete (cancella riga).                                 |
# | p         | Print (stampa riga).                                    |

# Pulizia
rm -f testo.txt lavoro.txt lavoro.txt.bak config.txt
echo "----------------------------------------------------------------"
echo "Tutorial SED Completato."

# ==============================================================================
# GUIDA A 'sed' (STREAM EDITOR) - TRASFORMAZIONE TESTO
# ==============================================================================

# 1. SOSTITUZIONE (Il comando 's')
# ------------------------------------------------------------------------------
# Sostituisce la PRIMA occorrenza di "mela" con "pera" in ogni riga
sed 's/mela/pera/' file.txt

# Sostituisce TUTTE le occorrenze (g = global)
sed 's/mela/pera/g' file.txt

# Sostituisce ignorando maiuscole/minuscole (I)
sed 's/mela/pera/Ig' file.txt


# 2. ELIMINAZIONE (Il comando 'd')
# ------------------------------------------------------------------------------
# Elimina la riga 3
sed '3d' file.txt

# Elimina tutte le righe che contengono la parola "commento"
sed '/commento/d' file.txt

# Elimina le righe vuote
sed '/^$/d' file.txt


# 3. STAMPA SELETTIVA (L'opzione '-n' e il comando 'p')
# ------------------------------------------------------------------------------
# Stampa solo le righe che contengono "ERRORE" (evita di stampare tutto il resto)
sed -n '/ERRORE/p' file.txt

# Stampa solo l'intervallo tra la riga 10 e la riga 20
sed -n '10,20p' file.txt


# 4. MODIFICA "IN-PLACE" (L'opzione '-i')
# ------------------------------------------------------------------------------
# Sovrascrive il file originale con le modifiche apportate
# ATTENZIONE: Vedere sezione suggerimenti per macOS!
# sed -i 's/vecchio/nuovo/g' file.txt


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (CRITICI!)
# ==============================================================================

# --- TRAPPOLA MACOS vs LINUX ---
# Su LINUX (Server dell'esame):
# sed -i 's/a/b/g' file.txt  -> Funziona correttamente.
#
# Su MACOS (Il tuo PC):
# sed -i '' 's/a/b/g' file.txt -> Richiede obbligatoriamente le virgolette vuote ''
# dopo -i per non creare un file di backup. Se non le metti, dà ERRORE.

# --- SCENARIO 1: "Cambia il percorso di un file in una config" ---
# Se il testo contiene degli slash ( / ), usa un separatore diverso come cercatore
# per non impazzire con i backslash:
# sed 's|/var/www/html|/opt/app/public|g' config.conf

# --- SCENARIO 2: "Rimuovere spazi bianchi alla fine delle righe" ---
# sed 's/[[:space:]]*$//' file.txt

# --- SCENARIO 3: "Aggiungere testo all'inizio di ogni riga" ---
# sed 's/^/RIGA: /' file.txt

# --- LOGICA DI FUNZIONAMENTO ---
# sed lavora riga per riga: legge una riga, applica il comando, la stampa, 
# passa alla successiva. Non carica l'intero file in memoria (ottimo per file giganti).