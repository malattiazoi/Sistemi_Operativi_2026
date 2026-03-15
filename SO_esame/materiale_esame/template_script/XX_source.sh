#!/bin/bash

# ==============================================================================
#   GUIDA PRATICA A 'SOURCE' (e al punto .)
# ==============================================================================

# TEORIA VELOCE:
# 1. Eseguire uno script (./script.sh) crea un PROCESSO FIGLIO (Subshell).
#    Le variabili create lì dentro MUOIONO quando lo script finisce.
#
# 2. Usare 'source script.sh' (o '. script.sh') esegue i comandi
#    nel PROCESSO CORRENTE. Le variabili restano vive!

# Colori per output
G="\033[0;32m" # Verde
R="\033[0;31m" # Rosso
X="\033[0m"    # Reset

echo "--- PREPARAZIONE AMBIENTE ---"
# Creiamo al volo un file esterno chiamato 'config.env'
# Contiene una variabile e una funzione.
cat > config.env <<EOF
ESAME_VOTO="30 e Lode"
function saluta_prof() {
    echo "Buonasera Professore!"
}
EOF
echo "Creato file temporaneo 'config.env' con VOTO e FUNZIONE."

echo ""
echo "==========================================================="
echo "   TEST 1: ESECUZIONE NORMALE (SENZA SOURCE)"
echo "   Comando: bash config.env"
echo "==========================================================="

# Eseguiamo in una subshell
bash config.env

echo -n "Cerco la variabile \$ESAME_VOTO: "
if [ -z "$ESAME_VOTO" ]; then
    echo -e "${R}VUOTA (Non esiste)${X}"
    echo "-> Perché? La variabile è nata e morta nel processo figlio."
else
    echo -e "${G}$ESAME_VOTO${X}"
fi

echo ""
echo "==========================================================="
echo "   TEST 2: ESECUZIONE CON SOURCE (IL MODO GIUSTO)"
echo "   Comando: source config.env"
echo "==========================================================="

# Carichiamo nel processo corrente
source config.env

echo -n "Cerco la variabile \$ESAME_VOTO: "
if [ -n "$ESAME_VOTO" ]; then
    echo -e "${G}$ESAME_VOTO${X}"
    echo "-> Successo! La variabile è stata importata qui."
else
    echo -e "${R}ERRORE${X}"
fi

echo -n "Provo a lanciare la funzione importata: "
saluta_prof

echo ""
echo "==========================================================="
echo "   NOTA SINTASSI (IL PUNTO)"
echo "==========================================================="
echo "In Bash, scrivere:"
echo "  source config.env"
echo "è IDENTICO a scrivere:"
echo "  . config.env"
echo "(Il punto è solo la versione breve e standard POSIX)"

# Pulizia
rm config.env
echo -e "\nPulizia effettuata. Fine."