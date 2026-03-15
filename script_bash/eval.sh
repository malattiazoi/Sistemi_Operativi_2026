
# =========================================================
# File: eval_demo.sh
# Scopo: dimostrare l'uso del comando eval in Bash
# =========================================================

# Esempio 1: esecuzione normale
CMD="echo Ciao Mondo"
echo "Esecuzione normale:"
echo $CMD       # stampa solo il testo
$CMD            # esegue il comando contenuto nella variabile
echo

# Esempio 2: uso di eval
CMD="echo Ciao Mondo"
echo "Esecuzione con eval:"
eval $CMD       # eval interpreta la stringa e la esegue
echo

# Esempio 3: costruzione dinamica di comandi
VAR="NOME"
VALORE="Alice"
# Qui creiamo una stringa che contiene un comando di assegnazione
COMANDO="$VAR=\"$VALORE\""

echo "Comando costruito dinamicamente:"
echo $COMANDO
echo

# Senza eval, non accade nulla
echo "Senza eval:"
echo "NOME = $NOME"   # variabile non definita
echo

# Con eval, Bash esegue effettivamente l'assegnazione
eval $COMANDO
echo "Con eval:"
echo "NOME = $NOME"   # ora contiene 'Alice'
echo

# Esempio 4: combinazione con comandi multipli
ACTION="ls"
DIR="."
echo "Esecuzione di comando composto con eval:"
eval "$ACTION $DIR"
