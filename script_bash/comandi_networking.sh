#!/bin/bash
# ==============================================================================
# SCRIPT DIMOSTRATIVO: COMANDI DI NETWORKING IN BASH
# Prof. F. Tommasi - Corso di Sistemi Operativi
# ==============================================================================
echo "-----------------Comando dig-------------------------------------------"
Descrizione del comando dig:
echo "Il comando 'dig' (Domain Information Groper) viene utilizzato per interrogare
i server DNS per ottenere informazioni sui nomi di dominio e gli indirizzi IP."

dig wikipedia.org # Risoluzione DNS di wikipedia.org
dig +short wikipedia.org # Mostra solo gli indirizzi IP
 dig @8.8.8.8 google.com # Usa il server DNS di Google
dig -x 8.8.8.8 # Risoluzione inversa dell'indirizzo IP
echo "----------------------Comando arp--------------------------------------"
Descrizione del comando arp:
echo "Il comando 'arp' (Address Resolution Protocol) viene utilizzato per visualizzare e
gestire la tabella ARP del sistema, che mappa gli indirizzi IP agli indirizzi MAC
nella rete locale."

arp -n # Mostra la tabella ARP senza risolvere gli indirizzi IP
arp -a # Mostra la tabella ARP
arp -d # Elimina un'entrata ARP
echo "-------------------------Comando ping-----------------------------------"
Descrizione del comando ping:
echo "Il comando 'ping' viene utilizzato per verificare la connettività di rete tra il
sistema locale e un host remoto, inviando pacchetti ICMP Echo Request e attendendo
risposte."

ping -c 4 example.com # Ping di esempio a example.com (4 pacchetti)
ping -i 2 example.com # Ping con intervallo di 2 secondi
ping -s 64 example.com # Ping con dimensione del pacchetto di 64 byte
echo "----------------------------Comando ip----------------------------------------------"
Descrizione del comando ip, NO su macchine MacOS:
echo "Il comando 'ip' viene utilizzato per gestire le interfacce di rete, le tabelle di routing
e altre configurazioni di rete nel sistema operativo Linux."

ip addr show # Mostra tutte le interfacce di rete e i loro indirizzi IP
ip link set eth0 up # Attiva l'interfaccia di rete eth0
ip link set eth0 down # Disattiva l'interfaccia di rete eth0
ip route show # Mostra la tabella di routing
ip route add default via 192.168.1.1 # Aggiunge una rotta predefinita
ip neigh show # Mostra la tabella ARP
ip monitor link # Monitora i cambiamenti delle interfacce di rete
ip -s link # Mostra le statistiche delle interfacce di rete
ip -4 addr show eth0 # Mostra solo gli indirizzi IPv4 dell'interfaccia eth0
ip -6 addr show eth0 # Mostra solo gli indirizzi IPv6 dell'interfaccia eth0
ip addr 192.168.1.100/24 dev eth0 # Aggiunge un indirizzo IP all'interfaccia eth0
echo "----------------------------Comando netstat----------------------------------------------"
Descrizione del comando netstat:
echo "Il comando 'netstat' viene utilizzato per visualizzare le connessioni di rete,
le tabelle di routing e le statistiche delle interfacce di rete."

netstat -tuln # Mostra le porte TCP/UDP in ascolto
netstat -r # Mostra la tabella di routing
netstat -i # Mostra le statistiche delle interfacce di rete
netstat -s # Mostra le statistiche di rete dettagliate
echo "----------------------------Comando ss----------------------------------------------"
Descrizione del comando ss:
echo "Il comando 'ss' (socket statistics) viene utilizzato per visualizzare informazioni
sulle connessioni di rete e le socket aperte nel sistema operativo Linux."

ss -tuln # Mostra le porte TCP/UDP in ascolto
ss -s # Mostra un riepilogo delle statistiche delle socket
ss -r # Mostra la tabella di routing
ss -a # Mostra tutte le socket (aperte e chiuse)
echo "----------------------------Comando traceroute----------------------------------------------"
Descrizione del comando traceroute:
echo "Il comando 'traceroute' viene utilizzato per tracciare il percorso che i pacchetti
di rete seguono per raggiungere un host remoto, mostrando ogni hop intermedio."

traceroute example.com # Traccia il percorso verso example.com
traceroute -m 10 example.com # Limita il numero massimo di hop a 10
traceroute -I example.com # Usa pacchetti ICMP invece di UDP
echo "----------------------------Comando nmap----------------------------------------------"
Descrizione del comando nmap:
echo "Il comando 'nmap' (Network Mapper) viene utilizzato per la scansione delle reti,
l'individuazione degli host e l'analisi delle porte aperte sui sistemi remoti."

nmap example.com # Scansione di base di example.com
nmap -sS example.com # Scansione stealth SYN
nmap -O example.com # Rilevamento del sistema operativo
nmap -p 1-1000 example.com # Scansione delle porte da 1 a 1000
echo "----------------------------Comando ifconfig----------------------------------------------"
Descrizione del comando ifconfig ,sostituito da ip in molte distribuzioni moderne:
echo "Il comando 'ifconfig' (interface configuration) viene utilizzato per configurare
le interfacce di rete nel sistema operativo Linux."

ifconfig # Mostra tutte le interfacce di rete e le loro configurazioni
ifconfig eth0 up # Attiva l'interfaccia di rete eth0
ifconfig eth0 down # Disattiva l'interfaccia di rete eth0
ifconfig eth0 # Mostra le informazioni sull'interfaccia di rete eth0