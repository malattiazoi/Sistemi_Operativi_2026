Base64 converte ogni gruppo di 3 byte (24 bit) in 4 caratteri ASCII da un set di 64 simboli:

A-Z a-z 0-9 + /

Il simbolo = viene usato come padding per completare i gruppi.

echo "Ciao" | base64
# Output: Q2lhbw==

echo "Q2lhbw==" | base64 --decode
# Output: Ciao

# Codificare un file
base64 immagine.png > immagine.b64
# Crea un file immagine.b64 contenente la versione Base64 di immagine.png.


# Decodificare un file Base64
base64 --decode immagine.b64 > immagine_decodificata.png
# Ricrea il file originale dalla versione codificata.