#!/bin/bash

# ==============================================================================
# 33. GUIDA COMPLETA AL QUOTING: STRONG ('') vs WEAK ("") vs NESSUNO
# ==============================================================================
# FONTE: Appunti forniti + Integrazioni per macOS
# OBIETTIVO:
# Capire come la shell interpreta le stringhe.
# - Strong (' '): "Non toccare nulla, lascia tutto com'è".
# - Weak (" "): "Espandi variabili e comandi, ma tieni unito il testo".
# - Nessuno: "Dividi tutto sugli spazi ed espandi i jolly (*)".
# ==============================================================================

# Variabili di test per gli esempi successivi
nome="Mario Rossi"
prezzo="100"
cartella="Documenti Importanti"


# ------------------------------------------------------------------------------
# 1. STRONG QUOTING - APICI SINGOLI ('...')
# ------------------------------------------------------------------------------
# REGOLA: Tutto ciò che è dentro ' ' viene preso ALLA LETTERA (Literal).
# - Nessuna espansione di variabili ($var).
# - Nessuna esecuzione di comandi ($(cmd)).
# - Nessuna interpretazione di caratteri speciali (\, *, !, etc).

echo "--- 1. ESEMPI STRONG QUOTING (' ') ---"

# Esempio dal file sorgente:
echo 'Ciao $nome'
# Output atteso: Ciao $nome (NON stampa "Ciao Mario Rossi")

# Esempio con comandi:
echo 'Oggi è $(date)'
# Output atteso: Oggi è $(date) (NON stampa la data corrente)

# QUANDO USARLO:
# 1. Quando la stringa contiene molti caratteri speciali ($ ` \ !) che non vuoi parsare.
# 2. Quando passi argomenti a comandi come 'sed', 'awk' o 'grep' (Regex).
# 3. Quando scrivi password o chiavi che contengono dollari.

echo 'Prezzo: $100 (non interpretato come variabile $1)'


# ------------------------------------------------------------------------------
# 2. WEAK QUOTING - APICI DOPPI ("...")
# ------------------------------------------------------------------------------
# REGOLA: La shell espande variabili e comandi, MA protegge dagli spazi.
# COSA VIENE ESPANSO:
# - Variabili ($VAR)
# - Sostituzione di comando ($(cmd) o `cmd`)
# - Caratteri di escape (\n, \t, \$, \", \\)
#
# COSA NON VIENE TOCCATO:
# - Gli spazi (vengono preservati come un blocco unico).
# - I caratteri jolly (*, ?, [ ]) NON vengono espansi (niente globbing).

echo "--- 2. ESEMPI WEAK QUOTING (\" \") ---"

# Esempio dal file sorgente:
echo "Ciao $nome"
# Output: Ciao Mario Rossi

# Esempio con data dinamica:
echo "Oggi è $(date)"
# Output: Oggi è Thu Oct... (Data reale)

# Esempio di protezione spazi (CRITICO SU MACOS):
touch "file con spazi.txt"
ls -l "file con spazi.txt"
# Crea UN solo file chiamato "file con spazi.txt".

# Pulizia
rm "file con spazi.txt"


# ------------------------------------------------------------------------------
# 3. NESSUN QUOTING (IL PERICOLO)
# ------------------------------------------------------------------------------
# Se non usi virgolette, la shell applica il "Word Splitting".
# Ogni spazio diventa un separatore di argomenti.

echo "--- 3. ESEMPI NO QUOTING (PERICOLO) ---"

# Esempio innocuo:
echo Ciao $nome
# Output: Ciao Mario Rossi (Sembra ok, ma echo riceve 3 argomenti separati: Ciao, Mario, Rossi)

# Esempio PERICOLOSO (Creazione file):
# Vogliamo creare un file "file con spazi.txt".
touch file con spazi.txt
# RISULTATO: La shell crea 3 file separati: "file", "con", "spazi.txt".

ls -l file con spazi.txt
# Pulizia del disastro
rm file con spazi.txt

# ALTRO PERICOLO: GLOBBING (*)
# Se la variabile contiene un asterisco, esplode in tutti i file della cartella.
var_pericolosa="*"
echo "Senza virgolette:"
echo $var_pericolosa
# Stampa: Tutti i file nella cartella corrente.

echo "Con virgolette:"
echo "$var_pericolosa"
# Stampa: *


# ------------------------------------------------------------------------------
# 4. ESCAPING CON BACKSLASH (\)
# ------------------------------------------------------------------------------
# Il carattere `\` serve a disattivare il significato speciale del carattere successivo.
# Funziona come una "mini-citazione" per un solo carattere.

echo "--- 4. ESEMPI ESCAPING ---"

# Stampare le virgolette dentro una stringa
echo "Lui disse: \"Ciao Mario\""

# Stampare il simbolo del dollaro (evitare l'espansione)
echo "Il costo è \$50"
echo \$PATH

# Andare a capo senza eseguire il comando (continuazione riga)
echo "Questa è una frase molto lunga che continua \
nella riga successiva dello script."


# ------------------------------------------------------------------------------
# 5. QUOTING MISTO (CONCATENAZIONE)
# ------------------------------------------------------------------------------
# In Bash, le stringhe adiacenti vengono unite automaticamente.
# Puoi alternare '...' e "..." nella stessa parola.

echo "--- 5. ESEMPI QUOTING MISTO ---"

# Esempio dal file sorgente:
echo "User: '$USER'"
# Output: User: 'mlazoi814' (Le virgolette singole sono trattate come testo normale perché sono dentro le doppie)

# Concatenazione avanzata (Trick per script complessi):
echo 'Il percorso della home è: '"$HOME"'/documenti'
# Spiegazione:
# 'Il percorso... : ' -> Strong (Testo fisso)
# "$HOME"             -> Weak (Espande la variabile, gestisce spazi)
# '/documenti'        -> Strong (Testo fisso)


# ------------------------------------------------------------------------------
# 6. ESEMPI PRATICI DIFFERENZE (TABELLA RIEPILOGATIVA)
# ------------------------------------------------------------------------------

# Definiamo variabile
USER="marco"

echo "--- 6. CONFRONTO DIRETTO ---"

# Strong
echo '1. Strong: Ciao $USER' 
# -> Ciao $USER

# Weak
echo "2. Weak:   Ciao $USER" 
# -> Ciao marco

# No Quoting (Rischio split)
echo 3. Nessuno: Ciao $USER 
# -> Ciao marco (ma insicuro con spazi)

# Escape
echo 4. Escape:  Ciao \$USER 
# -> Ciao $USER


# ------------------------------------------------------------------------------
# 7. HEREDOC: IL QUOTING MULTILINEA (ARGOMENTO AVANZATO MACOS)
# ------------------------------------------------------------------------------
# Quando usi cat <<EOF, puoi scegliere se abilitare o no le espansioni.

echo "--- 7. HEREDOC QUOTING ---"

# HEREDOC NORMALE (Weak Quoting - Espande variabili)
cat <<EOF
[WEAK] La mia home è: $HOME
EOF

# HEREDOC QUOTATO (Strong Quoting - Metti apici al delimitatore 'EOF')
# Utile per generare script o file di config senza che bash tocchi i $
cat <<'EOF'
[STRONG] La mia home è: $HOME (non espanso)
EOF


# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME
# ==============================================================================

# --- SCENARIO 1: "Lo script fallisce con file che hanno spazi nel nome" ---
# Errore classico: cp $file $destinazione
# Soluzione: cp "$file" "$destinazione"
# REGOLA D'ORO: IN BASH, METTI SEMPRE LE VIRGOLETTE DOPPIE ALLE VARIABILI.
# Eccezione: Solo se *vuoi* esplicitamente che la stringa venga divisa.

# --- SCENARIO 2: "Devo passare un comando complesso via SSH" ---
# SSH richiede che il comando remoto sia una singola stringa.
# Usa Strong Quoting per l'intero comando per evitare che la TUA shell lo espanda prima di inviarlo.
# ssh user@host 'ls -l /tmp/*.log'
# (Se usassi "...", l'asterisco verrebbe espanso sul TUO Mac prima di partire!)

# --- SCENARIO 3: "Come stampo un apice singolo dentro apici singoli?" ---
# Impossibile fare 'L'albero'. Bash si ferma al secondo apice.
# Trucco: Chiudi, escapa, riapri.
echo 'L'\''albero'
# Spiegazione: 'L' (chiuso) \' (apice letterale) 'albero' (riaperto).

# --- SCENARIO 4: "Sed e Awk su Mac" ---
# Sed e Awk usano molto i caratteri $ e \.
# Usa SEMPRE i singoli apici per i loro comandi.
# awk '{print $1}' file.txt   (CORRETTO)
# awk "{print $1}" file.txt   (ERRORE: Bash espande $1 prima di passarlo ad awk)