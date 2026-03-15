# for percorso in $(find . -maxdepth 1); do
#     echo "percorso: $percorso"
# done

nomi=("Anna vv" "Luca" "Sara")
for n in "${nomi[@]}"; do
    echo "Nome: $n"
done

echo lunghezza array: "${#nomi[@]}"

# "${nomi[@]}"  --> ("Anna vv" "Luca" "Sara")
# "${!nomi[@]}" --> (  0          1     2)
# "${#nomi[@]}" --> 3
# ---

#### 8. Ciclo sugli indici di un array
for i in "${!nomi[@]}"; do
    echo "Indice $i -> ${nomi[$i]}"
done

echo ==============

for x in {1..3}; do
    for y in {A..C}; do
        echo "$x$y"
    done
done

echo ==============

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


echo ===================

# Legge ogni riga di un file e la stampa
while read -r riga; do
    echo "Riga: $riga"
done < elenco.txt
