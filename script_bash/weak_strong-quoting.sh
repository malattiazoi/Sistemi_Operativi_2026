
# ========================================================
# Dimostrazione di weak e strong quoting in Bash
# ========================================================

# Definiamo una variabile
NOME="Alice"
DATA=$(date +%Y-%m-%d)

echo "Esempio 1: Senza virgolette"
echo Ciao $NOME, oggi è $DATA
echo

# --------------------------------------------------------
echo "Esempio 2: Virgolette doppie (weak quoting)"
echo "Ciao $NOME, oggi è $DATA"
echo

# --------------------------------------------------------
echo "Esempio 3: Virgolette singole (strong quoting)"
echo 'Ciao $NOME, oggi è $DATA'
echo

# --------------------------------------------------------
echo "Esempio 4: Combinazioni e differenze"
echo "Percorso con spazio: /home/$NOME Documenti"
echo 'Percorso con spazio: /home/$NOME Documenti'
echo

# --------------------------------------------------------
echo "Esempio 5: Escape all'interno delle virgolette doppie"
echo "Virgolette doppie con \"escape\""
echo 'Virgolette singole con '\''escape'\'''
echo
