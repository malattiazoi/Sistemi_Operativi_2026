`ulimit` controlla le risorse di sistema che un processo della shell può usare.
Serve a prevenire che un processo consumi tutta la memoria, i file aperti, ecc.

I limiti possono essere:
- soft → modificabili dall’utente
- hard → limite massimo impostabile (solo root può aumentarli)

----------------------------------------------------
Sintassi
----------------------------------------------------
ulimit [opzioni] [valore]

Mostrare tutti i limiti correnti:
ulimit -a

----------------------------------------------------
Le opzioni principali
----------------------------------------------------
| Opzione | Risorsa                                   |
|---------|-------------------------------------------|
| -c      | dimensione dei core dump                  |
| -d      | dimensione massima del segmento dati      |
| -f      | max dimensione file creati                |
| -l      | max memoria bloccata in RAM               |
| -m      | max memoria resident set                  |
| -n      | max file descriptors aperti               |
| -p      | dimensione pipe                           |
| -q      | max queue dei messaggi                    |
| -s      | stack size                                |
| -t      | tempo CPU                                 |
| -u      | max processi per utente                   |
| -v      | virtual memory                            |

----------------------------------------------------
Esempi pratici
----------------------------------------------------
Mostrare limite dei file aperti:
ulimit -n

Impostare limite file aperti a 4096:
ulimit -n 4096

Limitare dimensione massima file a 10 MB:
ulimit -f 10240   # (KB)

Impostare memoria virtuale massima a 1GB:
ulimit -v 1048576   # (KB)

----------------------------------------------------
Hard limit
----------------------------------------------------
Mostrare:
ulimit -H -a

Impostare (richiede root per aumentare):
ulimit -H -n 65535

----------------------------------------------------
Applicazione permanente (Linux)
----------------------------------------------------
Modificare il file:
sudo nano /etc/security/limits.conf

E aggiungere:
username soft nofile 4096
username hard nofile 65535

----------------------------------------------------
Quando è utile?
----------------------------------------------------
Server (web, DB) → aumentare file aperti  
Prevenire crash → limitare memoria/CPU  
Debug → abilitare core dump

----------------------------------------------------
Riepilogo rapido
----------------------------------------------------
| Comando            | Significato                             |
|-------------------|----------------------------------------- |
| ulimit -a          | Mostra tutti i limiti                   |
| ulimit -n 4096     | Cambia limite file aperti               |
| ulimit -H -a       | Mostra hard limit                       |
| ulimit -v 1048576  | Limita memoria virtuale                 |

FINE
