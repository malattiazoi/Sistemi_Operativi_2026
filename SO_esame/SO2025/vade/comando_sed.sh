`sed` (Stream EDitor) è un comando usato in Unix/Linux per modificare testi in modo automatico.
Lavora riga per riga e può:
- sostituire testo
- eliminare righe
- estrarre parti di testo
- modificare dati tramite pattern regex

Per impostazione predefinita NON modifica il file originale.

----------------------------------------------------
Uso più comune: sostituzione di testo
----------------------------------------------------
Sintassi:
sed 's/vecchio/nuovo/' file

Esempio: sostituisce solo la prima occorrenza per linea:
sed 's/cane/gatto/' animali.txt

Sostituire tutte le occorrenze:
sed 's/cane/gatto/g' animali.txt

----------------------------------------------------
Modificare direttamente un file
----------------------------------------------------
Sed -i = “in-place”
sed -i 's/cane/gatto/g' animali.txt

Con backup automatico:
sed -i.bak 's/cane/gatto/g' animali.txt

----------------------------------------------------
Eliminare righe
----------------------------------------------------
Eliminare righe contenenti un pattern:
sed '/errore/d' log.txt

Eliminare una riga per numero:
sed '3d' file

----------------------------------------------------
Mostrare solo righe che contengono un pattern
----------------------------------------------------
sed -n '/pattern/p' file

----------------------------------------------------
Altri esempi utili
----------------------------------------------------
Sostituire solo la seconda occorrenza nella riga:
sed 's/cane/gatto/2' file

Sostituire dalla riga X a Y:
sed '5,10s/cane/gatto/g' file

Aggiungere testo prima di una riga con pattern:
sed '/pattern/i Testo da inserire' file

Aggiungere testo dopo una riga con pattern:
sed '/pattern/a Testo aggiunto' file



Esempi `sed` con Regex (Espressioni Regolari)

----------------------------------------------------
Rimuovere tutte le cifre da un testo
----------------------------------------------------
sed 's/[0-9]//g' file.txt

Regex: [0-9] → qualsiasi cifra

----------------------------------------------------
Convertire più spazi in uno solo
----------------------------------------------------
sed 's/  */ /g' file.txt

Regex: "  *" → due o più spazi consecutivi

----------------------------------------------------
Sostituire in modo case-insensitive
----------------------------------------------------
sed 's/cane/gatto/Ig' file.txt

Flag I → ignora maiuscole/minuscole

(cane, Cane, CANE → gatto)


----------------------------------------------------
Riepilogo 
----------------------------------------------------
| Azione                       | Comando                          |
|------------------------------|----------------------------------|
| Sostituire una volta         | sed 's/a/b/' file                |
| Sostituire tutte le volte    | sed 's/a/b/g' file               |
| Modificare file              | sed -i 's/a/b/g' file            |
| Cancellare righe             | sed '/pattern/d' file            |
| Stampare solo righe filtrate | sed -n '/pattern/p' file         |
