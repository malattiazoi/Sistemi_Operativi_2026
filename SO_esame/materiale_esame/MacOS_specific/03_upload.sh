# Mattia Lazoi 20098934

# Variabili iniziali
DIR="mattia.lazoi.esame191a"
IP="10.0.14.23"
USER_LINUX="mlazoi"

# Creo directory d'esame
mkdir -p ~/"$DIR"
cd ~/"$DIR"

# Creo leggimi.txt
cat <<EOF > leggimi.txt
Mattia Lazoi 20098934
Script sviluppati su macOS.
Utilizzato standard POSIX per compatibilità Linux.
EOF

# Copio la traccia (se presente in Downloads)
cp ~/Downloads/esame191a.txt . 2>/dev/null

# Torno alla home e trasferisco la cartella su Linux
cd ..
scp -r "$DIR" "${USER_LINUX}@${IP}:~/"

# Comando finale da dare su terminale Linux:
# cd; tar cvfz $USER.esame191a.tgz $USER.esame191a