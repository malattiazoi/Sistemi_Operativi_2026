#!/bin/bash

# ==============================================================================
# 19. CAT MASTER CLASS: VISUALIZZAZIONE E CREAZIONE (MACOS / BSD)
# ==============================================================================
# OBIETTIVO:
# Leggere file, concatenarli, creare file al volo e scovare caratteri invisibili.
#
# DIFFERENZE CRITICHE MACOS (BSD) vs LINUX (GNU):
# 1. Reverse: Linux ha 'tac'. macOS NON HA 'tac'. Si usa 'tail -r'.
# 2. Flag -A: Linux usa -A per mostrare tutto (All). Mac deve combinare -e -t.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. SETUP AMBIENTE DI TEST
# ------------------------------------------------------------------------------
echo "--- Creazione File di Test ---"

# Creiamo due file semplici
echo "Riga 1: File A" > file_A.txt
echo "Riga 2: File A" >> file_A.txt

echo "Riga 1: File B" > file_B.txt
echo "Riga 2: File B" >> file_B.txt

# Creiamo un file "sporco" con caratteri invisibili (Tab e Spazi finali)
# \t = Tab, \r = Carriage Return
printf "Riga con TAB:\tQui\n" > sporco.txt
printf "Riga con spazi finali:   \n" >> sporco.txt
printf "Riga vuota:\n" >> sporco.txt
printf "\n" >> sporco.txt
printf "Ultima riga." >> sporco.txt

echo "File creati."


# ==============================================================================
# 1. UTILIZZO BASE: LETTURA E CONCATENAZIONE
# ==============================================================================
# cat = Catenate. Nasce per unire file, non solo per leggerli.

echo "----------------------------------------------------------------"
echo "--- 1. CONCATENAZIONE ---"

echo "Leggere un file singolo:"
cat file_A.txt

echo "Concatenare due file (A + B) a video:"
cat file_A.txt file_B.txt

echo "Concatenare due file e salvare in un terzo (Unione):"
cat file_A.txt file_B.txt > unione.txt
cat unione.txt


# ==============================================================================
# 2. NUMERAZIONE DELLE RIGHE (-n, -b)
# ==============================================================================
# Utile se devi dire a qualcuno "Guarda l'errore alla riga X".

echo "----------------------------------------------------------------"
echo "--- 2. NUMERAZIONE (-n / -b) ---"

# -n : Numera TUTTE le righe (anche quelle vuote)
echo "Numerazione completa (-n):"
cat -n sporco.txt

# -b : Numera solo le righe NON vuote (Blank skip)
# Utile per contare il codice effettivo ignorando la formattazione.
echo "Numerazione intelligente (-b):"
cat -b sporco.txt


# ==============================================================================
# 3. DEBUGGING CARATTERI INVISIBILI (-e, -t) - FONDAMENTALE
# ==============================================================================
# Scenario: Lo script fallisce perché c'è uno spazio invisibile alla fine di una variabile.
# O perché hai usato TAB invece di SPAZI in un Makefile o Python.
#
# SU MACOS (BSD):
# -e : Mette un '$' alla fine di ogni riga. (Mostra spazi trailing).
# -t : Mostra i TAB come '^I'.

echo "----------------------------------------------------------------"
echo "--- 3. VISUALIZZAZIONE CARATTERI SPECIALI ---"

echo "Senza flag (sembra tutto normale):"
cat sporco.txt

echo "Con flag -e (Mostra fine riga $):"
# Se vedi "testo   $", sai che ci sono 3 spazi inutili alla fine.
cat -e sporco.txt

echo "Con flag -t (Mostra TAB come ^I):"
cat -t sporco.txt

echo "Combinazione totale (-et):"
cat -et sporco.txt


# ==============================================================================
# 4. IL PROBLEMA DEL REVERSE (TAC vs TAIL -R)
# ==============================================================================
# Domanda Esame: "Stampa il file dall'ultima riga alla prima".
# Utente Linux: usa 'tac'.
# Utente Mac: prova 'tac' -> "Command not found".

echo "----------------------------------------------------------------"
echo "--- 4. REVERSE CAT (TAC vs TAIL -R) ---"

# Tentativo Linux (fallirà o darà errore se non installato via brew)
if command -v tac &> /dev/null; then
    echo "Il comando tac esiste (Linux/Brew)."
    tac file_A.txt
else
    echo "Il comando 'tac' non esiste su macOS standard."
fi

# Soluzione macOS (BSD Standard)
# Si usa 'tail' con flag '-r' (Reverse).
echo "Soluzione Mac (tail -r):"
tail -r file_A.txt


# ==============================================================================
# 5. CREAZIONE FILE CON HEREDOC (<<) - CRITICO PER SCRIPT
# ==============================================================================
# Come creare un file di configurazione complesso dentro uno script bash?
# Si usa la redirezione << seguita da un delimitatore (es. EOF).

echo "----------------------------------------------------------------"
echo "--- 5. HEREDOC (<<) ---"

# Esempio A: Heredoc con espansione variabili
# Le variabili ($USER, $PWD) vengono sostituite col valore reale.
FILE_OUT="config_dinamico.txt"
UTENTE="Mario"

cat <<EOF > "$FILE_OUT"
# Questo è un file generato automaticamente
User: $UTENTE
Date: $(date)
Path: $PWD
EOF

echo "Contenuto generato (Dinamico):"
cat "$FILE_OUT"

# Esempio B: Heredoc LETTERALE (Senza espansione)
# Si mettono gli apici 'EOF' attorno al delimitatore.
# Utile se devi generare script che contengono $ variabili che NON vuoi espandere ora.
FILE_OUT_LITERAL="script_generato.sh"

cat <<'EOF' > "$FILE_OUT_LITERAL"
#!/bin/bash
echo "La variabile è $VAR"
# $VAR non è stata sostituita da questo script, è rimasta scritta così.
EOF

echo "Contenuto generato (Letterale):"
cat "$FILE_OUT_LITERAL"


# ==============================================================================
# 6. SQUEEZE BLANK LINES (-s)
# ==============================================================================
# Se un file ha troppe righe vuote consecutive, -s le riduce a una sola.

echo "----------------------------------------------------------------"
echo "--- 6. COMPRESSIONE RIGHE VUOTE (-s) ---"

echo "Originale (tante righe vuote):"
cat sporco.txt

echo "Compresso (-s):"
cat -s sporco.txt


# ==============================================================================
# 7. USELESS USE OF CAT (UUoC) - ERRORE DA PRINCIPIANTE
# ==============================================================================
# All'esame, se fai "cat file | grep pattern", perdi punti per stile.
# Perché? Perché grep accetta il file come argomento.

echo "----------------------------------------------------------------"
echo "--- 7. PRESTAZIONI E STILE (UUoC) ---"

echo "Metodo Inefficiente (cat | grep):"
cat file_A.txt | grep "Riga 1"

echo "Metodo Corretto (grep file):"
grep "Riga 1" file_A.txt

# Eccezione: Quando usi cat?
# Quando devi unire più file PRIMA di passarli a un comando.
# grep "pattern" file1 file2 ... (funziona anche senza cat)
# Ma se devi processarli come flusso unico complesso, a volte serve.


# ==============================================================================
# 🧩 SCENARI D'ESAME REALI
# ==============================================================================

# SCENARIO A: "Unisci tutti i log e visualizza gli errori ordinati per ora inversa"
# 1. Unisci (cat *.log)
# 2. Filtra (grep ERROR)
# 3. Inverti ordine cronologico (tail -r su Mac)
# cat *.log | grep "ERROR" | tail -r

# SCENARIO B: "Verifica se il file ha spazi bianchi a fine riga che causano errori"
# cat -e config.txt
# Se vedi "valore   $", devi pulirlo (magari con sed).

# SCENARIO C: "Aggiungi una riga all'inizio di un file esistente"
# Non puoi fare "echo ciao > file" perché sovrascrive.
# Non puoi fare "cat ciao.txt file > file" perché il file si svuota mentre lo leggi.
# Soluzione corretta con file temporaneo:
# echo "Intestazione" | cat - file_originale.txt > temp.txt && mv temp.txt file_originale.txt
# (Il trattino '-' in cat indica lo Standard Input).

echo "----------------------------------------------------------------"
echo "--- TRUCCO: AGGIUNGERE IN TESTA ---"
echo "Intestazione Nuova" | cat - file_A.txt > temp_A.txt
mv temp_A.txt file_A.txt
cat file_A.txt


# ==============================================================================
# ⚠️ TABELLA FLAG VITALI (MACOS CAT)
# ==============================================================================
# | FLAG | SIGNIFICATO                                            |
# |------|--------------------------------------------------------|
# | -n   | Numera tutte le righe.                                 |
# | -b   | Numera solo righe non vuote.                           |
# | -e   | Mostra $ a fine riga (Debug spazi).                    |
# | -t   | Mostra TAB come ^I (Debug formattazione).              |
# | -s   | Squeeze. Comprime righe vuote multiple in una sola.    |
# | -u   | Unbuffered. Scrive l'output istantaneamente (lento).   |
# | (NA) | tac non esiste. USA 'tail -r'.                         |

# Pulizia
rm -f file_A.txt file_B.txt unione.txt sporco.txt config_dinamico.txt script_generato.sh
echo "----------------------------------------------------------------"
echo "Tutorial Cat Completato."

# ==============================================================================
# GUIDA COMPLETA AL COMANDO 'cat' (CONCATENATE) - SPECIFICA MACOS
# ==============================================================================
# DESCRIZIONE:
# 'cat' (concatenate) è il comando più usato per leggere file, unirli e crearne
# di nuovi. Su MacOS (BSD), le opzioni differiscono leggermente da Linux.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. LETTURA E CONCATENAZIONE BASE
# ------------------------------------------------------------------------------
# Leggere un singolo file e stamparlo a video (STDOUT)
cat file.txt

# Concatenare (unire) più file insieme in sequenza
cat parte1.txt parte2.txt parte3.txt

# Concatenare più file e salvare il risultato in un NUOVO file (unione fisica)
cat introduzione.txt capitolo1.txt > libro_completo.txt


# ------------------------------------------------------------------------------
# 2. CREAZIONE FILE (REINDIRIZZAMENTO)
# ------------------------------------------------------------------------------
# Creare un file da zero scrivendo nel terminale.
# Dopo aver lanciato il comando, scrivi il testo e premi CTRL+D per salvare/uscire.
# cat > nuovo_file.txt

# Aggiungere testo alla fine di un file esistente (APPEND)
# cat >> file_esistente.txt


# ------------------------------------------------------------------------------
# 3. NUMERAZIONE DELLE RIGHE (Opzioni -n vs -b)
# ------------------------------------------------------------------------------
# Aggiungere il numero di riga a TUTTE le righe (comprese quelle vuote)
cat -n script.sh

# Aggiungere il numero di riga SOLO alle righe che contengono testo (salta le vuote)
cat -b script.sh


# ------------------------------------------------------------------------------
# 4. DEBUGGING E CARATTERI INVISIBILI (Opzioni -e, -t, -v)
# ------------------------------------------------------------------------------
# Su MacOS, spesso i file non funzionano perché ci sono spazi o tab invisibili.

# Mostra la fine di ogni riga con un dollaro '$' (Utile per vedere spazi finali)
# NOTA MACOS: L'opzione -e su BSD implica anche -v (mostra caratteri non stampabili)
cat -e file_config.txt

# Mostra i TAB come '^I' e i caratteri speciali
# NOTA MACOS: L'opzione -t su BSD implica anche -v
cat -t script.py

# Combinazione completa (Simile a -A di Linux, che su Mac NON esiste)
cat -etv file_sospetto.txt


# ------------------------------------------------------------------------------
# 5. ELIMINARE RIGHE VUOTE RIPETUTE (-s)
# ------------------------------------------------------------------------------
# Se un file ha 10 righe vuote consecutive, -s le riduce a UNA sola riga vuota.
# ("Squeeze blank lines")
cat -s output_disordinato.txt


# ------------------------------------------------------------------------------
# 6. HERE DOCUMENT (HEREDOC) - CRITICO PER GLI SCRIPT D'ESAME
# ------------------------------------------------------------------------------
# Permette di scrivere un blocco di testo multilinea direttamente nello script
# e passarlo a un comando (come cat) o salvarlo su file.

# Esempio: Creare un file di configurazione al volo
cat << EOF > config_esame.conf
Server=10.0.14.23
User=mlazoi814
Port=22
# Questo file è stato generato automaticamente
EOF

# Spiegazione:
# << EOF  : Inizia a leggere finché non trovi la parola "EOF"
# > file  : Salva tutto quello che leggi nel file

# TRUCCO AVANZATO: Disabilitare l'espansione delle variabili (Quote 'EOF')
# Se vuoi scrivere "$HOME" nel file senza che venga sostituito con "/Users/mlazoi814":
cat << 'EOF' > script_generato.sh
echo "La mia home è $HOME"
EOF


# ==============================================================================
# 📊 TABELLA RIEPILOGATIVA OPZIONI (FLAG) - MACOS / BSD
# ==============================================================================
# | FLAG | NOME           | DESCRIZIONE DETTAGLIATA (SPECIFICA MACOS)      |
# |------|----------------|------------------------------------------------|
# | -n   | Number         | Numera tutte le righe in output (da 1 a N).    |
# | -b   | Number-nonblank| Numera solo le righe NON vuote (sovrascrive -n)|
# | -s   | Squeeze        | Comprime serie di righe vuote in una sola.     |
# | -e   | End (+Verbose) | Mette '$' a fine riga E mostra caratteri strani.|
# | -t   | Tab (+Verbose) | Mostra i TAB come '^I' E caratteri strani.     |
# | -v   | Verbose        | Mostra i caratteri non stampabili (tranne Tab/NL)|
# | -u   | Unbuffered     | Disabilita il buffer di output (Esclusiva BSD!).|
# |      |                | Garantisce che l'output sia scritto istantaneamente.|

# NOTA DIFFERENZA LINUX: Su Linux esiste `cat -A` (Show All).
# Su MacOS devi usare `cat -et` o `cat -etv` per ottenere lo stesso effetto.


# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Unisci file header, corpo e footer" ---
# cat header.html body.txt footer.html > index.html

# --- SCENARIO 2: "Il file sembra vuoto ma occupa spazio" ---
# Usa `cat -e file`
# Se vedi output tipo "^@^@^@$", il file è pieno di caratteri NUL (binari).

# --- SCENARIO 3: "Invertire l'ordine" (Specifico MacOS) ---
# Se l'esame chiede di leggere un file al contrario (ultima riga -> prima):
# - Su Linux useresti: tac file.txt
# - Su MacOS 'tac' spesso NON C'È. Devi usare:
# tail -r file.txt

# --- SCENARIO 4: "Cat vs Grep (Useless use of cat)" ---
# Spesso i prof odiano vedere:
# cat file.txt | grep "errore"
# È considerato spreco di risorse. La forma corretta è:
# grep "errore" file.txt
# TUTTAVIA: Se devi fare `cat file1 file2 | grep "errore"`, allora cat è giustificato.

# --- ATTENZIONE AI FILE BINARI ---
# Mai fare `cat` su un file eseguibile o un'immagine (es. `cat foto.jpg`).
# Il terminale si riempirà di simboli alieni e potrebbe bloccarsi.
# Se succede, scrivi alla cieca il comando: reset (e premi Invio).