Directory /proc in Linux:
È un file system virtuale che mostra informazioni sul kernel e sui processi
in tempo reale (non contiene file “veri”).

File principali in /proc (informazioni di sistema):

/proc/cpuinfo
    Dettagli sulla CPU: modello, core, frequenza, cache...

/proc/meminfo
    Informazioni sulla memoria RAM: totale, libera, buffer, swap... (simile a al comando vmstat)

/proc/version
    Versione del kernel Linux in esecuzione

/proc/uptime
    Tempo di attività del sistema e tempo trascorso in idle (il tempo trascorso in idle è moltiplicato per il numero dei core)

/proc/loadavg
    Carico medio del sistema (1, 5 e 15 minuti)
    Se hai 1 CPU:
    1.00 = CPU completamente occupata

    < 1.00 = CPU non completamente utilizzata

    > 1.00 = troppi processi → la CPU non riesce a stare al passo

    Su sistemi multi-core si divide per il numero di CPU
    (es. su 4 core 4.00 = 100% utilizzo)

/proc/partitions
    Partizioni dei dischi rilevate dal kernel

/proc/filesystems
    Filesystem supportati dal kernel


-------------------------------------------------------------------

Directory /proc/PID (informazioni su un processo specifico):
Ogni processo ha una directory con il suo PID, ad esempio /proc/1234

File principali:

/proc/PID/cmdline
    Comando e parametri con cui è stato avviato il processo

/proc/PID/status
    Stato del processo, memoria usata, UID, GID, thread...

/proc/PID/exe
    Link all’eseguibile del processo

/proc/PID/environ
    Variabili d’ambiente del processo

/proc/PID/cwd
    Directory corrente del processo (link simbolico)

/proc/PID/fd/
    File descriptors aperti dal processo (socket, pipe, file...)

0 stdin
1 stdout
2 stderr
+ eventuali altri FD per risorse aperte

/proc/PID/maps
    Mappa della memoria del processo (librerie, stack, heap)

/proc/PID/stat
    Statistiche dettagliate e numeriche sul processo
| Campo | Nome      | Descrizione                                   |
| ----- | --------- | --------------------------------------------- |
| 1     | PID       | ID del processo                               |
| 2     | comm      | Nome dell’eseguibile racchiuso tra parentesi  |
| 3     | state     | Stato del processo (`R`, `S`, `D`, `Z`, ecc.) |
| 4     | ppid      | PID del processo padre                        |
| 5     | pgrp      | ID del gruppo di processi                     |
| 7     | tty_nr    | Terminale associato                           |
| 14    | utime     | Tempo CPU in *user mode*                      |
| 15    | stime     | Tempo CPU in *kernel mode*                    |
| 18    | priority  | Priorità interna del kernel                   |
| 19    | nice      | Valore nice del processo                      |
| 22    | starttime | Tick dal boot in cui è partito                |
| 23    | vsize     | Memoria virtuale usata (in byte)              |
| 24    | rss       | Resident Set Size: memoria fisica usata       |
(R=running, S=sleeping, D=disk-sleep, Z=zombie, T=stopped, t=tracing-stop, W=paging, X=dead, x=dead, K=wakekill, P=parked)


/proc/PID/smaps
    Analisi dettagliata per ogni mappatura di memoria.
    Include per ogni area:

        Size             Memoria virtuale mappata
        Rss              Pagine realmente in RAM
        Pss              Quota di RSS attribuita al processo (shared proporzionale)
        Shared_Clean     Pagine condivise non modificate
        Shared_Dirty     Pagine condivise modificate
        Private_Clean    Pagine private non modificate
        Private_Dirty    Pagine private modificate (rischio swap)
        Referenced       Pagine usate recentemente
        Anonymous        Memoria non legata a file (heap/stack)
        LazyFree         Pagine liberabili senza swap
        Swap             Pagine finite su swap
        SwapPss          Swap proporzionale se condivisa
        VmFlags          Flag avanzati (COW, hugepages, stack, shared...)

    Utile per:
        - capire memoria privata vs condivisa
        - vedere rischio di swap
        - rilevare memory leak
        - analizzare COW dopo fork




/proc/PID/task/
    Thread del processo (ogni thread = una sottodirectory)


-------------------------------------------------------------------

In breve:
/proc mostra lo stato del sistema e dei processi in tempo reale tramite
file virtuali utili per amministrazione, debugging e monitoraggio.
