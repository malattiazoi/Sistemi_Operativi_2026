#!/bin/bash

# ==============================================================================
# 15. INPUT UTENTE: IL COMANDO READ (MACOS BASH 3.2 EDITION)
# ==============================================================================
# OBIETTIVO:
# Fermare l'esecuzione dello script per chiedere dati all'utente (Stringhe, Password, Conferme).
#
# DIFFERENZE CRITICHE MACOS (BASH 3.2) vs LINUX (BASH 4+):
# 1. Flag -i (Initial Text): NON ESISTE su Mac. Non puoi pre-compilare il campo.
# 2. Flag -e (Readline): Supporto limitato.
# 3. Flag -N (Num chars): Non sempre affidabile come su Linux.
#
# L'approccio qui descritto è "Safe for Mac" (funziona ovunque).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SINTASSI BASE E VARIABILI MULTIPLE
# ------------------------------------------------------------------------------
# Sintassi: read [opzioni] VARIABILE
# Se non fornisci una variabile, l'input finisce nella variabile speciale $REPLY.

echo "--- 1. INPUT BASE ---"

echo "Scrivi il tuo nome e premi invio:"
read NOME
echo "Ciao, $NOME!"

echo "Scrivi Nome e Cognome (separati da spazio):"
# read spezza l'input sugli spazi e lo assegna alle variabili in ordine
read NOME COGNOME
echo "Nome: $NOME"
echo "Cognome: $COGNOME"

# Se l'utente scrive più parole delle variabili, l'ultima variabile prende tutto il resto
echo "Scrivi tre parole o più:"
read PAROLA1 PAROLA2 RESTO
echo "1: $PAROLA1 - 2: $PAROLA2 - Resto: $RESTO"


# ------------------------------------------------------------------------------
# 2. IL PROMPT (-p) - SCRIVERE SULLA STESSA RIGA
# ------------------------------------------------------------------------------
# Invece di usare 'echo' prima, usa -p per mostrare il messaggio.
# Nota: Su Mac, read non mette a capo automaticamente dopo l'input.

echo "----------------------------------------------------------------"
echo "--- 2. PROMPT (-p) ---"

read -p "Inserisci la tua città: " CITTA
echo "Vivi a: $CITTA"


# ------------------------------------------------------------------------------
# 3. PASSWORD E INPUT INVISIBILE (-s) - CRITICO ESAME 24
# ------------------------------------------------------------------------------
# Flag -s (Silent): Non mostra a schermo ciò che scrivi.
# Indispensabile per password.

echo "----------------------------------------------------------------"
echo "--- 3. PASSWORD (-s) ---"

# Nota: -s non va a capo alla fine, quindi dobbiamo mettere un echo vuoto dopo.
read -s -p "Inserisci la password (invisibile): " PASSWORD
echo "" 
echo "Hai inserito una password di ${#PASSWORD} caratteri."

# SCENARIO ESAME 24:
# "Chiedere la password 'sesamo' in modo invisibile".
if [ "$PASSWORD" == "sesamo" ]; then
    echo "Accesso Consentito."
else
    echo "Accesso Negato."
fi


# ------------------------------------------------------------------------------
# 4. TIMEOUT (-t) - NON BLOCCARE LO SCRIPT
# ------------------------------------------------------------------------------
# Se l'utente non risponde entro N secondi, lo script prosegue.
# Utile per script automatici che chiedono conferma ma non vogliono aspettare per sempre.

echo "----------------------------------------------------------------"
echo "--- 4. TIMEOUT (-t) ---"

if read -t 3 -p "Premi invio entro 3 secondi per annullare..." RISPOSTA; then
    echo "Operazione Annullata dall'utente."
else
    # Se il timeout scade, read ritorna Exit Code > 0
    echo ""
    echo "Tempo scaduto. Procedo con l'operazione default..."
fi


# ------------------------------------------------------------------------------
# 5. LIMITARE IL NUMERO DI CARATTERI (-n)
# ------------------------------------------------------------------------------
# Utile per menu "Premi un tasto" o conferme "y/n".
# Non serve premere Invio se si raggiunge il limite.

echo "----------------------------------------------------------------"
echo "--- 5. LIMITE CARATTERI (-n) ---"

read -n 1 -p "Vuoi continuare? (y/n): " SCELTA
echo "" # A capo estetico

# Gestione Case Insensitive spiccia
if [[ "$SCELTA" == "y" || "$SCELTA" == "Y" ]]; then
    echo "Proseguo..."
else
    echo "Mi fermo."
fi


# ------------------------------------------------------------------------------
# 6. RAW MODE (-r) - GESTIONE BACKSLASH
# ------------------------------------------------------------------------------
# REGOLA D'ORO: Usa SEMPRE 'read -r' quando leggi file o percorsi.
# Senza -r, il backslash (\) viene interpretato come escape (es. \n sparisce).
# Con -r, il backslash è letto letteralmente.

echo "----------------------------------------------------------------"
echo "--- 6. RAW MODE (-r) ---"

echo "Scrivi un percorso Windows (es. C:\Utenti\Nome):"
read -r PERCORSO
echo "Percorso salvato: $PERCORSO"
# Se avessimo usato read senza -r, C:\Utenti sarebbe diventato C:Utenti (mangiando il \)


# ------------------------------------------------------------------------------
# 7. LEGGERE ARRAY (-a) E GESTIONE SEPARATORI (IFS)
# ------------------------------------------------------------------------------
# Scenario: Hai una stringa separata da due punti o virgole (CSV).
# IFS (Internal Field Separator) decide come read spezza le parole.

echo "----------------------------------------------------------------"
echo "--- 7. ARRAY E IFS ---"

DATA_CSV="Mario,Rossi,30,Milano"

# Impostiamo IFS solo per questa riga di comando
# -a crea un array invece di variabili singole
IFS=',' read -r -a PERSONA <<< "$DATA_CSV"

echo "Nome: ${PERSONA[0]}"
echo "Cognome: ${PERSONA[1]}"
echo "Età: ${PERSONA[2]}"
echo "Città: ${PERSONA[3]}"


# ------------------------------------------------------------------------------
# 8. LEGGERE UN FILE RIGA PER RIGA (LOOP WHILE)
# ------------------------------------------------------------------------------
# Questo è il pattern standard per processare file di testo.
# ATTENZIONE: Non usare 'cat file | while read'.
# Usa la redirezione alla fine del ciclo (< file).

echo "----------------------------------------------------------------"
echo "--- 8. LETTURA FILE ---"

# Creiamo un file temporaneo
printf "Riga 1\nRiga 2\nRiga 3" > demo.txt

# Loop di lettura
# IFS= protegge gli spazi a inizio/fine riga
# -r protegge i backslash
while IFS= read -r RIGA; do
    echo "Processo: $RIGA"
done < demo.txt


# ------------------------------------------------------------------------------
# 9. TRUCCO MACOS: VALORE DI DEFAULT (WORKAROUND)
# ------------------------------------------------------------------------------
# Su Linux puoi fare: read -i "Default" -e VAR
# Su Mac Bash 3.2 NON ESISTE.
# Come si fa? Si usa la "Parameter Expansion" dopo il read.

echo "----------------------------------------------------------------"
echo "--- 9. DEFAULT VALUE (TRUCCO MAC) ---"

DEFAULT_IP="127.0.0.1"
read -p "Inserisci IP [$DEFAULT_IP]: " USER_IP

# Se USER_IP è vuota (-z), assegna il default
# Sintassi compatta: VAR=${VAR:-DEFAULT}
USER_IP=${USER_IP:-$DEFAULT_IP}

echo "IP Utilizzato: $USER_IP"


# ==============================================================================
# 🧩 RIASSUNTO FLAG VITALI
# ==============================================================================
# | FLAG | SIGNIFICATO                                     | ESAME                   |
# |------|-------------------------------------------------|-------------------------|
# | -p   | Prompt. Mostra messaggio prima di leggere.      | Tutti                   |
# | -s   | Silent. Nasconde l'input (Password).            | Esame 24 (Obbligatorio) |
# | -r   | Raw. Non interpretare i backslash.              | Lettura File            |
# | -t N | Timeout. Aspetta solo N secondi.                | Script automatici       |
# | -n N | Number. Legge solo N caratteri (es. 1 per y/n). | Menu rapidi             |
# | -a   | Array. Legge le parole in un indice array.      | Parsing CSV             |

# Pulizia
rm -f demo.txt
echo "----------------------------------------------------------------"
echo "Tutorial Read Completato."

# ==============================================================================
# GUIDA AL COMANDO 'read' (INPUT UTENTE E PARSING FILE)
# ==============================================================================

# 1. INPUT DA TASTIERA
# ------------------------------------------------------------------------------
# Chiedi un valore all'utente (-p permette di scrivere il prompt direttamente)
read -p "Inserisci il tuo nome: " nome
echo "Benvenuto $nome"

# Lettura silenziosa (utile per le password, non mostra i caratteri digitati)
read -sp "Inserisci password: " password
echo -e "\nPassword salvata in sicurezza."


# 2. LEGGERE UN FILE RIGA PER RIGA (Il metodo "Standard")
# ------------------------------------------------------------------------------
# Il ciclo 'while' accoppiato a 'read' è il modo più sicuro per leggere file.
# -r : impedisce l'interpretazione dei backslash (evita errori con i percorsi)
# IFS= : impedisce la rimozione degli spazi bianchi all'inizio/fine riga

while IFS= read -r riga; do
    echo "Sto elaborando: $riga"
done < file_input.txt


# 3. PARSING DI FILE CSV O A COLONNE (Esempio: /etc/passwd)
# ------------------------------------------------------------------------------
# Se il file ha campi separati (es: da due punti ':'), IFS dice a read come dividerli.
# Esempio per leggere utenti e loro home directory:

while IFS=":" read -r utente password uid gid info home shell; do
    echo "L'utente $utente ha la home in: $home"
done < /etc/passwd


# 4. LIMITARE LA LETTURA
# ------------------------------------------------------------------------------
# Leggere solo N caratteri
read -n 5 -p "Digita 5 caratteri: " codice

# Impostare un timeout (se l'utente non risponde entro 10 secondi, lo script prosegue)
read -t 10 -p "Rispondi entro 10 secondi: " risposta


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (SCENARI PRATICI)
# ==============================================================================

# --- SCENARIO 1: "Somma i numeri contenuti in un file" ---
# totale=0
# while read -r numero; do
#     totale=$((totale + numero))
# done < numeri.txt
# echo "Il totale è $totale"

# --- SCENARIO 2: "Leggere la risposta di un comando riga per riga" ---
# Se non hai un file fisico, puoi usare una "Pipe" o un "Process Substitution":
# ls -l | while read -r riga; do ... done
# OPPURE (preferibile per non perdere variabili):
# while read -r riga; do ... done < <(ls -l)

# --- ERRORE DA EVITARE ---
# Mai dimenticare il '-r'. Senza '-r', se una riga finisce con '\', 
# read penserà che la riga continui in quella successiva, unendo i dati.

# --- IL SEPARATORE IFS ---
# IFS (Internal Field Separator) è una variabile globale. 
# Se la cambi dentro la riga del 'while' (IFS=":"), vale solo per quel comando.
# Se la cambi prima, influenzerà tutto lo script. Sii prudente!