#stringhe e manipolazioni
var="la bibbia!?"
echo "${#var}" #lunghezza della stringa
echo "${var:2}" #estraggo caratteri da posizione 2 in poi
echo "${var:2:5}" #estraggo 5 caratteri da posizione
echo "&{var,,}" #tutto minuscolo
echo "${var^^}" #tutto maiuscolo
echo "${var^}" #prima lettera maiuscola
echo "${var,,[aeiou]}" #tutte le vocali minuscole
echo "${var^^[aeiou]}" #tutte le vocali maiuscole
echo "${var/a/A}" #sostituisco la prima a con A
echo "${var//a/A}" #sostituisco tutte le a con A
echo "${var/#la/IL}" #sostituisco la prima occorrenza di "la" con "IL"
echo "${var/%!?/.}" #sostituisco l'ultima occorrenza di "!" con "."
echo "${var/la/}" #rimuovo la prima occorrenza di "la"
echo "${var//la/}" #rimuovo tutte le occorrenze di "la"
echo "${var#* }" #rimuovo tutto fino al primo spazio
echo "${var##* }" #rimuovo tutto fino all'ultimo spazio
echo "${var% *}" #rimuovo tutto dopo l'ultimo spazio
echo "${var%% *}" #rimuovo tutto dopo il primo spazio
echo "$(echo $var | rev)" #inverto la stringa
echo "$(echo $var | cut -d' ' -f2)" #estraggo la seconda parola
echo "$(echo $var | tr 'a-z' 'A-Z')" #tutto maiuscolo con tr
echo "$(echo $var | tr 'A-Z' 'a-z')" #tutto minuscolo con tr
echo "$(echo $var | tr -d '[:punct:]')" #rimuovo la punteggiatura
echo "$(echo $var | tr -d '[:space:]')" #rimuovo gli spazi
echo "$(echo $var | awk '{print toupper($0)}')" #tutto maiuscolo con awk
echo "$(echo $var | awk '{print tolower($0)}')" #tutto minuscolo con awk
echo "$(echo $var | awk '{print length($0)}')" #lunghezza con awk
echo "$(echo $var | awk '{print substr($0,3,5)}')" #estraggo 5 caratteri da posizione 3 con awk
echo "$(echo $var | sed 's/a/A/')" #sostituisco la prima a con A con sed
echo "$(echo $var | sed 's/a/A/g')" #sostituisco tutte le a con A con sed
echo "$(echo $var | sed 's/^la/IL/')" #sostituisco la prima occorrenza di "la" con "IL" con sed
echo "$(echo $var | sed 's/!$/./')" #sostituisco l'ultima occorrenza di "!" con "." con sed
echo "$(echo $var | sed 's/la//')" #rimuovo la prima occorrenza di "la" con sed
echo "$(echo $var | sed 's/la//g')" #rimuovo tutte le occorrenze di "la con sed
echo "$(echo $var | sed 's/.* //')" #rimuovo tutto fino al primo spazio con sed
echo "$(echo $var | sed 's/.* //g')" #rimuovo tutto fino all'ultimo spazio con sed
echo "$(echo $var | sed 's/ .*//')" #rimuovo tutto dopo l'ultimo spazio con sed
echo "$(echo $var | sed 's/ .*//g')" #rimuovo tutto dopo il primo spazio con sed
echo "$(echo $var | sed 's/ //g')" #rimuovo tutti gli spazi con sed
echo "$(echo $var | sed 's/[[:punct:]]//g')" #rimuovo tutta la punteggiatura con sed