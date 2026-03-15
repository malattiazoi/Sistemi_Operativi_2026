### Comando read in bash 

#### Sintassi di base
# read [opzioni] variabile1 variabile2 ...

# # ---

# Esempio semplice con tastiera
echo -n "Inserisci il tuo nome: "
read nome
echo "Ciao, $nome"

# # ---

# Leggere un file riga per riga
while read riga; do
    echo "Ho letto: $riga"
done < file.txt


# # ---

# NOTA
# Per non perdere spazi e per gestire bene i backslash:
while IFS= read -r linea; do
    echo "$linea"
done < file.txt

# - IFS= -> mantiene spazi iniziali e finali.  Default: IFS=$' \t\n'
# - -r   -> evita che "\" venga interpretato come carattere speciale


# # ---

# Leggere con più variabili (file con campi separati da spazi)
while read nome cognome eta; do
    echo "Nome: $nome, Cognome: $cognome, Età: $eta"
done < persone.txt

# Esempio di contenuto persone.txt:
# Mario Rossi 30
# Lucia Bianchi 25

# Output:
# Nome: Mario, Cognome: Rossi, Età: 30
# Nome: Lucia, Cognome: Bianchi, Età: 25

# # ---

# Leggere solo la prima riga di un file
read prima_riga < file.txt
echo "Prima riga: $prima_riga"
