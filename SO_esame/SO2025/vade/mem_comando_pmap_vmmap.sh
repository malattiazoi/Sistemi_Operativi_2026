
achz25@DESKTOP-L8GIS7I:/mnt/c/Users/Andrea11$ pmap -X 47173
47173:   -bash
     Address Perm   Offset Device Inode  Size  Rss  Pss Referenced Anonymous LazyFree ShmemPmdMapped FilePmdMapped Shared_Hugetlb Private_Hugetlb Swap SwapPss Locked THPeligible Mapping
55be32b3e000 r--p 00000000  08:20  1462   192  184   10        184         0        0              0             0              0               0    0       0      0           0 bash
55be32b6e000 r-xp 00030000  08:20  1462   956  956   56        956         0        0              0             0              0               0    0       0      0           0 bash
55be32c5d000 r--p 0011f000  08:20  1462   212  120    7        120         0        0              0             0              0               0    0       0      0           0 bash
55be32c92000 r--p 00154000  08:20  1462    16   16   16          4        16        0              0             0              0               0    0       0      0           0 bash
55be32c96000 rw-p 00158000  08:20  1462    36   36   36         16        36        0              0             0              0               0    0       0      0           0 bash
55be32c9f000 rw-p 00000000  00:00     0    44   32   32         28        32        0              0             0              0               0    0       0      0           0
55be57cf6000 rw-p 00000000  00:00     0  5468 5444 5444       4128      5444        0              0             0              0               0    0       0      0           1 [heap]
7f914bb9d000 r--p 00000000  08:20 44120   356  124    4        124         0        0              0             0              0               0    0       0      0           0 LC_CTYPE
7f914bbf6000 r--p 00000000  08:20 44135     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_NUMERIC
7f914bbf7000 r--p 00000000  08:20 44538     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_TIME
7f914bbf8000 r--p 00000000  08:20   742  2988   32    0         32         0        0              0             0              0               0    0       0      0           0 locale-archive
7f914bee3000 rw-p 00000000  00:00     0    12    8    8          8         8        0              0             0              0               0    0       0      0           0
7f914bee6000 r--p 00000000  08:20 44483   160  156    2        156         0        0              0             0              0               0    0       0      0           0 libc.so.6
7f914bf0e000 r-xp 00028000  08:20 44483  1568 1416   24       1416         0        0              0             0              0               0    0       0      0           0 libc.so.6
7f914c096000 r--p 001b0000  08:20 44483   316  164    2        164         0        0              0             0              0               0    0       0      0           0 libc.so.6
7f914c0e5000 r--p 001fe000  08:20 44483    16   16   16          4        16        0              0             0              0               0    0       0      0           0 libc.so.6
7f914c0e9000 rw-p 00202000  08:20 44483     8    8    8          8         8        0              0             0              0               0    0       0      0           0 libc.so.6
7f914c0eb000 rw-p 00000000  00:00     0    52   24   24         12        24        0              0             0              0               0    0       0      0           0
7f914c0f8000 r--p 00000000  08:20 13012    56   56    2         56         0        0              0             0              0               0    0       0      0           0 libtinfo.so.6.4
7f914c106000 r-xp 0000e000  08:20 13012    76   72    3         72         0        0              0             0              0               0    0       0      0           0 libtinfo.so.6.4
7f914c119000 r--p 00021000  08:20 13012    56   56    3         56         0        0              0             0              0               0    0       0      0           0 libtinfo.so.6.4
7f914c127000 r--p 0002e000  08:20 13012    16   16   16          4        16        0              0             0              0               0    0       0      0           0 libtinfo.so.6.4
7f914c12b000 rw-p 00032000  08:20 13012     4    4    4          4         4        0              0             0              0               0    0       0      0           0 libtinfo.so.6.4
7f914c12c000 r--p 00000000  08:20 44119     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_COLLATE
7f914c12d000 r--p 00000000  08:20 44133     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_MONETARY
7f914c12e000 r--p 00000000  08:20 44132     4    4    0          4         0        0              0             0              0               0    0       0      0           0 SYS_LC_MESSAGES
7f914c12f000 r--p 00000000  08:20 44265     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_PAPER
7f914c130000 r--p 00000000  08:20 44134     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_NAME
7f914c131000 r--p 00000000  08:20 12067     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_ADDRESS
7f914c132000 r--p 00000000  08:20 44536     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_TELEPHONE
7f914c133000 r--p 00000000  08:20 44123     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_MEASUREMENT
7f914c134000 r--s 00000000  08:20 44459    28   28    0         28         0        0              0             0              0               0    0       0      0           0 gconv-modules.cache
7f914c13b000 r--p 00000000  08:20 44122     4    4    0          4         0        0              0             0              0               0    0       0      0           0 LC_IDENTIFICATION
7f914c13c000 rw-p 00000000  00:00     0     8    8    8          0         8        0              0             0              0               0    0       0      0           0
7f914c13e000 r--p 00000000  08:20 44477     4    4    0          4         0        0              0             0              0               0    0       0      0           0 ld-linux-x86-64.so.2
7f914c13f000 r-xp 00001000  08:20 44477   172  172    2        172         0        0              0             0              0               0    0       0      0           0 ld-linux-x86-64.so.2
7f914c16a000 r--p 0002c000  08:20 44477    40   40    0         40         0        0              0             0              0               0    0       0      0           0 ld-linux-x86-64.so.2
7f914c174000 r--p 00036000  08:20 44477     8    8    8          0         8        0              0             0              0               0    0       0      0           0 ld-linux-x86-64.so.2
7f914c176000 rw-p 00038000  08:20 44477     8    8    8          4         8        0              0             0              0               0    0       0      0           0 ld-linux-x86-64.so.2
7fff4d25b000 rw-p 00000000  00:00     0   132  108  108         16       108        0              0             0              0               0    0       0      0           0 [stack]
7fff4d3bd000 r--p 00000000  00:00     0    16    0    0          0         0        0              0             0              0               0    0       0      0           0 [vvar]
7fff4d3c1000 r-xp 00000000  00:00     0     8    4    0          4         0        0              0             0              0               0    0       0      0           0 [vdso]
                                        ===== ==== ==== ========== ========= ======== ============== ============= ============== =============== ==== ======= ====== ===========
                                        13076 9364 5851       7864      5736        0              0             0              0               0    0       0      0           1 KB

# Comando e spiegazione output

pmap -X 47173 (vmmap 47173 per macOS)

Il comando `pmap` mostra la mappa della memoria virtuale di un processo.
L’opzione `-X` fornisce informazioni estese su ogni area di memoria: dimensione, uso reale (RSS), pagine condivise e private, swap, mapping del file ecc.

Significato delle colonne principali:
- Address → Indirizzo di memoria della sezione
- Perm → Permessi (r = read, w = write, x = execute, p = private)
- Offset → Offset della sezione nel file
- Device / Inode → File system e inode associati, se esiste un file mappato
- Size → Dimensione dell’area di memoria virtuale
- Rss → Resident Set Size: memoria fisica realmente utilizzata
- Pss → Proportional Set Size: memoria fisica attribuita al processo pesata sulle parti condivise
- Referenced → Pagine effettivamente referenziate
- Anonymous → Memoria senza un file backing, tipicamente heap/stack
- LazyFree → Pagine che possono essere rimosse senza scrittura su swap
- Mapping → Nome del file, oppure [heap], [stack], ecc.

Note:
- `bash` ha aree differenti per codice eseguibile, dati, segmenti read-only ecc.
- La heap è (in questo caso) una porzione significativa della memoria privata:
  → `[heap]`, con Rss 5444 KB
- Ci sono molte librerie condivise (`libc.so`, `libtinfo.so`, `ld-linux-x86-64.so.2`)
- Are open file maps per le impostazioni di localizzazione (`LC_*`)
- Stack e sezioni di sistema come `[vdso]` e `[vvar]`

In fondo è riportato il totale della memoria allocata:
  Size 13076 KB | RSS 9364 KB | PSS 5851 KB | ecc.


|   Metrica                       |   Definizione                                                                     |   Perché il PSS è superiore                                                                     |
| ------------------------------- | --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
|   VSS (Virtual Set Size)        | Memoria totale accessibile (include memoria che non è realmente caricata in RAM). | Sovrastima enormemente; non utile per capire l’effettiva occupazione della RAM.                 |
|   RSS (Resident Set Size)       | Tutta la memoria fisica attualmente in RAM (privata + condivisa).                 | Sovrastima la memoria condivisa; la somma di tutti gli RSS può superare la RAM fisica totale.   |
|   USS (Unique Set Size)         | Solo le pagine di memoria private, non condivise.                                 | Sottostima l’impatto reale, ignorando le librerie condivise necessarie.                         |
|   PSS (Proportional Set Size)   | Memoria privata più una quota proporzionale della memoria condivisa.              |   Metrica più accurata   per valutare il reale impatto di un processo sulla memoria di sistema. |


achz25@DESKTOP-L8GIS7I:/mnt/c/Users/Andrea11$ cat /proc/47173/maps
55be32b3e000-55be32b6e000 r--p 00000000 08:20 1462                       /usr/bin/bash
55be32b6e000-55be32c5d000 r-xp 00030000 08:20 1462                       /usr/bin/bash
55be32c5d000-55be32c92000 r--p 0011f000 08:20 1462                       /usr/bin/bash
55be32c92000-55be32c96000 r--p 00154000 08:20 1462                       /usr/bin/bash
55be32c96000-55be32c9f000 rw-p 00158000 08:20 1462                       /usr/bin/bash
55be32c9f000-55be32caa000 rw-p 00000000 00:00 0
55be57cf6000-55be5824d000 rw-p 00000000 00:00 0                          [heap]
7f914bb9d000-7f914bbf6000 r--p 00000000 08:20 44120                      /usr/lib/locale/C.utf8/LC_CTYPE
7f914bbf6000-7f914bbf7000 r--p 00000000 08:20 44135                      /usr/lib/locale/C.utf8/LC_NUMERIC
7f914bbf7000-7f914bbf8000 r--p 00000000 08:20 44538                      /usr/lib/locale/C.utf8/LC_TIME
7f914bbf8000-7f914bee3000 r--p 00000000 08:20 742                        /usr/lib/locale/locale-archive
7f914bee3000-7f914bee6000 rw-p 00000000 00:00 0
7f914bee6000-7f914bf0e000 r--p 00000000 08:20 44483                      /usr/lib/x86_64-linux-gnu/libc.so.6
7f914bf0e000-7f914c096000 r-xp 00028000 08:20 44483                      /usr/lib/x86_64-linux-gnu/libc.so.6
7f914c096000-7f914c0e5000 r--p 001b0000 08:20 44483                      /usr/lib/x86_64-linux-gnu/libc.so.6
7f914c0e5000-7f914c0e9000 r--p 001fe000 08:20 44483                      /usr/lib/x86_64-linux-gnu/libc.so.6
7f914c0e9000-7f914c0eb000 rw-p 00202000 08:20 44483                      /usr/lib/x86_64-linux-gnu/libc.so.6
7f914c0eb000-7f914c0f8000 rw-p 00000000 00:00 0
7f914c0f8000-7f914c106000 r--p 00000000 08:20 13012                      /usr/lib/x86_64-linux-gnu/libtinfo.so.6.4
7f914c106000-7f914c119000 r-xp 0000e000 08:20 13012                      /usr/lib/x86_64-linux-gnu/libtinfo.so.6.4
7f914c119000-7f914c127000 r--p 00021000 08:20 13012                      /usr/lib/x86_64-linux-gnu/libtinfo.so.6.4
7f914c127000-7f914c12b000 r--p 0002e000 08:20 13012                      /usr/lib/x86_64-linux-gnu/libtinfo.so.6.4
7f914c12b000-7f914c12c000 rw-p 00032000 08:20 13012                      /usr/lib/x86_64-linux-gnu/libtinfo.so.6.4
7f914c12c000-7f914c12d000 r--p 00000000 08:20 44119                      /usr/lib/locale/C.utf8/LC_COLLATE
7f914c12d000-7f914c12e000 r--p 00000000 08:20 44133                      /usr/lib/locale/C.utf8/LC_MONETARY
7f914c12e000-7f914c12f000 r--p 00000000 08:20 44132                      /usr/lib/locale/C.utf8/LC_MESSAGES/SYS_LC_MESSAGES
7f914c12f000-7f914c130000 r--p 00000000 08:20 44265                      /usr/lib/locale/C.utf8/LC_PAPER
7f914c130000-7f914c131000 r--p 00000000 08:20 44134                      /usr/lib/locale/C.utf8/LC_NAME
7f914c131000-7f914c132000 r--p 00000000 08:20 12067                      /usr/lib/locale/C.utf8/LC_ADDRESS
7f914c132000-7f914c133000 r--p 00000000 08:20 44536                      /usr/lib/locale/C.utf8/LC_TELEPHONE
7f914c133000-7f914c134000 r--p 00000000 08:20 44123                      /usr/lib/locale/C.utf8/LC_MEASUREMENT
7f914c134000-7f914c13b000 r--s 00000000 08:20 44459                      /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
7f914c13b000-7f914c13c000 r--p 00000000 08:20 44122                      /usr/lib/locale/C.utf8/LC_IDENTIFICATION
7f914c13c000-7f914c13e000 rw-p 00000000 00:00 0
7f914c13e000-7f914c13f000 r--p 00000000 08:20 44477                      /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
7f914c13f000-7f914c16a000 r-xp 00001000 08:20 44477                      /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
7f914c16a000-7f914c174000 r--p 0002c000 08:20 44477                      /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
7f914c174000-7f914c176000 r--p 00036000 08:20 44477                      /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
7f914c176000-7f914c178000 rw-p 00038000 08:20 44477                      /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
7fff4d25b000-7fff4d27c000 rw-p 00000000 00:00 0                          [stack]
7fff4d3bd000-7fff4d3c1000 r--p 00000000 00:00 0                          [vvar]
7fff4d3c1000-7fff4d3c3000 r-xp 00000000 00:00 0                          [vdso]
achz25@DESKTOP-L8GIS7I:/mnt/c/Users/Andrea11$

# Comando e spiegazione output

cat /proc/47173/maps

Questo comando mostra la mappa di memoria del processo in modo “testuale essenziale”.
È la fonte da cui `pmap` estrae i dati.

Contiene:
- Range di indirizzi di memoria virtuale
- Permessi dell’area
- Offset nel file/oggetto mappato
- Device e inode
- File o oggetto associato (o [heap], [stack], [vdso]…)

Significato dei permessi:
- r → read
- w → write
- x → execute
- p → private (copy-on-write)
- s → shared (molto comune per librerie condivise)

Esempi rapidi:
- `/usr/bin/bash` → segmenti del binario eseguibile: codice, dati, BSS…
- `rw-p ... 00:00 0` → memoria anonima: tipicamente heap o allocazioni via malloc()
- `[heap]` → memoria dinamica del processo
- librerie in `/usr/lib/...` → condivise tra processi
- `[stack]` → stack del thread principale
- `[vdso]` and `[vvar]` → (virtual dynamic shared object) e (virtual variables) strutture del kernel mappate nello spazio utente

Differenze tra `pmap -X` e `/proc/pid/maps`:
- `maps` = contiene solo struttura e permessi della memoria
- `pmap -X` = aggiunge statistica sull’uso fisico della memoria

- `/proc/maps` dice cosa è mappato e dove
- `pmap -X` dice quanto costa realmente in RAM
