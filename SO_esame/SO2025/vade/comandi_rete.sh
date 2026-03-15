1) Comando dig
Descrizione:
Esegue query DNS per ottenere informazioni sui record di un dominio (A, CNAME, NS…). Utile per diagnosi DNS.

Comandi ricorrenti:
dig esempio.com                        # Query DNS completa per il dominio
dig +short esempio.com                 # Output ridotto: mostra solo IP
dig @8.8.8.8 esempio.com               # Query usando DNS Google
dig -x 8.8.8.8                         # Reverse lookup da IP a dominio

---------------------------------------------------------

2) Comando arp (legacy)
Descrizione:
Gestisce e mostra la tabella ARP IP↔MAC. Oggi sostituito dal comando ip neigh.

Comandi ricorrenti:
arp -a                                 # Visualizza tabella ARP

---------------------------------------------------------

3) Comando ping
Descrizione:
Verifica raggiungibilità di un host con pacchetti ICMP e misura i tempi di risposta.

Comandi ricorrenti:
ping esempio.com                       # Ping continuo finché interrotto
ping -c 4 esempio.com                  # Solo 4 pacchetti
ping -i 0.5 esempio.com                # Intervallo di 0.5 secondi
ping -s 128 esempio.com                # Payload personalizzato da 128B

---------------------------------------------------------

4) Comando ifconfig (legacy)
Descrizione:
Configura interfacce di rete. Deprecato, sostituito da ip.

Comandi ricorrenti: (macOS)
ifconfig                               # Mostra configurazioni attive
ifconfig eth0 up                       # Attiva interfaccia
ifconfig eth0 down                     # Disattiva interfaccia
ifconfig eth0 192.168.1.10/24          # Imposta indirizzo IP

---------------------------------------------------------

5) Comando ip (moderno, linux)
Descrizione:
Gestione avanzata della rete: interfacce, IP, routing e neighbor.

Comandi ricorrenti:
ip a                                    
ip link show                           # Mostra interfacce
ip link set eth0 up                    # Attiva interfaccia
ip link set eth0 down                  # Disattiva interfaccia
ip addr show                           # Mostra indirizzi assegnati
ip addr add 192.168.1.10/24 dev eth0   # Aggiunge indirizzo IP
ip neigh show                          # Mostra tabella ARP moderna
ip route show                          # Mostra tabella di routing

---------------------------------------------------------

6) Comando traceroute
Descrizione:
Mostra il percorso degli hop verso un host. Utile per problemi di routing.

Comandi ricorrenti:
traceroute esempio.com                 # Percorso standard (UDP)
traceroute -I esempio.com              # Usa ICMP echo
traceroute -n esempio.com              # Mostra solo IP (più rapido)

---------------------------------------------------------

Comandi legacy e sostituti moderni:
ifconfig → ip addr / ip link / ip route
arp → ip neigh

Esempi equivalenti:
ifconfig → ip addr show
ifconfig -a → ip link show
ifconfig eth0 up → ip link set eth0 up
ifconfig eth0 192.168.1.10/24 → ip addr add 192.168.1.10/24 dev eth0
arp -a → ip neigh show
arp -s IP MAC → ip neigh add IP lladdr MAC dev eth0
arp -d IP → ip neigh del IP dev eth0
