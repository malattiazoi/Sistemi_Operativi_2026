

# a=ciao

# pwd

# cd ..

# pwd


conferma_uscita() {
  echo -n "Quittare? (y/n): "
  read risposta
  [[ $answer == "y" ]] && exit 0
}

volevi(){
    echo eh volevi uscire, io qua sto facendo cose importanti..
}

# trap conferma_uscita SIGINT
trap volevi SIGINT
# trap "echo eh volevi; ls; stat ." SIGINT

while true; do
  echo "Facendo cose..."
  echo il mio pid è $$
  sleep 2
done