#!/bin/bash

# ==============================================================================
#   GUIDA COMPLETA A SHOPT (BASH 3.2 LEGACY EDITION)
#   Da salvare per l'esame offline.
# ==============================================================================

# 1. CHE COS'È SHOPT?
# Modifica il comportamento delle "espansioni" (quando usi * o ?).
# Sintassi:
#   shopt -s nome_opzione   (Set = Accendi)
#   shopt -u nome_opzione   (Unset = Spegni)
#   shopt -q nome_opzione   (Quiet = Verifica se è attivo)

# Preparazione Sandbox
mkdir -p test_shopt
touch test_shopt/FILE.TXT
touch test_shopt/foto.jpg
touch test_shopt/.nascosto
cd test_shopt

echo "--- INIZIO TEST BASH 3.2 ---"

# ==============================================================================
# OPZIONE 1: nocaseglob (Case Insensitive)
# ==============================================================================
# A COSA SERVE: Fa sì che *.txt trovi anche .TXT, .Txt, ecc.
# QUANDO USARLO: Quando l'utente non sa se i file sono maiuscoli o minuscoli.

echo -e "\n[1] TEST nocaseglob"
echo "Default: cerco *.txt"
ls *.txt 2>/dev/null || echo " -> Nessun file trovato (Bash distingue maiuscole/minuscole)"

echo "Attivo shopt -s nocaseglob..."
shopt -s nocaseglob
ls *.txt && echo " -> TROVATO! (Ha ignorato le maiuscole)"
shopt -u nocaseglob # Spengo sempre alla fine

# ==============================================================================
# OPZIONE 2: nullglob (Salva-Script)
# ==============================================================================
# A COSA SERVE: Se *.pdf non trova nulla, restituisce "vuoto" invece di "*.pdf".
# QUANDO USARLO: Sempre prima di un ciclo FOR su file, per evitare errori se la cartella è vuota.

echo -e "\n[2] TEST nullglob"
echo "Default: Ciclo su file inesistenti (*.pdf)"
for f in *.pdf; do
    if [[ "$f" == "*.pdf" ]]; then
        echo " -> ERRORE: Bash mi ha ridato l'asterisco letterale!"
    fi
done

echo "Attivo shopt -s nullglob..."
shopt -s nullglob
# Ora il ciclo non parte proprio se non trova nulla
count=0
for f in *.pdf; do
    ((count++))
done
echo " -> Ciclo eseguito $count volte (Corretto, perché non ci sono pdf)"
shopt -u nullglob

# ==============================================================================
# OPZIONE 3: dotglob (Vedere l'invisibile)
# ==============================================================================
# A COSA SERVE: Fa sì che * includa anche i file che iniziano con . (nascosti).
# QUANDO USARLO: Quando devi spostare o cancellare TUTTO da una cartella.

echo -e "\n[3] TEST dotglob"
echo "Default: echo *"
echo * # Output: FILE.TXT foto.jpg (Manca .nascosto)

echo "Attivo shopt -s dotglob..."
shopt -s dotglob
echo *
# Output: FILE.TXT foto.jpg .nascosto (TROVATO!)
shopt -u dotglob

# ==============================================================================
# OPZIONE 4: extglob (Poteri estesi - FONDAMENTALE)
# ==============================================================================
# A COSA SERVE: Permette di dire "Tutto tranne questo".
# SINTASSI: !(pattern) -> Tutto tranne il pattern
# QUANDO USARLO: "Cancella tutti i file tranne lo script".

echo -e "\n[4] TEST extglob (Negazione)"
shopt -s extglob # Su Bash 3.2 di solito è attivo di base, ma forziamolo

echo "Lista di tutto TRANNE i .jpg (!(*.jpg)):"
ls !(*.jpg)
# Dovrebbe mostrare FILE.TXT e basta (ignorando foto.jpg)

shopt -u extglob

# ==============================================================================
# PULIZIA
# ==============================================================================
cd ..
rm -rf test_shopt
echo -e "\n--- FINE LEZIONE ---"