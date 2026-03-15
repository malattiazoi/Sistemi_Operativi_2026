#espanine di default e condizionale
read -p "inserisci il tuo nome (default: unknown name): " User
read -p "inserisci la tua città (default: unknown city): " City
nome=${User:-"unknown name"} #se User non esiste, nome vale unknown name
citta=${City:-"unknown city"} #se City non esiste, citta vale unknown city
echo "Ciao, $nome di $citta!"