# ============================================================
# ESEMPIO COMPLETO: GENERAZIONE, CRITTOGRAFIA E FIRMA (RSA)
# ============================================================

# 1 GENERAZIONE DELLA COPPIA DI CHIAVI
# --------------------------------------
# Genera chiave privata RSA (2048 bit)
openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:2048

# Estrai chiave pubblica
openssl rsa -in private.pem -pubout -out public.pem


# 2 CRITTOGRAFIA E DECRITTOGRAFIA
# ----------------------------------
# Supponi di avere un file "messaggio.txt" con del testo

# Crittografa con la chiave pubblica
openssl pkeyutl -encrypt -pubin -inkey public.pem -in messaggio.txt -out messaggio.enc

# Decrittografa con la chiave privata
openssl pkeyutl -decrypt -inkey private.pem -in messaggio.enc -out messaggio_decrypted.txt

# Ora "messaggio_decrypted.txt" contiene il testo originale


# 3 FIRMA DIGITALE E VERIFICA
# ------------------------------
# Firma il messaggio con la chiave privata (algoritmo SHA-256)
openssl dgst -sha256 -sign private.pem -out firma.bin messaggio.txt

# Verifica la firma con la chiave pubblica
openssl dgst -sha256 -verify public.pem -signature firma.bin messaggio.txt
# Output atteso (se la firma è valida):
# Verified OK
# Oppure, se non è valida:
# Verification Failure


# 4 RIEPILOGO OPERAZIONI
# -------------------------
# - Crittografia: usa la chiave PUBBLICA
# - Decrittografia: usa la chiave PRIVATA
# - Firma: usa la chiave PRIVATA
# - Verifica: usa la chiave PUBBLICA
