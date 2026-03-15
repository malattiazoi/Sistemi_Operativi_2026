# Scrivere uno script Bash che prenda in input due file e confronti il numero di righe contenute in ciascuno.
# Se i due file hanno lo stesso numero di righe, lo script deve stampare il messaggio "I file hanno lo stesso numero di righe" riportando anche il numero di righe presenti.
# Altrimenti, deve stampare la differenza tra il numero di righe dei due file e quante righe hanno i due file rispettivamente.
# Nota: si usino almeno due command substitutions nello script.

read -p "Inserisci il nome del primo file: " file1
read -p "Inserisci il nome del secondo file: " file2
righe_file1=$(wc -l < "$file1")
righe_file2=$(wc -l < "$file2")
if [ "$righe_file1" -eq "$righe_file2" ]; then
    echo "I file hanno lo stesso numero di righe: $righe_file1"
else
    differenza=$(( righe_file1 - righe_file2 ))
    echo "I file hanno un numero diverso di righe."
    echo "Differenza: ${differenza#-} righe" # "#-" rimuove il segno meno se presente
    echo "Righe in $file1: $righe_file1"
    echo "Righe in $file2: $righe_file2"
fi
# Differenza viene messa fra parentesi grffe perché usata in un contesto aritmetico.