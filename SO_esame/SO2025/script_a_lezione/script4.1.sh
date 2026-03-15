while IFS=',' read -r nome cognome x; do
    echo "il ragazzo $nome $cognome ha $x anni
done < elenco.csv
