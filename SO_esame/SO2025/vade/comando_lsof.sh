Comando: lsof
Descrizione:
  lsof (List Open Files) mostra tutti i file aperti dai processi nel sistema.
  In Unix/Linux *tutto è un file*: file su disco, directory, socket, pipe,
  device, connessioni di rete, librerie, ecc.
  È utile per diagnosticare problemi, capire quali processi usano un file,
  verificare porte occupate, trovare file cancellati ma ancora "in uso".

Utilizzo base:
  lsof [opzioni]

Esempi utili:

1. Mostrare TUTTI i file aperti
  lsof

2. Mostrare i file aperti da un certo processo (es: pid 1234)
  lsof -p 1234

3. Mostrare i file aperti da un certo utente (es: 'mario')
  lsof -u mario

4. Vedere quale processo usa una porta TCP (es: 8080)
  lsof -i :8080

5. Mostrare tutte le connessioni di rete aperte
  lsof -i

6. Mostrare file aperti in una directory specifica (es: /var/log)
  lsof +D /var/log

7. Vedere quale processo sta usando un particolare file
  lsof /path/del/file

8. Filtrare per tipo di connessione (es: TCP)
  lsof -iTCP

Note:
  - Serve spesso essere root per vedere TUTTI i processi.
