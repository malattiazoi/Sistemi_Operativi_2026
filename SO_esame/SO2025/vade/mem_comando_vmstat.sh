# Comandi

1. vmstat -s (vm_stat per macOS)
Il comando `vmstat -s` mostra statistiche cumulative sulla memoria, CPU, swap, I/O e processi del sistema dall’avvio.

2. free
Il comando `free` mostra una fotografia attuale dell’utilizzo della memoria RAM e dello swap: quanto è usato, libero, e quanto è occupato da buffer/cache.


# Spiegazione riga per riga di `vmstat -s`

32365736 K total memory
→ Memoria totale installata

1324756 K used memory
→ RAM attualmente utilizzata dal sistema (non include cache/buffers)

547416 K active memory
→ Memoria attivamente usata dai processi

1042388 K inactive memory
→ Memoria non più attiva ma ancora mantenuta in RAM perché può essere riutilizzata velocemente

30186912 K free memory
→ RAM completamente libera

80456 K buffer memory
→ Memoria usata per buffer del filesystem (scritture su disco)

1217184 K swap cache
→ Dati provenienti dallo swap ma ancora mantenuti in RAM

8388608 K total swap
→ Spazio totale di swap disponibile

0 K used swap
→ Swap attualmente utilizzato

8388608 K free swap
→ Swap libero

54682 non-nice user cpu ticks
→ Tempo CPU per processi utente normali

6896 nice user cpu ticks
→ Tempo CPU per processi utente con priorità ridotta (nice)

278199 system cpu ticks
→ Tempo CPU dedicato al kernel

1948783907 idle cpu ticks
→ Tempo CPU in stato di inattività

134651 IO-wait cpu ticks
→ CPU in attesa di I/O (es. disco)

0 IRQ cpu ticks
→ Tempo speso a gestire interrupt hardware

7600 softirq cpu ticks
→ Tempo speso su interrupt software

0 stolen cpu ticks
→ Tempo CPU sottratto da un hypervisor in caso di virtualizzazione

0 non-nice guest cpu ticks
→ CPU per macchine virtuali guest

0 nice guest cpu ticks
→ CPU per guest con priorità ridotta

8388450 K paged in
→ Dati caricati da disco in RAM

18943412 K paged out
→ Dati spostati da RAM a disco (non swap; parte della gestione caching)

0 pages swapped in
→ Pagine riportate dallo swap in memoria (qui: nessuna)

0 pages swapped out
→ Pagine spostate da RAM verso lo swap (qui: nessuna)

13206607 interrupts
→ Numero totale di interrupt hardware gestiti

79164638 CPU context switches
→ Numero di cambi di contesto tra processi/threads

1762975925 boot time
→ Timestamp del boot del sistema

120075 forks
→ Numero totale di processi creati dall’avvio del sistema


# Spiegazione dell'output di `free`

Colonne:

total
→ RAM totale disponibile

used
→ Memoria effettivamente in uso dai processi

free
→ RAM completamente libera

shared
→ Memoria condivisa tra processi

buff/cache
→ Memoria usata da buffer e cache (liberabile se necessario)

available
→ Memoria che può essere utilizzata da nuovi programmi senza passare allo swap

Swap:
total = spazio swap totale
used = swap in uso
free = swap libero

Nota:
Linux usa molta RAM come cache per migliorare le prestazioni: non è “sprecata”. La RAM viene liberata quando necessaria.
