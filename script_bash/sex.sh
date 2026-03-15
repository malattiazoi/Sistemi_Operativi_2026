read -p "inserisci il tuo nome: " nome
echo "Ciao $nome"
read -p "inserisci il tuo cognome: " cognome
echo "Ciao $nome $cognome"
read -p "inserisci la tua età: " eta
echo "Ciao $nome $cognome, hai $eta anni e sei ancora vergine?"
read -p "[Y/N]: " ans
if [ "$ans" == "Y" ] || [ "$ans" == "y" ]; then
    echo "Bravo, sei ancora vergine!"
elif [ "$ans" == "N" ] || [ "$ans" == "n" ]; then
    echo "Peccato, hai perso la verginità! Gesù ti punira sessualmente!"
else
    echo "Risposta non valida."
fi