#CLI command line interface script

#esempio pratico
while [ $# -gt o ]; do
    case "$1" in
        -f|--file
            file="$2"
            echo "File specificato: $file"
            shift 2
            ;;
        -v|--verbose
            echo "Modalità verbose attivata"
            shift
            ;;
        *)
            echo "Opzione sconosciuta: $1"
            shift
            ;;
    esac
done

#case è usato per gestire le opzioni della riga di comando
#shift è usato per spostare gli argomenti in modo da poter processare

#getopts è un'altra opzione per gestire le opzioni della riga di comando
#getopts è una utility built‑in di bash per parsare opzioni “short” 
#(es. -v, -f file) in modo semplice e robusto dentro uno script.
while getopts "vf:" opt; do
    case $opt in
        v)
            verbose=1
            echo "Modalità verbose attivata (getopts)"
            ;;
        f)
            echo "File specificato (getopts): $OPTARG"
            ;;
        \?)
            echo "uso: $0 [-v] [-f filename]"
            exit 1
            ;;
        *)
            echo "Opzione sconosciuta (getopts): $opt"
            ;;
    esac
done
#getopts è più semplice per opzioni singole con argomenti opzionali
#ma case/shift è più flessibile per opzioni complesse
#verbose=1 indica che la modalità verbose è attivata
#filename=$OPTARG contiene l'argomento passato con -f
#\?) gestisce opzioni sconosciute
#*) gestisce casi imprevisti


#per utilizzare argomenti inseriti di seguito alle opzioni,
#è necessario usare shift $((OPTIND - 1))
shift $((OPTIND - 1))  # ora $1... sono gli argomenti non-opzione