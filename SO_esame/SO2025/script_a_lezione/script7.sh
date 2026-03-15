# stampa_nome() {
#     echo "Nome: $1"
#     echo "Cognome: $2"
# }

# stampa_nome luca catanzaro
# stampa_nome $1 $2

verifica_file() {
    [ -f "$1" ] && echo 0 || echo 1
    return 
}

verifica_file "./tkuriufoufovo.txt"

echo il dollaro interrogativo dà: $?
