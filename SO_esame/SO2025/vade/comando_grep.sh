### COMANDO grep - Ricerca di testo in Bash

#### 1. Sintassi base
grep [opzioni] "pattern" file

# Cerca righe che contengono il "pattern" all’interno di un file.

---

#### 2. Esempi base
grep "errore" log.txt
# Mostra tutte le righe del file log.txt che contengono la parola "errore".

grep "bash" /etc/passwd
# Cerca la parola "bash" nel file /etc/passwd

---

#### 3. Opzioni principali

- -i — Ignora maiuscole/minuscole  
  Esempio: grep -i "errore" file.txt  

- -v — Mostra righe che non corrispondono  
  Esempio: grep -v "OK" log.txt  

- -n — Mostra il numero di riga  
  Esempio: grep -n "main" script.sh  

- -r — Ricerca ricorsiva nelle directory  
  Esempio: grep -r "TODO" ./src  

- -l — Mostra solo i nomi dei file che contengono il pattern  
  Esempio: grep -l "keyword" .txt  

- -c — Conta quante righe corrispondono  
  Esempio: grep -c "error" log.txt  

- -w — Corrisponde a parole intere  
  Esempio: grep -w "cat" testo.txt  

- -x — Corrisponde a righe intere  
  Esempio: grep -x "OK" file.txt  

- -A N — Mostra N righe dopo la corrispondenza  
  Esempio: grep -A 2 "Error" log.txt  

- -B N — Mostra N righe prima della corrispondenza  
  Esempio: grep -B 2 "Error" log.txt  

- -C N — Mostra N righe prima e dopo la corrispondenza  
  Esempio: grep -C 3 "Error" log.txt


---

#### 4. Ricerca in più file
grep "main" .c
# Cerca "main" in tutti i file .c nella directory corrente.

grep -r "function" /home/user/progetto/
# Ricerca ricorsiva in tutte le sottocartelle.

---

#### 5. Espressioni regolari
grep "^[A-Z]" nomi.txt
# Righe che iniziano con una lettera maiuscola.

grep "[0-9]\{3\}" file.txt
# Righe che contengono almeno 3 cifre consecutive.

grep -E "cat|dog" testo.txt
# Cerca "cat" O "dog" (usa -E per regex estese)

grep -E "[A-Za-z]+@[A-Za-z]+\.[A-Za-z]+" mail.txt
# Trova indirizzi email semplici.

---

#### 6. Case insensitive
grep -i "linux" file.txt
# Trova “linux”, “Linux” o “LINUX”.

---

#### 7. Solo la parte trovata
grep -o "[0-9]\+" numeri.txt
# Mostra solo la parte del testo che corrisponde (solo i numeri).

---

#### 8. Conta righe corrispondenti
grep -c "404" access.log
# Restituisce quante righe contengono "404".

---

#### 9. Mostra file che NON contengono il pattern
grep -L "success" .log
# Elenca solo i file che non contengono la parola "success".

---

#### 10. Pipe e combinazioni
dmesg | grep -i "error"
# Cerca "error" nel log del kernel.

ps aux | grep "bash"
# Filtra i processi che contengono “bash”.

cat elenco.txt | grep "^A"
# Mostra solo righe che iniziano con A.

---

#### 11. Pattern da file
grep -f pattern.txt testo.txt
# Cerca tutte le parole elencate in pattern.txt dentro testo.txt

---

#### 12. Colori
grep --color=auto "pattern" file
# Evidenzia le corrispondenze trovate nel testo.

---

#### 13. Esempi pratici
# Trovare righe vuote
grep "^$" file.txt

# Trovare indirizzi IP
grep -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" log.txt

# Contare errori “404”
grep -c "404" access.log

# Cercare righe che iniziano con #
grep "^#" script.sh
