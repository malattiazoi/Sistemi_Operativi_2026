#!/bin/bash

# ==============================================================================
# 01. REGEX MASTER CLASS: GREP E ESPRESSIONI REGOLARI (MACOS EDITION)
# ==============================================================================
# OBIETTIVO:
# Imparare a cercare pattern complessi dentro i file.
# Fondamentale per:
# 1. Filtrare file di log (es. "Trova tutti gli errori tra le 10:00 e le 11:00").
# 2. Validare input utente (es. "È una mail valida? È un codice fiscale?").
# 3. Estrarre dati specifici (es. "Dammi solo gli indirizzi IP").
#
# AMBIENTE: macOS (BSD grep)
# REGOLA D'ORO: Usa SEMPRE 'grep -E' (Extended) per non impazzire con gli escape.
# ==============================================================================

# Prepariamo un file di test sporco e complesso
echo "--- Creazione file di test (dati.txt) ---"
cat <<EOF > dati.txt
Mario Rossi - mario.rossi@email.com - IP: 192.168.1.10
Luigi Verdi - luigi.verdi@test.it - IP: 10.0.0.1
Anna Bianchi - anna@studio.com - IP: 172.16.0.50
ERROR: Connessione fallita alle 10:00
WARNING: Spazio disco in esaurimento (90%)
DEBUG: Variabile x=10
root:x:0:0:System Administrator:/var/root:/bin/sh
Un numero a caso: 12345
Una data: 2024-01-25
Un codice: AB-999-CD
EOF

echo "File creato. Inizio Tutorial Regex."
echo "----------------------------------------------------------------"


# ==============================================================================
# 1. I FLAG FONDAMENTALI DI GREP (MACOS)
# ==============================================================================

echo "--- 1. FLAG ESSENZIALI ---"

# -E : Extended Regex. ABILITALO SEMPRE. Permette di usare +, ?, |, () senza backslash.
# -i : Case Insensitive. Ignora maiuscole/minuscole.
grep -E -i "mario" dati.txt

# -v : Invert Match. Stampa tutto CIÒ CHE NON combacia.
# Esempio: "Fammi vedere tutto tranne gli errori"
grep -v "ERROR" dati.txt

# -n : Number. Mostra il numero di riga dove ha trovato il match.
grep -n "IP:" dati.txt

# -c : Count. Non stampa le righe, ma conta quante sono.
# "Quanti IP ci sono nel file?"
grep -c "IP:" dati.txt

# -o : Only Matching. Stampa SOLO la parte della riga che combacia.
# CRITICO: Se cerchi un IP in una riga lunga, -o ti estrae solo l'IP pulito.
grep -E -o "192\.168\.1\.10" dati.txt

# -r : Recursive. Cerca in tutte le sottocartelle.
# grep -r "pattern" .


# ==============================================================================
# 2. ANCORE (INIZIO E FINE RIGA)
# ==============================================================================
# ^ = Inizio della riga
# $ = Fine della riga

echo "----------------------------------------------------------------"
echo "--- 2. ANCORE (^ e $) ---"

# Cerca righe che INIZIANO con "root"
grep -E "^root" dati.txt

# Cerca righe che FINISCONO con "sh"
grep -E "sh$" dati.txt

# Cerca righe VUOTE (Inizio e subito Fine)
# grep -E "^$" file.txt


# ==============================================================================
# 3. CLASSI DI CARATTERI E RANGE []
# ==============================================================================
# [abc] = Cerca 'a' OPPURE 'b' OPPURE 'c'.
# [a-z] = Qualsiasi lettera minuscola.
# [0-9] = Qualsiasi numero.
# [^abc] = Qualsiasi cosa che NON sia 'a', 'b' o 'c' (Negazione).

echo "----------------------------------------------------------------"
echo "--- 3. CLASSI DI CARATTERI ---"

# Cerca un codice formato da due lettere maiuscole, trattino, numeri...
# Pattern: [A-Z][A-Z]
grep -E "[A-Z][A-Z]" dati.txt

# Cerca righe che contengono numeri
grep -E "[0-9]" dati.txt


# ==============================================================================
# 4. QUANTIFICATORI (QUANTE VOLTE?)
# ==============================================================================
# Qui serve obbligatoriamente grep -E su Mac.
# .  = Qualsiasi carattere singolo (tranne a capo).
# * = 0 o più volte (il precedente).
# +  = 1 o più volte (il precedente).
# ?  = 0 o 1 volta (opzionale).
# {N} = Esattamente N volte.
# {N,M} = Da N a M volte.

echo "----------------------------------------------------------------"
echo "--- 4. QUANTIFICATORI (* + ? {}) ---"

# Esempio .: "r.ssi" trova rossi, rassi, russi...
grep -E "r.ssi" dati.txt

# Esempio +: Trova numeri consecutivi (una o più cifre)
# [0-9]+ significa "un numero intero di qualsiasi lunghezza"
grep -E -o "[0-9]+" dati.txt

# Esempio {N}: Trova esattamente 3 numeri (es. 999 o 192)
grep -E -o "[0-9]{3}" dati.txt

# Esempio ?: "color" o "colour" -> colou?r
# (la u c'è 0 o 1 volta)


# ==============================================================================
# 5. GRUPPI E ALTERNANZA (|)
# ==============================================================================
# (ab|cd) = Cerca "ab" OPPURE "cd".
# Le parentesi raggruppano i token.

echo "----------------------------------------------------------------"
echo "--- 5. GRUPPI E OR (|) ---"

# Cerca "ERROR" oppure "WARNING"
grep -E "ERROR|WARNING" dati.txt

# Cerca "Mario" o "Luigi" seguito da "Rossi" o "Verdi"
grep -E "(Mario|Luigi) (Rossi|Verdi)" dati.txt


# ==============================================================================
# 6. CLASSI POSIX (STANDARD SICURO)
# ==============================================================================
# Su macOS e Linux, queste classi sono più sicure dei range [a-z] perché
# gestiscono meglio le lingue e i set di caratteri strani.
# [:digit:] = [0-9]
# [:alpha:] = [a-zA-Z]
# [:alnum:] = [a-zA-Z0-9]
# [:space:] = Spazi, tab, a capo
# [:upper:] = Maiuscole
# [:lower:] = Minuscole

echo "----------------------------------------------------------------"
echo "--- 6. CLASSI POSIX ---"

# Trova righe che iniziano con una Maiuscola
grep -E "^[[:upper:]]" dati.txt

# Trova sequenze di soli numeri
grep -E -o "[[:digit:]]+" dati.txt


# ==============================================================================
# 🧩 ESEMPI PRATICI COMPLESSI (SCENARI D'ESAME)
# ==============================================================================

echo "----------------------------------------------------------------"
echo "--- SCENARI D'ESAME ---"

# SCENARIO A: ESTRARRE INDIRIZZI IP (Regex IP Standard)
# Pattern: num.num.num.num
# Semplificato: [0-9]+ \. [0-9]+ \. [0-9]+ \. [0-9]+
# Nota: Il punto . va escapato (\.) altrimenti vuol dire "qualsiasi char".
echo "--- Estrazione IP ---"
grep -E -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" dati.txt

# SCENARIO B: ESTRARRE INDIRIZZI EMAIL
# Pattern: testo @ testo . testo
# [a-zA-Z0-9._-]+  = Utente (lettere, numeri, punti, underscore, trattini)
# @                = Chiocciola
# [a-zA-Z0-9.-]+   = Dominio
# \.               = Punto
# [a-zA-Z]+        = Estensione (com, it, org)
echo "--- Estrazione Email ---"
grep -E -o "[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+" dati.txt

# SCENARIO C: VALIDARE UN FORMATO SPECIFICO (Es. Codice AB-999-CD)
# Pattern: 2 Maiuscole, trattino, 3 Numeri, trattino, 2 Maiuscole
# ^[A-Z]{2}-[0-9]{3}-[A-Z]{2}$
echo "--- Validazione Codice ---"
# Creiamo una variabile
CODICE="AB-999-CD"
if echo "$CODICE" | grep -E -q "^[A-Z]{2}-[0-9]{3}-[A-Z]{2}$"; then
    echo "Il codice $CODICE è VALIDO."
else
    echo "Il codice $CODICE NON è valido."
fi

# SCENARIO D: CERCARE FILE SOSPETTI (SOLUZIONE PARZIALE ESAME 12)
# "Trova file che contengono la stringa 'esame' nel nome o dentro"
# find . -type f | xargs grep -l "esame"
# (-l stampa solo il nome del file che contiene il match, non il contenuto)


# ==============================================================================
# ⚠️ TABELLA CARATTERI SPECIALI (METACHARACTERS)
# ==============================================================================
# Se devi cercare questi caratteri come TESTO, devi metterci davanti un backslash \
#
# .   -> \.  (Punto reale)
# * -> \* (Asterisco reale)
# ?   -> \?  (Punto interrogativo reale)
# +   -> \+  (Più reale)
# $   -> \$  (Dollaro reale)
# [   -> \[  (Parentesi quadra)
# (   -> \(  (Parentesi tonda)
# |   -> \|  (Pipe verticale)
# \   -> \\  (Backslash)

echo "--- Ricerca caratteri speciali ---"
# Cerchiamo la parentesi tonda aperta in "(90%)"
grep -E "\(" dati.txt


# ==============================================================================
# 💡 TRUCCHI MACOS VS LINUX
# ==============================================================================
# 1. Word Boundary (\b):
#    Su Linux GNU grep: \bciao\b trova "ciao" ma non "ciaone".
#    Su macOS BSD grep moderno: \b funziona, ma su vecchi sistemi si usava [[:<:]] e [[:>:]].
#    Consiglio: Usa `grep -w "ciao"` (Word match) che è portabile e sicuro.

echo "--- Word Match (-w) ---"
echo "ciao ciaone" | grep -w "ciao"
# Trova solo la prima parola, ignora "ciaone".

# Pulizia
rm -f dati.txt
echo "----------------------------------------------------------------"
echo "Tutorial Regex Completato."

# ==============================================================================
# GUIDA RAPIDA ALLE REGEX (BRE vs ERE) - KIT ESAME
# ==============================================================================

# 1. METACARATTERI UNIVERSALI
# .          -> Qualsiasi carattere singolo (tranne l'invio)
# ^          -> Inizio riga (es. ^Errore trova solo se la riga inizia con Errore)
# $          -> Fine riga (es. Fine$ trova solo se la riga finisce con Fine)
# [abc]      -> Uno qualsiasi dei caratteri tra parentesi
# [^abc]     -> Qualsiasi carattere TRANNE quelli indicati
# [0-9]      -> Qualsiasi cifra

# 2. QUANTIFICATORI (Quante volte deve apparire il carattere precedente)
# * -> Da 0 a infinite volte
# +          -> Da 1 a infinite volte (Richiede -E in grep)
# ?          -> 0 oppure 1 volta (Richiede -E in grep)
# {n}        -> Esattamente n volte
# {n,}       -> Almeno n volte

# 3. CLASSI POSIX (Molto utili per la portabilità su MacOS/Linux)
# [[:digit:]]  -> Numeri (0-9)
# [[:alpha:]]  -> Lettere (a-z, A-Z)
# [[:alnum:]]  -> Lettere e Numeri
# [[:space:]]  -> Spazi, Tab, ecc.
# [[:upper:]]  -> Solo Maiuscole

# ==============================================================================
# ESEMPI PRATICI DA COPIARE/INCOLLARE IN ESAME
# ==============================================================================

# Cerca righe che iniziano con una cifra
# grep '^[0-9]' file.txt

# Cerca righe che contengono SOLO numeri
# grep -E '^[0-9]+$' file.txt

# Cerca email semplici (testo @ testo . testo)
# grep -E '[[:alnum:]]+@[[:alnum:]]+\.[[:alpha:]]{2,}' file.txt

# Cerca parole che iniziano con 'A' e finiscono con 'O'
# grep -E '\<A[[:alpha:]]*O\>' file.txt  # \< e \> sono ancore di parola

# TROVARE RIGHE VUOTE (classico da esame)
# grep '^$' file.txt

# TROVARE RIGHE NON VUOTE
# grep -v '^$' file.txt

# ==============================================================================
# NOTA PER MACOS (Ambiente BSD)
# ==============================================================================
# Ricorda: su MacOS 'grep' è di derivazione BSD. 
# Usa sempre l'opzione -E se vuoi usare +, ?, | e le parentesi tonde 
# senza impazzire con i backslash.