SINOSSI
  date [OPZIONI]... [+FORMATO]
  date [-u|--utc|--universal] [OPZIONI]... [+FORMATO]
  date [-d|--date DATA] [+FORMATO]
  date [MMDDhhmm[[CC]YY][.ss]]

DESCRIZIONE
  Il comando `date` visualizza o imposta la data e ora del sistema.
  Senza argomenti, mostra la data corrente usando il formato predefinito.
  Utilizzando specifici formati o opzioni, è possibile:
   • cambiare il formato di visualizzazione della data
   • mostrare la data in UTC
   • convertire timestamp Unix in date leggibili
   • generare timestamp Unix da date leggibili
   • impostare manualmente la data del sistema (richiede permessi elevati)

OPZIONI TIPICHE
  -u, --utc, --universal    Usa l’orario UTC
  -d, --date                Usa la data specificata anziché quella corrente
  --rfc-3339                Visualizza la data secondo lo standard RFC-3339

ESEMPI

- Visualizza la data corrente usando il formato della locale predefinita:
  date +%c
  
  # Controlla le locale disponibili con il comando: 
  # locale -a
  
  # Genera quella italiana (se non esiste):
  # sudo locale-gen it_IT.UTF-8

  # Imposta l’italiano come lingua predefinita (Riavvia la sessione o il computer per applicare le modifiche):
  # sudo update-locale LANG=it_IT.UTF-8

  # esempi:
  # LC_ALL=en_US.UTF-8 date +%c   # in inglese (USA)
  # LC_ALL=fr_FR.UTF-8 date +%c   # in francese
  # LC_ALL=it_IT.UTF-8 date +%c   # in italiano

  Differenza rispetto ad altre variabili

  Ci sono varie variabili di locale:

  LANG: Locale di base (valore predefinito generale)	
  LANG=it_IT.UTF-8
  
  LC_TIME: Solo formato di data e ora	
  LC_TIME=en_GB.UTF-8
  
  LC_NUMERIC:	Solo formato dei numeri	
  LC_NUMERIC=fr_FR.UTF-8
  
  LC_MESSAGES:	Lingua dei messaggi di sistema	
  LC_MESSAGES=it_IT.UTF-8
  
  LC_ALL:	Forza tutte le categorie sopra	
  LC_ALL=it_IT.UTF-8


- Visualizza la data corrente in UTC, usando il formato ISO 8601:
  date [-u|--utc] +%Y-%m-%dT%H:%M:%S%Z

- Visualizza la data corrente come timestamp Unix (secondi dall’epoca Unix):
  date +%s

- Converti una data specificata come timestamp Unix nel formato predefinito:
  date [-d|--date] @1473305798

- Converti una data indicata nel formato timestamp Unix:
  date [-d|--date] "2018-09-01 00:00" +%s [-u|--utc]

- Visualizza la data corrente usando il formato RFC-3339 (YYYY-MM-DD hh:mm:ss TZ):
  date --rfc-3339 s

- Imposta la data corrente usando il formato MMDDhhmmYYYY.ss (YYYY e .ss sono opzionali):
  date 093023592021.59

- Visualizza il numero della settimana ISO corrente:
  date +%V
