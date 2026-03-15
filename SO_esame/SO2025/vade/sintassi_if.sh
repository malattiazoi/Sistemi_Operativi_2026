### Esempi di IF in bash

#### 1. Confronto numerico
x=10
if [ "$x" -gt 5 ]; then
    echo "x è maggiore di 5"
fi

x=10
y=7
if [ "$x" -gt "$y" ]; then
    echo "x che è $x, è maggiore di $y"
    echo altra riga
fi

# Operatori numerici principali:
# -eq (uguale), -ne (diverso), -gt (maggiore), 
# -ge (maggiore o uguale),
# -lt (minore), -le (minore o uguale)

# ---

#### 2. Confronto stringhe
nome="Marco"
if [ "$nome" = "Marco" ]; then
    echo "Ciao Marco!"
fi

# Altri operatori:
# = (uguale), != (diverso), -z (stringa vuota), -n (stringa non vuota)

# ---

#### 3. IF...ELSE
x=3
if [ "$x" -ge 10 ]; then
    echo "Grande"
else
    echo "Piccolo"
fi

# ---

#### 4. IF...ELIF...ELSE
x=15
if [ "$x" -lt 10 ]; then
    echo "Piccolo"
elif [ "$x" -lt 20 ]; then
    echo "Medio"
else
    echo "Grande"
fi

# con stringhe: 

nome1="Marco"
nome2="Luca"
nome3="Ugo"
if [ "$nome1" = "$nome2" ]; then
    echo "nome1 e nome2 corrispondono"
elif [ "$nome1" = "$nome3" ]; then
    echo "nome1 e nome3 corrispondono"
else
    echo nessuna corrispondenza tra i nomi
fi

# ---

#### 5. Controllare se un file esiste
file="testo.txt"
if [ -f "$file" ]; then
    echo "Il file $file esiste"
else
    echo "Il file $file non esiste"
fi

# Principali test su file:
# -f file -> esiste ed è regolare
# -d dir  -> esiste ed è directory
# -e file -> esiste (qualsiasi tipo)
# -r file -> leggibile
# -w file -> scrivibile
# -x file -> eseguibile

# ---

#### 6. Controllare se una directory esiste
if [ -d "/etc" ]; then
    echo "La directory /etc esiste"
fi

# ---

#### 7. Condizione multipla (AND e OR)
x=7
if [ "$x" -gt 5 ] && [ "$x" -lt 10 ]; then
    echo "x è tra 6 e 9"
fi

y="ciao"
if [ "$y" = "ciao" ] || [ "$y" = "hello" ]; then
    echo "y è una parola di saluto"
fi

# ---

#### 8. Uso con [[ ... ]] (più potente di [ ... ])
x=42
if [[ $x -ge 10 && $x -le 50 ]]; then
    echo "x è tra 10 e 50"
fi

# Con [[ ]] si possono usare anche regex:
string="ciao123"
if [[ $string =~ ^ciao[0-9]+$ ]]; then
    echo "Stringa valida"
fi
