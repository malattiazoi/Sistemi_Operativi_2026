Il comando "curl" (Client URL) è uno strumento da terminale per trasferire dati
da o verso un server tramite vari protocolli come HTTP, HTTPS, FTP, ecc.

Sintassi base:
    curl [OPZIONI] URL

Scaricare una pagina web e mostrarla in output:
    curl https://example.com

Salvare l'output in un file:
    curl https://example.com -o pagina.html

Seguire i redirect automatici:
    curl -L URL

Mostrare solo l'header di risposta:
    curl -I URL

Inviare dati in POST:
    curl -X POST -d "utente=Marco&pass=1234" https://site.com/login

Inviare una richiesta con JSON:
    curl -H "Content-Type: application/json" \
         -d '{"nome":"Luca"}' \
         https://api.site.com/dati

Scaricare più file:
    curl -O https://sito.com/file1.txt -O https://sito.com/file2.txt

Autenticazione con username/password:
    curl -u user:password URL

Riprendere un download interrotto:
    curl -C - -O URL

Opzione utile per debugging:
    curl -v URL

curl è molto usato per:
- Testare API
- Effettuare download/upload
- Automatizzare richieste web
- Debug di comunicazioni HTTP
