COMANDO: du (disk usage)
---------------------------------
DESCRIZIONE:
"du" mostra lo spazio su disco occupato da file e directory.
Di default riporta la dimensione di ogni sottodirectory in blocchi.

OPZIONI NOTE:
  -h        mostra dimensioni leggibili (KB, MB, GB)
  -s        riepilogo: mostra solo il totale
  -a        include anche i file, non solo le directory
  -d N      profondità massima da esplorare (N livelli)
  -c        mostra un totale complessivo finale

ESEMPI UTILI:
  du -h .
      → Mostra dimensioni di tutte le sottodirectory nella cartella corrente.

  du -sh /var/log
      → Mostra solo il totale dello spazio usato da /var/log.

  du -ah /home/user | sort -h
      → Mostra file e directory con dimensioni leggibili e li ordina dal più piccolo al più grande.

  du -h -d 1 /etc
      → Mostra le dimensioni delle directory di primo livello dentro /etc.

---------------------------------
COMANDO: df (disk free)
---------------------------------
DESCRIZIONE:
"df" mostra lo spazio totale, usato e disponibile su dischi, partizioni o filesystem.

OPZIONI NOTE:
  -h        valori leggibili (KB, MB, GB)
  -T        mostra il tipo di filesystem
  -t FSTYPE mostra solo filesystem di un certo tipo
  -x FSTYPE esclude filesystem di un certo tipo
  --total   aggiunge un totale complessivo

ESEMPI UTILI:
  df -h
      → Mostra lo spazio disponibile e usato in tutti i filesystem in maniera leggibile.

  df -Th
      → Mostra anche il tipo di filesystem (ext4, xfs, tmpfs, ecc.).

  df -h /home
      → Mostra lo spazio della partizione su cui risiede /home.

  df -x tmpfs -h
      → Mostra tutti i filesystem tranne quelli di tipo tmpfs.

NOTE:
- "du" guarda lo spazio usato da file e directory.
- "df" guarda lo spazio effettivo libero/usato sul filesystem.
- Le due cifre possono differire per via di blocchi riservati, compressione, filesystem speciali o file cancellati ma ancora aperti da processi.
