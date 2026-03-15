### ESEMPI DI `for` IN BASH

#### 1. Ciclo su una lista di valori
for x in Anna Marco Luca; do
    echo "Ciao $x"
done
echo ========ciclo for finito

echo "$x"

exit
# ---

#### 2. Ciclo su una sequenza numerica
for i in {1..5}; do
    echo "Numero: $i"
done

# ---

#### 3. Ciclo con passo personalizzato
for i in {0..10..2}; do
    echo "Numero pari: $i"
done

# ---

#### 4. Stile “C”
for ((i=1; i<=5; i++)); do
    echo "Iterazione $i"
done

# ---

#### 5. Ciclo su file in una directory
for file in *.txt; do
    echo "File trovato: $file"
done

# ---

#### 6. Ciclo su output di un comando
for percorso in $(find .); do
    echo "percorso: $percorso"
done

# ---

#### 7. Ciclo su un array
nomi=("Anna vv" "Luca" "Sara")
for n in "${nomi[@]}"; do
    echo "Nome: $n"
done

# ---

#### 8. Ciclo sugli indici di un array
for i in "${!nomi[@]}"; do
    echo "Indice $i -> ${nomi[$i]}"
done

# ---

#### 9. Ciclo annidato
for x in {1..3}; do
    for y in {A..C}; do
        echo "$x$y"
    done
done

# ---

#### 10. Ciclo con break e continue
for i in {1..10}; do
    
    if [ "$i" -eq 5 ]; then
        echo "Salto il numero 5"
        continue
    fi
    if [ "$i" -gt 8 ]; then
        echo "Interrompo il ciclo"
        break
    fi
    echo "Numero: $i"
done

# ---

#### 11. Ciclo su righe di un file (metodo con `read`)
# Legge ogni riga di un file e la stampa
while read -r riga; do
    echo "Riga: $riga"
done < elenco.txt

# Uso tipico: processare un elenco di nomi o percorsi
read -p "inserisci valore da tastiera:" val

# ---

#### 12. Ciclo su campi di una riga letta da file
# File: persone.txt
# Contenuto:
# Anna Rossi 25
# Marco Bianchi 30
# Lucia Verdi 22

while IFS=' ' read -r nome cognome eta; do
    echo "Nome: $nome | Cognome: $cognome | Età: $eta"
done < persone.txt

# ---

#### 13. Uso combinato: `for` + `read`
# Legge tutte le righe di un file in un array, poi le scorre
mappa=()
while IFS= read -r linea; do
    mappa+=("$linea")
done < dati.txt

for elemento in "${mappa[@]}"; do
    echo "Elemento: $elemento"
done

# ---

#### 14. Esempio pratico: rinominare file numerandoli
i=1
for file in *.jpg; do
    mv "$file" "immagine_$i.jpg"
    ((i++))
done

# ---

#### 15. Esempio pratico: creare directory da un elenco
# File dirs.txt:
# progetto1
# progetto2
# backup

while IFS= read -r dir; do
    mkdir -p "$dir"
    echo "Creata directory: $dir"
done < dirs.txt
