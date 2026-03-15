stringa=$1

stringa_splittata=$(echo -n $stringa | fold -1)

risultato_cifrato=
for i in ${stringa_splittata[@]}; do
    if [[ $(echo -n $i | tr -d "A-Ma-m" | wc -c ) -eq 0 ]]; then
        traslazione=13
    else
        traslazione=-13
    fi
    decimale_traslato=$(( $(echo "obase=10; ibase=16; $(echo -n $i | xxd -p |  tr "a-z" "A-Z" )" | bc) + $traslazione ))
    risultato_cifrato=$risultato_cifrato$(echo -e "\x$(echo "obase=16; ibase=10; $decimale_traslato" | bc)")
done

echo $risultato_cifrato


## alternativa usando solo tr
# echo "$stringa" | tr 'A-Za-z' 'N-ZA-Mn-za-m'

# entrambe le soluzioni sono valide (così come altre possibili soluzioni)
# la prima soluzione permette di fare diversi tipi di rotazione in base al valore impostato (es. 13),  ma è più lunga
# la seconda è più rapida, si scrive in un solo rigo ma è limitata a rotazione 13.


