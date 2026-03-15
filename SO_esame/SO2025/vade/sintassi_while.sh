### CHEAT SHEET - LOOP `while` in Bash

#### Sintassi base
while [ condizione ]; do
    comandi
done

# ---

#### Esempio base
i=1
while [ $i -le 5 ]; do
    echo "Iterazione $i"
    ((i++))
done

# ---

#### Ciclo infinito
while true; do
    echo "Loop infinito"
    sleep 1
done

# ---

#### Con break e continue
while true; do
    read -p "Scrivi qualcosa (esci per terminare): " x
    [ "$x" = "esci" ] && break
    [ -z "$x" ] && continue
    echo "Hai scritto: $x"
done

# ---

#### Leggere file riga per riga
while IFS= read -r linea; do
    echo "Riga: $linea"
done < file.txt

# ---

#### Leggere più campi da un file
while IFS=' ' read -r nome cognome eta; do
    echo "$nome $cognome ha $eta anni"
done < persone.txt

# ---

#### Ciclo basato su comando
while ping -c1 8.8.8.8 &>/dev/null; do
    echo "Connessione OK"
    sleep 5
done

# ---

#### Esempio pratico: sommare numeri da file
somma=0
while read -r n; do
    ((somma+=n))
done < numeri.txt
echo "Somma totale: $somma"


## cicli while true

while true; do
    # comandi da eseguire ripetutamente
done


while true; do
    echo "Ciao! Questo ciclo non finisce mai !!"
    sleep 1   # attende 1 secondo
done


while true; do
    read -p "Scrivi qualcosa (o 'esci' per terminare): " input

    if [[ $input == "esci" ]]; then
        echo "Arrivederci!"
        break
    fi

    echo "Hai scritto: $input"
done
