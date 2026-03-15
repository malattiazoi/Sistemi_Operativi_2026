#e35
# Creare nella propria home di hplinux2.unile.it una directory 
# denominata proprioaccount.esame35 (es.franco.esame35).
# Svolgere gli esercizi in tale directory (oppure svolgerli in una directory con lo stesso nome
# nella propria home Mac OS X e poi trasferirla nella propria home su hplinux2.unile.it).
# A meno di differente indicazione, gli script creati devono essere eseguibili sia su Mac OS X 
# che su Linux.
# Nella directory si DEVE anche creare un file di nome "leggimi" contenente commenti e/o osservazioni.
# Si fa presente che la presenza di tale file aiuta a comprendere parti della prova talvolta 
# incomprensibili e, di conseguenza, non valutate o valutate negativamente.

# Alla fine usare i comandi:

# cd
# tar cvf proprioaccount.esame35.tar proprioaccount.esame35
# gzip proprioaccount.esame35.tar

# Esercizio1

# Creare uno script - al quale viene passato un parametro N (numero intero positivo) -
# che crei nella cartella corrente N soft link agli N file di maggiori dimensioni presenti nel 
# file system.
# Il nome di tali link deve essere costituito da 12 cifre che esprimano la dimensione del file in bytes
# seguite da un trattino e dal basename originale del file (es. se un file di nome pippo.txt e 
# dimensioni 10 MB rientra tra gli N pi  grandi presenti nel file system, deve essere creato un link
# di nome 000010485760-pippo.txt).

MAX_FILES=$1
# IFS=$'\n'

IFS='
'

a=($(find .. -type f | xargs -I {} du -b {} | sort -n | tail -n $MAX_FILES | sort -n -r))
# echo "${a[@]}"
# echo il primo elemento piu grande è "${a[0]}"
# echo il secondo elemento piu grande è "${a[1]}"

echo "${a[0]}" | cut -f1
printf "%012d\n" "1111111111888888"

exit
for i in ${a[@]}; do
	size=$(echo "$i" | cut -f1)
	percorso=$(echo "$i" | cut -f2)
	nome_soft_link=$(echo $(printf "%012d" $size)-$(basename $percorso))
	ln -s $percorso $nome_soft_link
	# echo $percorso $size $nome_soft_link
done
