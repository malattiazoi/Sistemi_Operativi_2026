# Metacaratteri base
.        → qualsiasi carattere singolo  
^        → inizio riga  
$        → fine riga  
*        → zero o più occorrenze  
\?       → zero o una occorrenza (BRE, grep senza -E)  
\+       → una o più occorrenze (BRE, grep senza -E)  
?        → zero o una occorrenza (ERE, grep -E)  
+        → una o più occorrenze (ERE, grep -E)  
|        → OR logico (grep -E)  
()       → raggruppamento (grep -E)  
[]       → classe di caratteri  
[^...]   → classe di caratteri negata  

# Classi di caratteri comuni
[0-9]    → una cifra  
[a-z]    → una lettera minuscola  
[A-Z]    → una lettera maiuscola  
[a-zA-Z] → qualsiasi lettera  
[[:digit:]]   → cifra (equivale a [0-9])  
[[:alpha:]]   → lettera (a-zA-Z)  
[[:alnum:]]   → lettera o numero  
[[:space:]]   → spazio o tab  
[[:upper:]]   → maiuscola  
[[:lower:]]   → minuscola  

# Ancore e parole
\<       → inizio parola  
\>       → fine parola  


# Esempi pratici
^Error          → righe che iniziano con “Error”  
OK$             → righe che finiscono con “OK”  
^[0-9]\+        → righe che iniziano con numeri  
foo|bar         → righe con “foo” o “bar” (grep -E)  
[0-9]{3}        → tre cifre consecutive (grep -E)  
[a-zA-Z_]*    → nomi di variabili
.*error.*       → righe che contengono “error”  

# Tipi di grep utili
grep     → regex base (BRE)  
grep -E  → regex estese (ERE, come egrep)  




# Sintassi di grep, BRE e ERE

1. Uso base
   grep [OPZIONI] "PATTERN" file
   Esempio:
     grep "error" log.txt
   → Mostra le righe del file che contengono la parola "error"

2. Espressioni regolari
   grep interpreta il PATTERN come una regex.
   Esistono due tipi di regex:
   - BRE (Basic Regular Expressions) → predefinito in grep
   - ERE (Extended Regular Expressions) → con grep -E o egrep

3. BRE (Basic Regular Expressions)
   - Metacaratteri: . ^ $ [ ] *
   - Gli operatori ?, +, |, () e { } devono essere preceduti da '\'
   Esempi:
     grep 'fo*' file.txt         → “f” seguito da zero o più “o”
     grep 'gr[ae]y' file.txt     → “gray” o “grey”
     grep '^\(foo\|bar\)$' file  → righe con “foo” o “bar”
     grep '^[0-9]\{3\}$' file    → righe con esattamente tre cifre

4. ERE (Extended Regular Expressions)
   - Attivo con: grep -E o egrep
   - Metacaratteri: . ^ $ [ ] * + ? | ( ) { }
   - Non serve il backslash per ?, +, |, () o { }
   Esempi:
     grep -E 'fo+' file.txt       → “f” seguito da una o più “o”
     grep -E 'foo|bar' file.txt   → “foo” o “bar”
     grep -E '(abc){2}' file.txt  → “abc” ripetuto due volte
     grep -E '^[A-Z][a-z]+' file  → parola che inizia con maiuscola

5. Ancore di riga
   ^  → inizio riga
   $  → fine riga
   Esempi:
     grep '^Error' log.txt   → righe che iniziano con “Error”
     grep 'OK$' log.txt      → righe che terminano con “OK”

6. Classi di caratteri
   [abc]        → uno qualsiasi tra a, b, c
   [^abc]       → qualsiasi tranne a, b, c
   [0-9]        → cifre da 0 a 9
   [[:alpha:]]  → lettere
   [[:digit:]]  → numeri
   Esempio:
     grep '^[[:digit:]]' file → righe che iniziano con un numero

7. Quantificatori
   *    → zero o più
   +    → una o più (solo ERE)
   ?    → zero o una (solo ERE)
   {n}  → esattamente n volte
   {n,} → almeno n volte
   {n,m}→ tra n e m volte

8. Consigli pratici
   - Usa sempre virgolette per evitare espansioni della shell
   - Preferisci `grep -E` (ERE): più leggibile e moderno
   - Combina con -i, -r, -n, -w, -c per filtrare meglio

9. Esempio completo
   grep -E -n -i 'error|fail|critical' /var/log/syslog
   → ricerca “error”, “fail” o “critical” (ignorando maiuscole)
     e mostra numero di riga nel file di log
