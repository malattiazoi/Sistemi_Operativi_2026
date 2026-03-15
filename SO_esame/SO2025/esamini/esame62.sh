
array=($(echo {A..Z}{A..Z}; echo {a..z}{a..z}; echo {0..9}{0..9}; echo {0..9}{a..z}; echo {a..z}{0..9}; echo {0..9}{A..Z}; echo {A..Z}{0..9}))

echo -e "\x21"

echo avvio brute force

(time ( for i in ${array[@]}; do

    # echo sto provando la combinazione: $i
    hash=$(echo -n $i | md5sum | cut -d " " -f1 )


    if [[ "$hash" == "e0aa021e21dddbd6d8cecec71e9cf564" ]]; then
        echo HO TROVATO LA SEQUENZA.
        echo La sequenza è: $i
        break
    fi

done ) 2>&1 ) | grep -v real