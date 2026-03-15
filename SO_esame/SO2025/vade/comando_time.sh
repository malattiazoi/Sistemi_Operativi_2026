Il comando `time` serve per misurare quanto tempo impiega un comando a essere eseguito.  
Mostra tre valori fondamentali:

real    0m3.215s
user    0m1.002s
sys     0m0.123s

-----------------------------------------
real
- Tempo reale totale (“wall-clock time”)
- Tempo effettivo trascorso dal momento in cui il comando parte a quando termina
- Include tutto: CPU, attese I/O, attese di rete, sospensioni
- È ciò che percepisce l’utente

Esempio: se un programma impiega 5 secondi di orologio, real = 0m5.000s

-----------------------------------------
user
- Tempo CPU in modalità utente
- È il tempo in cui la CPU esegue il codice del programma stesso
- Alto se il programma fa molti calcoli

-----------------------------------------
sys
- Tempo CPU in modalità kernel (sistema operativo)
- Include operazioni come accesso a file, allocazione di memoria, I/O
- Alto se il programma fa molte operazioni di sistema

-----------------------------------------
In sintesi:

real: Tempo “da orologio”, Tutto (CPU + attese + I/O + sleep)
user: Tempo CPU in modalità utente, Calcoli del programma
sys: Tempo CPU in modalità kernel, Operazioni di sistema

-----------------------------------------
Esempio

$ time ls -R /usr > /dev/null

real    0m0.987s
user    0m0.432s
sys     0m0.550s

- Il comando ha impiegato 0,987 secondi reali
- Ha consumato 0,432s di CPU in user mode e 0,550s in system mode
- Se il computer ha più CPU core, user + sys può superare real
