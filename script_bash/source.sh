
# =========================================================
# File: setup_env.sh
# Descrizione: Definisce variabili e funzioni utili
# =========================================================

# Definizione di una variabile d'ambiente
USER_NAME="Alice"
APP_ENV="Sviluppo"

# Funzione di esempio
saluta() {
    echo "Ciao $USER_NAME! Benvenuto nell'ambiente $APP_ENV."
}

# Mostriamo che questo file è stato caricato
echo "[setup_env.sh] Variabili e funzioni definite!"



# =========================================================
# File: main.sh
# Descrizione: Dimostrazione pratica del comando source
# =========================================================

echo "==============================="
echo " ESEMPIO 1: esecuzione normale"
echo "==============================="

# Qui eseguiamo setup_env.sh come un normale script.
# NOTA: le variabili definite dentro non saranno visibili dopo.
bash setup_env.sh

echo "Proviamo a stampare USER_NAME dopo l'esecuzione normale:"
echo "USER_NAME = $USER_NAME"  # <- sarà vuoto
echo

echo "==============================="
echo " ESEMPIO 2: utilizzo di source"
echo "==============================="

# Qui invece usiamo source (o '.')
# In questo modo, le variabili e funzioni definite nel file
# vengono caricate nella shell corrente.
source setup_env.sh

echo "Proviamo a stampare USER_NAME dopo source:"
echo "USER_NAME = $USER_NAME"  # <- sarà valorizzato

echo
echo "Ora possiamo anche chiamare la funzione definita in setup_env.sh:"
saluta  # <- definita nel file caricato
echo

echo "==============================="
echo " ESEMPIO 3: forma abbreviata con punto (.)"
echo "==============================="

# La forma con il punto è identica a 'source'
. setup_env.sh

echo "Variabili ancora accessibili:"
echo "USER_NAME = $USER_NAME"
echo "APP_ENV   = $APP_ENV"
echo
