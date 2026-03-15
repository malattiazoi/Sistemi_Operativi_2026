# x=10
# y=7
# if [ "$x" -gt "$y" ]; then
#     echo "x che è $x, è maggiore di $y"
#     echo altra riga
# fi


# nome1="Marco"
# nome2="Luca"
# nome3="Ugo"
# if [ "$nome1" = "$nome2" ]; then
#     echo "nome1 e nome2 corrispondono"
# elif [ "$nome1" = "$nome3" ]; then
#     echo "nome1 e nome3 corrispondono"
# else
#     echo nessuna corrispondenza tra i nomi
# fi


file="testo.txt"
if [ -f "$file" ]; then
    echo "Il file $file esiste"
    echo te lo sto visualizzando qui sotto
    cat "$file"
else
    echo "Il file $file non esiste"
    echo "lo creo per te ora scrivendo dentro qualcosa"
    # touch "$file"
    echo qualcosa > "$file"
fi
