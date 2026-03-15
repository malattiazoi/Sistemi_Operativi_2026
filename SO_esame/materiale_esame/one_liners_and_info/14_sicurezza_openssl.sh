#!/bin/bash

# ==============================================================================
# GUIDA TECNICA: HASH vs CRITTOGRAFIA (OpenSSL)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. HASH (Impronta Digitale - INTEGRITÀ)
# COS'È: Una funzione UNIDIREZIONALE. Prendi un file di 1GB e ottieni 64 caratteri.
# REGOLE D'ORO:
# - NON si può tornare indietro (dall'hash non ricavi il file).
# - Se cambi anche solo un PUNTO nel file, l'hash cambia completamente.
# - Serve a dire: "Il file è lo stesso che ha inviato il prof? Sì/No".
# ------------------------------------------------------------------------------

# Genera SHA256 (lo standard attuale)
openssl dgst -sha256 file.txt

# Genera MD5 (veloce ma insicuro, utile per check rapidi)
openssl dgst -md5 file.txt


# ------------------------------------------------------------------------------
# 2. CRITTOGRAFIA SIMMETRICA (AES - CONFIDENZIALITÀ)
# COS'È: Usi UNA SOLA PASSWORD sia per chiudere che per aprire.
# REGOLE D'ORO:
# - È bidirezionale (puoi tornare al file originale).
# - Molto veloce, ideale per file grandi o interi archivi .tar.gz.
# ------------------------------------------------------------------------------

# CIFRARE (-e = encrypt)
openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -in dati.txt -out dati.enc

# DECIFRARE (-d = decrypt)
openssl enc -aes-256-cbc -d -pbkdf2 -iter 100000 -in dati.enc -out dati_chiaro.txt


# ------------------------------------------------------------------------------
# 3. CRITTOGRAFIA ASIMMETRICA (RSA - IDENTITÀ E SCAMBIO)
# COS'È: Due chiavi diverse. Pubblica (per chiudere), Privata (per aprire).
# REGOLE D'ORO:
# - Se chiudo con la Pubblica, SOLO la mia Privata può aprire.
# - Serve per scambiare file senza scambiarsi la password a voce.
# ------------------------------------------------------------------------------

# Genera la chiave privata
openssl genpkey -algorithm RSA -out privata.pem

# Estrai la pubblica da dare agli altri
openssl rsa -in privata.pem -pubout -out pubblica.pem

# CIFRARE con pubblica (per il destinatario)
openssl pkeyutl -encrypt -pubin -inkey pubblica.pem -in msg.txt -out msg.enc

# DECIFRARE con privata (solo tu puoi)
openssl pkeyutl -decrypt -inkey privata.pem -in msg.enc -out msg_ok.txt


# ==============================================================================
# 💡 SUGGERIMENTI "MEMORIA RAPIDA" PER L'ESAME
# ==============================================================================

# --- DIFFERENZA FLASH ---
# HASH = Verificare se il file è CORROTTO (Integrità).
# SIMMETRICA = Nascondere il file con una PASSWORD (Privacy).
# ASIMMETRICA = Firmare un file o inviarlo in modo SICURO a un estraneo.

# --- IL "SALT" ---
# Quando vedi l'opzione -salt in OpenSSL, serve a rendere l'hash o la cifratura 
# diversa ogni volta, anche se la password è la stessa. Protegge dai "Rainbow Tables".

# --- FIRMA DIGITALE vs CIFRATURA ---
# - Cifratura: Chiudo il contenuto (nessuno lo legge).
# - Firma: Metto il mio "timbro" (tutti leggono, ma sanno che l'ho scritto io).
# Comando firma: openssl dgst -sha256 -sign privata.pem -out firma.bin file.txt

# ==============================================================================
# GUIDA A OPENSSL: HASH, CRITTOGRAFIA E FIRME
# ==============================================================================

# 1. HASH E INTEGRITÀ (Calcolare l'impronta di un file)
# ------------------------------------------------------------------------------
# Calcola lo SHA256 di un file (molto usato per verificare integrità)
openssl dgst -sha256 file.txt

# Calcola MD5 (più vecchio, ma veloce)
openssl dgst -md5 file.txt


# 2. CRITTOGRAFIA SIMMETRICA (Password condivisa)
# ------------------------------------------------------------------------------
# Cifrare un file con algoritmo AES-256 e password
openssl enc -aes-256-cbc -salt -in segreto.txt -out segreto.enc

# Decifrare lo stesso file
openssl enc -aes-256-cbc -d -in segreto.enc -out segreto_chiaro.txt


# 3. CRITTOGRAFIA ASIMMETRICA (Chiave Pubblica/Privata)
# ------------------------------------------------------------------------------
# Generare una chiave privata RSA (2048 bit)
openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:2048

# Estrarre la chiave pubblica dalla privata
openssl rsa -in private.pem -pubout -out public.pem

# Cifrare con chiave pubblica
openssl pkeyutl -encrypt -pubin -inkey public.pem -in messaggio.txt -out messaggio.enc

# Decifrare con chiave privata
openssl pkeyutl -decrypt -inkey private.pem -in messaggio.enc -out messaggio_chiaro.txt


# 4. FIRMA DIGITALE (Autenticità)
# ------------------------------------------------------------------------------
# Firmare un file con la propria chiave privata
openssl dgst -sha256 -sign private.pem -out firma.bin documento.txt

# Verificare la firma con la chiave pubblica
openssl dgst -sha256 -verify public.pem -signature firma.bin documento.txt


# ==============================================================================
# 💡 SUGGERIMENTI PER L'ESAME (SCENARI PRATICI)
# ==============================================================================

# --- SCENARIO 1: "Verifica se il file caricato sul server è corrotto" ---
# Prima di caricare: openssl dgst -sha256 mio_esame.tar.gz > hash_locale.txt
# Una volta sul server: openssl dgst -sha256 mio_esame.tar.gz
# Se i codici alfanumerici coincidono, il file è integro.

# --- SCENARIO 2: "Inviare un file protetto al professore" ---
# Se ti chiedono di cifrare la consegna:
# openssl enc -aes-256-cbc -a -salt -in consegna.tar.gz -out consegna.enc
# (L'opzione -a usa base64 così il file risultante è leggibile come testo).

# --- TRUCCO PER LE PASSWORD ---
# Se vuoi generare una password casuale sicura di 16 caratteri per un test:
# openssl rand -base64 16

# --- ATTENZIONE: COMPATIBILITÀ ---
# Tra MacOS e Linux le versioni di OpenSSL potrebbero variare.
# Se 'openssl enc' dà errori di "Bad Magic Number", potrebbe dipendere dal salt 
# o dalla versione (1.1 vs 3.0). Per massima compatibilità in esame usa:
# openssl enc -aes-256-cbc -pbkdf2 -iter 100000 (standard moderno)