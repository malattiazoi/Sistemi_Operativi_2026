#!/bin/bash

# ===============================================
# SPIEGAZIONE DEL FUNZIONAMENTO DI OPENSSL
# ===============================================

# --- Sezione 1: Cos'è OpenSSL? ---
echo "## 🚀 Introduzione a OpenSSL"
echo "OpenSSL è una libreria software per applicazioni che proteggono le comunicazioni di rete tramite SSL/TLS."
echo "È anche un potente strumento a riga di comando per: creare chiavi, richieste di certificati (CSR), certificati, e per effettuare operazioni di crittografia e decrittografia."
echo "Premi Invio per continuare..."
read

# --- Sezione 2: Generazione della Chiave Privata (RSA) ---
echo "## 🗝️ Passo 1: Generazione della Chiave Privata (RSA)"
echo "La **chiave privata** è il segreto che possiedi. Viene usata per decrittografare i dati e firmare digitalmente le informazioni."
echo "Iniziamo con la creazione di una chiave RSA (l'algoritmo di crittografia più comune)."
echo "---"

# Comando: Genera una chiave privata RSA con dimensione 2048 bit
echo "Comando: openssl genrsa -out mia_chiave.key 2048"
openssl genrsa -out mia_chiave.key 2048 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Risultato: Chiave privata 'mia_chiave.key' generata con successo! (2048 bit)"
else
    echo "Errore nella generazione della chiave."
    exit 1
fi
echo "---"
echo "Parametri chiave:"
echo "* **genrsa**: Indica a OpenSSL di generare una chiave RSA."
echo "* **-out**: Specifica il nome del file di output."
echo "* **2048**: Specifica la dimensione della chiave in bit. Più è grande, più è sicura (ma più lenta)."
echo "Premi Invio per continuare..."
read

# --- Sezione 3: Creazione della Richiesta di Firma del Certificato (CSR) ---
echo "## 📝 Passo 2: Creazione della Richiesta di Firma (CSR)"
echo "La **Richiesta di Firma del Certificato (CSR)** è il file che invii a un'Autorità di Certificazione (CA) per ottenere il tuo certificato SSL/TLS."
echo "Contiene le informazioni della tua identità (nome del dominio, organizzazione, ecc.) e la **chiave pubblica** estratta dalla tua chiave privata."
echo "---"

# Comando: Crea una CSR usando la chiave privata appena generata
echo "Comando: openssl req -new -key mia_chiave.key -out mia_richiesta.csr -subj '/CN=example.com/O=MiaOrganizzazione/'"
openssl req -new -key mia_chiave.key -out mia_richiesta.csr -subj '/CN=example.com/O=MiaOrganizzazione/C=IT' > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Risultato: Richiesta CSR 'mia_richiesta.csr' generata con successo!"
else
    echo "Errore nella generazione della CSR."
    exit 1
fi
echo "---"
echo "Parametri chiave:"
echo "* **req**: Utility per la gestione delle richieste di certificato."
echo "* **-new**: Indica che stiamo creando una nuova richiesta."
echo "* **-key**: Specifica il file della chiave privata da usare."
echo "* **-out**: Specifica il nome del file CSR di output."
echo "* **-subj**: Permette di inserire i dettagli del soggetto (Subject) in linea, ad es. CN (Nome Comune), O (Organizzazione), C (Paese)."
echo "Premi Invio per continuare..."
read

# --- Sezione 4: Creazione di un Certificato Autofirmato (Self-Signed) ---
echo "## 🛡️ Passo 3: Creazione di un Certificato (Simulazione CA)"
echo "Un **Certificato** è il file pubblico che verifica la tua identità. Viene firmato da una CA (o da te stesso, in questo caso)."
echo "Per test e scopi non pubblici, possiamo 'autofirmare' la CSR per creare un certificato."
echo "---"

# Comando: Firma la CSR con la chiave privata (autofirma)
echo "Comando: openssl x509 -req -days 365 -in mia_richiesta.csr -signkey mia_chiave.key -out mio_certificato.crt"
openssl x509 -req -days 365 -in mia_richiesta.csr -signkey mia_chiave.key -out mio_certificato.crt > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Risultato: Certificato 'mio_certificato.crt' generato con successo! Valido per 365 giorni."
else
    echo "Errore nella generazione del certificato."
    exit 1
fi
echo "---"
echo "Parametri chiave:"
echo "* **x509**: Utility per la gestione dei certificati X.509 (il formato standard per i certificati SSL/TLS)."
echo "* **-req**: Dice a OpenSSL che l'input (-in) è una CSR e non un certificato esistente."
echo "* **-days**: Definisce per quanti giorni sarà valido il certificato."
echo "* **-signkey**: Specifica la chiave privata da usare per la firma (autofirma in questo caso)."
echo "Premi Invio per concludere..."
read

# --- Sezione 5: Pulizia ---
echo "## 🧹 Pulizia"
rm mia_chiave.key mia_richiesta.csr mio_certificato.crt
echo "I file di esempio (chiave, csr, cert) sono stati rimossi."
echo "---"
echo "✅ Fine della spiegazione di OpenSSL. Spero ti sia stata utile! Adesso sai come si creano gli elementi fondamentali di un certificato SSL/TLS."

#|:-------------------------------------------------------------------------------:|

openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -in private.pem -pubout -out public.pem