# Netcat — cheat sheet (versione corretta e migliorata)

Descrizione:
Netcat (nc) è uno strumento versatile per aprire socket TCP/UDP, trasferire dati e fare debugging di rete. Utile per chat rapide, trasferimenti in LAN, test di porte e piping tra macchine. NON fornisce cifratura né autenticazione: per dati sensibili usare SSH/scp/rsync-over-ssh o canali cifrati (es. OpenSSL).

Comandi utili (esempi):
- Ascoltare TCP (generic):          nc -l -p 1234    # oppure: nc -l 1234 (varia per implementazione)
- Connettersi via TCP:             nc <host> 1234
- Ascoltare UDP:                   nc -u -l -p 1234  # o: nc -ul 1234 su alcune versioni
- Inviare UDP (broadcast/host):    echo "msg" | nc -u <broadcast_or_host> 1234
- Scan porte semplice (TCP):       nc -zv host 20-1024

--------------------
Trasferimento file — sezione corretta e migliorata

Nota: le opzioni variano tra implementazioni (OpenBSD nc, GNU netcat, ncat). Esempi comuni:

1) Metodo base (TCP) — trasferimento file singolo
- Mittente (ascolta e invia):
  nc -l 9000 < file.bin
  # Se la tua versione richiede -p:
  nc -l -p 9000 < file.bin
  # Chiudere automaticamente dopo EOF (se supportato):
  nc -l -p 9000 -q 1 < file.bin

- Destinatario (si connette e riceve):
  nc mittente_ip 9000 > file-ricevuto.bin

2) Metodo invertito — destinatario ascolta, mittente si connette
- Destinatario (ascolta e salva):
  nc -l 9000 > file.bin
- Mittente (si connette e invia):
  nc destinatario_ip 9000 < file.bin

3) Progresso e integrità
- Visualizzare progresso con pv:
  pv file.bin | nc -l 9000
  nc mittente_ip 9000 > file.bin
- Verificare checksum:
  sha256sum file.bin   # prima sul mittente e dopo sul ricevente

4) Trasferire directory o più file (tar)
- Mittente:
  tar -cf - somedir | nc -l 9000
- Ricevente:
  nc mittente_ip 9000 | tar -xf -

Con pv (progresso):
  tar -cf - somedir | pv | nc -l 9000

5) Binding a indirizzo specifico (evita ascolto su tutte le interfacce)
  nc -l 192.168.1.10 9000 < file.bin

6) Raccomandazioni per chiusura connessione
- Se nc non chiude automaticamente, usare l'opzione -q se disponibile:
  nc -l -p 9000 -q 1 < file.bin

7) Sicurezza e alternative
- Netcat NON cifra. Per cifrare, incapsulare con OpenSSL o usare scp/rsync-over-ssh.
- Esempio (concetto): openssl s_client / s_server per tunnel TLS (configurare certificati correttamente).
- Per produzione o trasferimenti su Internet usare strumenti autenticati e cifrati (scp, rsync -e ssh).

--------------------
Note:
- Netcat non offre autenticazione né cifratura: NON inviare dati sensibili su reti non affidabili.
- Comandi e opzioni variano tra implementazioni: se un comando non funziona, provare alternative (-l 1234 vs -l -p 1234) o usare ncat / OpenBSD nc.
- Porte <1024 richiedono privilegi root.
- Controllare firewall e SELinux; limitare esposizione legando l'ascolto a un indirizzo specifico.
- Evitare di esporre `nc -l` su interfacce pubbliche senza firewall.

--------------------

