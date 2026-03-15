echo primo argomento: $1
argmnt1=$1
shift 1
echo secondo argomento: $2
echo terzo argomento: $3

echo il nome dello script è: $0
echp hai inserito $# argomenti

#usiamo solo valori numerici 0 per nome dello script e 1,2,3 per i primi tre argomenti
#$# contiene il numero di argomenti passati allo script
#shift 1 sposta tutti gli argomenti di una posizione a sinistra,
#quindi $2 diventa $1, $3 diventa $2 e così via
#$@ contiene tutti gli argomenti passati allo script come una lista

#exit 0 #-----------------<

echo "nulla verrà eseguito dopo l'istruzione exit"
echo "tutti gli argomenti passati allo script: $@"

# usiamo lo shift per scorrere tutti gli argomenti e consumarli
while [ $# -gt 0 ]; do
    echo "Argomento corrente: $1"
    shift 1
done


