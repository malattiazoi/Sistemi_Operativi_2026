`nice` permette di avviare un processo con una priorità diversa rispetto al normale,
in modo che consumi più o meno tempo CPU rispetto agli altri processi.

La “niceness” è un valore da -20 a +19:
- -20 → massima priorità
- 0   → priorità normale (default)
- +19 → minima priorità

Solo root può usare valori negativi (più prioritari).

----------------------------------------------------
Sintassi di base
----------------------------------------------------
nice -n <livello> comando

Esempio: avviare un processo con minore priorità:
nice -n 10 script.sh

Esempio: avviare con maggiore priorità (richiede root):
sudo nice -n -5 esempio.sh

----------------------------------------------------
Verificare la priorità di un processo
----------------------------------------------------
ps -o pid,ni,cmd -p <PID>

oppure
top
(colonna NI mostra la niceness)

----------------------------------------------------
Cambiare la priorità di un processo già in esecuzione
----------------------------------------------------
Non si usa `nice`, ma `renice`:
renice <nuova_priorità> -p <PID>

Esempio:
sudo renice -10 -p 1234

----------------------------------------------------
Casi d'uso
----------------------------------------------------
- rendering video
- compressioni
- script di backup
- elaborazioni scientifiche

Esempio:
nice -n 15 tar -czf backup.tar.gz /home/

----------------------------------------------------
Riepilogo rapido
----------------------------------------------------
| Comando                                     | Significato                                 |
|---------------------------------------------|---------------------------------------------|
| nice comando                                | Avvia con priorità predefinita (0)          |
| nice -n 10 comando                          | Avvia con minore priorità                   |
| sudo nice -n -5 comando                     | Avvia con maggiore priorità                 |
| renice 5 -p 999                             | Cambia priorità processo esistente          |
| ps / top                                    | Vedi livello di niceness                    |

