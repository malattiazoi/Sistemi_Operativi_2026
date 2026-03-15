### VARIABILI IN BASH - DICHIARAZIONE E USO

#### 1. Dichiarazione base
nome="Mario"
nome="mario rossi"
eta=25

# Importante:
# - Nessuno spazio prima o dopo il simbolo "="
# - I valori con spazi vanno tra virgolette

citta="Roma"
saluto="Ciao $nome, benvenuto a $citta!"
echo "$saluto"

# ---

#### 2. Accesso ai valori
echo "$nome"     # stampa Mario
echo "${nome}"   # forma equivalente, utile in concatenazioni

echo "Utente: $nome_01"

# ---

#### 3. Tipi di variabili
# Tutte le variabili sono stringhe per default.
# Si possono forzare tipi o proprietà con `declare`.

declare -i numero=10      # intero (numeric only)
declare -r COSTANTE=100   # read-only (costante)
declare -a array=(1 2 3)  # array indicizzato
declare -A diz            # array associativo (Bash 4+)

# ---

#### 4. Operazioni aritmetiche
x=5
y=3
## uso di arithmetic expansion
somma=$((x + y))
echo "Somma = $somma"

count=0

((count=count+1))

# Altri esempi:
((x++))     # incrementa x
((x*=2))    # moltiplica x per 2

# ---

#### 5. Variabili d’ambiente
export PATH=$PATH:/nuovo/percorso
export USER="admin"

# Le variabili esportate sono visibili ai processi figli.

# ---

#### 6. Leggere input dell’utente
read -p "Inserisci il tuo nome: " nome
echo "Ciao, $nome!"

# ---

#### 7. Variabili locali e globali
function saluta() {
    local nome="Anna"   # visibile solo dentro la funzione
    echo "Ciao $nome"
}

nome="Luca"
saluta
echo "$nome"  # rimane "Luca"

# ---

#### 8. Variabili di array
numeri=(10 20 30)
echo "Primo: ${numeri[0]}"
echo "Tutti: ${numeri[@]}"
echo "Lunghezza: ${#numeri[@]}"

# Aggiungere elementi:
numeri+=(40)

# ---

# #### 9. Array associativi (chiave -> valore)
# declare -A capitale
# capitale[it]="Roma"
# capitale[fr]="Parigi"
# capitale[es]="Madrid"

echo "Capitale d'Italia: ${capitale[it]}"

for paese in "${!capitale[@]}"; do
    echo "$paese -> ${capitale[$paese]}"
done

# ---

#### 10. Espansione di default e condizionale
nome=${USER:-"Sconosciuto"}    # Se $USER vuoto, usa "Sconosciuto"
citta=${citta:-"Roma"}         # Se non definita, assegna "Roma"
echo "Utente: $nome, Città: $citta"

# ---

#### 11. Rimuovere o modificare variabili
unset nome      # elimina la variabile
unset numeri[1] # rimuove elemento da array

# ---

#### 12. Stringhe e manipolazioni
var="abcdef"
echo "${#var}"        # lunghezza (6)
echo "${var:2}"       # da indice 2 -> "cdef"
echo "${var:1:3}"     # da indice 1 per 3 char -> "bcd"
echo "${var^^}"       # maiuscolo -> "ABCDEF"
echo "${var,,}"       # minuscolo -> "abcdef"
