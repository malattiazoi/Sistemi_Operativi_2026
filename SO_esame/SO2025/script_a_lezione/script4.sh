# while true; do
#     echo "Loop infinito"
#     # sleep 0.5
# done

# while true; do
#     read -p "Scrivi qualcosa (esci per terminare): " x
    
#     if [ "$x" = "esci" ]; then
#         break
#     fi

#     if [ -z "$x" ]; then
#         continue
#     fi
  
#     echo non è successo di fare continue
#     echo "Hai scritto: $x"
# done



while IFS=',' read -r nome cognome anni; do
    echo "il ragazzo $nome $cognome ha $anni anni"
done < elenco.csv