#!/bin/bash

# ==============================================================================
# 00. MANUALE DI SOPRAVVIVENZA: COMANDI BASE, PIPE E REDIREZIONI (MACOS)
# ==============================================================================
# OBIETTIVO:
# Coprire tutte le operazioni fondamentali che si danno per scontate ma che
# causano errori banali (e fatali) all'esame.
#
# AMBIENTE:
# Ottimizzato per macOS (BSD Utils).
# ==============================================================================

# Prepariamo un ambiente pulito per non fare danni nel tuo pc
echo "--- SETUP AMBIENTE DI TEST ---"
mkdir -p test_env/documenti
mkdir -p test_env/backup
cd test_env

# ------------------------------------------------------------------------------
# 1. GESTIONE FILE E CARTELLE (MKDIR, TOUCH, CP, MV, RM)
# ------------------------------------------------------------------------------

# --- MKDIR (Make Directory) ---
# Flag -p (Parents): FONDAMENTALE. Crea le cartelle genitori se non esistono.
# Senza -p, questo comando darebbe errore se 'anno' non esistesse.
mkdir -p documenti/anno/2024/mese/gennaio

# --- TOUCH (Creazione file vuoti / Aggiornamento timestamp) ---
# Crea file vuoti istantaneamente. Utile per testare script.
touch file_a.txt file_b.txt "file con spazi.txt"

# --- CP (Copy) ---
# Copia file.
# Flag -R (Recursive): Obbligatorio per copiare cartelle.
cp file_a.txt backup_file_a.txt
cp -R documenti backup/copia_documenti

# --- MV (Move / Rename) ---
# Serve sia a spostare che a rinominare.
# Se la destinazione è una cartella, sposta. Se è un nome file, rinomina.
mv file_b.txt file_rinominato.txt
mv file_rinominato.txt documenti/

# --- RM (Remove) - PERICOLO ---
# Flag -r (Recursive): Per cancellare cartelle.
# Flag -f (Force): Non chiedere conferma (per script non interattivi).
# ATTENZIONE: Su Mac, rm non ha cestino. È definitivo.
cp file_a.txt file_da_cancellare.txt
rm file_da_cancellare.txt
# rm -rf cartella_da_cancellare (Commentato per sicurezza)


# ------------------------------------------------------------------------------
# 2. LS (LIST) - VEDERE COSA C'È
# ------------------------------------------------------------------------------
# Su macOS, 'ls' è BSD. I colori si attivano con -G, non con --color.

echo "--- LISTA FILE ---"

# Lista dettagliata (-l), mostra file nascosti (-a), colorata (-G)
ls -laG

# Lista ordinata per data di modifica (più recenti in basso) (-rt)
# Utile per vedere l'ultimo file creato.
ls -lrt

# Lista pulita per gli script (-1)
# Stampa un file per riga, senza dettagli. Perfetto per cicli 'for'.
ls -1


# ------------------------------------------------------------------------------
# 3. LINK (LN) - HARD vs SOFT (ESAME 35)
# ------------------------------------------------------------------------------
# Concetto chiave: Inode.
# Soft Link (-s): È una scorciatoia (come su Windows). Se cancelli l'originale, il link si rompe.
# Hard Link (senza flag): È un clone specchio. Condivide lo stesso Inode.

echo "--- GESTIONE LINK ---"
echo "Contenuto Originale" > originale.txt

# Creazione Soft Link
ln -s originale.txt link_soft.txt

# Creazione Hard Link
ln originale.txt link_hard.txt

echo "Dettagli Inode (Nota i numeri nella prima colonna):"
# -i mostra il numero di Inode
ls -li originale.txt link_soft.txt link_hard.txt

# Dimostrazione Rottura
rm originale.txt
echo "Ho cancellato l'originale."
echo "Il Soft Link è rotto (cat darà errore):"
# cat link_soft.txt  <-- Questo darebbe errore
echo "L'Hard Link funziona ancora (i dati sono salvi):"
cat link_hard.txt


# ------------------------------------------------------------------------------
# 4. REDIREZIONI (INPUT, OUTPUT, ERRORI)
# ------------------------------------------------------------------------------
# 0 = STDIN (Tastiera/Input)
# 1 = STDOUT (Schermo/Output normale)
# 2 = STDERR (Errori)

echo "--- REDIREZIONI ---"

# > (Sovrascrittura): Crea il file o lo svuota e scrive.
echo "Prima riga" > output.log

# >> (Append): Aggiunge alla fine senza cancellare.
echo "Seconda riga" >> output.log

# 2> (Errore): Redirige solo gli errori.
# ls file_inesistente 2> errori.log

# 2>&1 (Merge): Unisce errori e output normale nello stesso flusso.
# Fondamentale per loggare tutto ciò che accade in uno script.
ls file_esistente file_inesistente > log_completo.txt 2>&1

cat log_completo.txt


# ------------------------------------------------------------------------------
# 5. PIPE (|) E FILTRI BASE
# ------------------------------------------------------------------------------
# La pipe prende l'output del comando a sinistra e lo usa come input per quello a destra.

echo "--- PIPE E FILTRI ---"

# Creiamo un file disordinato
printf "Zebra\nAlbero\nMela\nAlbero\n" > lista.txt

# SORT: Ordina alfabeticamente
# UNIQ: Rimuove duplicati (richiede input ordinato!)
# TEE: Scrive su file E mostra a schermo contemporaneamente.
cat lista.txt | sort | uniq | tee lista_pulita.txt

# HEAD e TAIL
# head -n 3 : Prime 3 righe
# tail -n 3 : Ultime 3 righe
# tail -f file.log : Segue il file in tempo reale (come un monitor).
echo "Ultime 2 righe:"
tail -n 2 lista_pulita.txt


# ------------------------------------------------------------------------------
# 6. XARGS - IL SALVAVITA DEGLI SCRIPT
# ------------------------------------------------------------------------------
# Problema: Alcuni comandi (come rm) non accettano input da pipe standard.
# Soluzione: xargs prende l'input e lo trasforma in argomenti.

echo "--- XARGS DEMO ---"

# Creiamo tanti file
touch f1.tmp f2.tmp f3.tmp

# Metodo SBAGLIATO (find stampa, rm non legge da stdin):
# find . -name "*.tmp" | rm      <-- NON FUNZIONA

# Metodo CORRETTO (xargs passa i nomi come argomenti a rm):
find . -name "*.tmp" | xargs rm
echo "File .tmp cancellati."

# TRUCCO MACOS: Nomi con spazi
touch "file spazio.tmp"
# find . -name "*.tmp" | xargs rm      <-- ERRORE! rm cercherà "file" e "spazio.tmp"
# Soluzione sicura (-print0 usa il carattere NULL come separatore, -0 lo legge):
find . -name "*.tmp" -print0 | xargs -0 rm
echo "File con spazi cancellati correttamente."


# ------------------------------------------------------------------------------
# 7. PERMESSI (CHMOD) E PROPRIETÀ
# ------------------------------------------------------------------------------
# r (4), w (2), x (1)
# 7 = rwx, 5 = r-x, 4 = r--

echo "--- PERMESSI ---"
touch script.sh

# Rendere eseguibile (uguale a chmod 755 o u+x)
chmod +x script.sh
ls -l script.sh

# Rimuovere permessi di scrittura al gruppo e altri (644 -> 600 per l'utente)
chmod go-w script.sh


# ------------------------------------------------------------------------------
# 8. VARIABILI D'AMBIENTE E ALIAS
# ------------------------------------------------------------------------------
# env: Mostra tutte le variabili.
# export: Rende la variabile visibile ai processi figli.

echo "--- VARIABILI ---"
export MIA_VAR="Esame Superato"
bash -c 'echo "Dentro la subshell vedo: $MIA_VAR"'

# Alias (Utili nel terminale, meno negli script perché non sempre espansi)
alias ll='ls -laG'


# ------------------------------------------------------------------------------
# 9. LOGICA CONDIZIONALE ONE-LINER (&&, ||)
# ------------------------------------------------------------------------------
# && (AND): Esegui il secondo SOLO SE il primo ha avuto successo (exit code 0).
# || (OR):  Esegui il secondo SOLO SE il primo ha FALLITO.

echo "--- LOGICA ONE-LINER ---"
mkdir nuova_cartella && echo "Cartella creata con successo"
rm cartella_inesistente || echo "Non ho potuto cancellare, ma non mi blocco."

# Combinazione (Try-Catch dei poveri)
ls file_fantasma.txt > /dev/null 2>&1 && echo "Esiste" || echo "Non esiste"


# ------------------------------------------------------------------------------
# 10. MACOS SPECIALS (PBCOPY, OPEN)
# ------------------------------------------------------------------------------
# pbcopy: Copia l'input nella clipboard del Mac (Cmd+C).
# pbpaste: Incolla dalla clipboard.
# open: Apre un file o una cartella come se avessi fatto doppio click nel Finder.

echo "Testo copiato nella clipboard" | pbcopy
echo "Contenuto clipboard:"
pbpaste

# Apre la cartella corrente nel Finder (Utile per verificare visualmente)
# open .


# ------------------------------------------------------------------------------
# PULIZIA FINALE
# ------------------------------------------------------------------------------
cd ..
# rm -rf test_env
echo "--- FINE TUTORIAL BASE ---"