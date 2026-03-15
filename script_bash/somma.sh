read -p "inserisci il primo numero: " x
read -p "inserisci il secondo numero: " y
echo "la somma è: $((x + y))"

read -p "inserisci il primo numero float: " a
read -p "inserisci il secondo numero float: " b
echo "la somma è: $(echo "$a + $b" | bc)"

read -p "inserisci il primo numero esadecimale (es. 0xA): " m #metti 0x prima del numero
read -p "inserisci il secondo numero esadecimale (es. 0xA): " n
echo "la somma è: $((m + n))"   

#somma di numeri in un array
read -p "quanti numeri vuoi sommare? " count
numbers=() #dichiaro un array vuoto
for ((i=0; i<count; i++)); do
    read -p "inserisci il numero $((i+1)): " number
    numbers+=("$number") #aggiungo il numero all'array
done