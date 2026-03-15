#variabiliarray.sh
#dichiarazione array
numeri=(10 20 30)
echo "primo: ${numeri[0]}"
echo "secondo: ${numeri[@]}"
echo "lunghezza: ${#numeri[@]}"

#aggiungo un elemento
numeri+=(40)
echo "dopo aggiunta: ${numeri[@]}, e lunghezza: ${#numeri[@]}"