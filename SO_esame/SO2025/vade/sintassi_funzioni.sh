### FUNZIONI IN BASH

#### 1. Sintassi base
function nome_funzione() {
    comandi
}

# oppure (forma equivalente)
nome_funzione() {
    comandi
}

# Esempio:
saluta() {
    echo "Ciao dal mondo Bash!"
}

saluta

# ---

#### 2. Passaggio di parametri
# I parametri si accedono con $1, $2, $3, ...
stampa_nome() {
    echo "Nome: $1"
    echo "Cognome: $2"
}

stampa_nome "Marco" "Rossi"

# Output:
# Nome: Marco
# Cognome: Rossi

# ---

#### 3. Numero e lista argomenti
funzione_info() {
    echo "Numero argomenti: $#"
    echo "Tutti: $@"
}

funzione_info a b c
# Output:
# Numero argomenti: 3
# Tutti: a b c

# ---
a=contenuto
#### 4. Variabili locali
somma() {
    echo $a
    local b=$2
    local risultato=$((a + b))
    echo "$risultato"
}

res=$(somma 5 7)
echo "Risultato: $res"  # 12

# 'local' limita la visibilità della variabile alla funzione.

# ---

#### 5. Valore di ritorno (exit status)
# Le funzioni possono restituire un codice numerico (0–255)
verifica_file() {
    [ -f "$1" ] && return 0 || return 1
}

if verifica_file "/etc/passwd"; then
    echo "Il file esiste"
else
    echo "File non trovato"
fi

# Nota: 'return' NON restituisce testo, ma un codice di stato.
# Usa echo per restituire stringhe o numeri (da catturare con $(...)).

# ---

#### 6. Restituire valori (tramite echo)
moltiplica() {
    local a=$1
    local b=$2
    echo $((a * b))
}

risultato=$(moltiplica 4 6)
echo "Risultato: $risultato"

# ---

#### 7. Uso di array come parametri
stampa_array() {
    local arr=("$@")
    echo "Array:"
    for x in "${arr[@]}"; do
        echo " - $x"
    done
}

numeri=(10 20 30)
stampa_array "${numeri[@]}"

# ---

#### 8. Funzioni annidate
outer() {
    echo "Funzione esterna"
    inner() {
        echo "Funzione interna"
    }
    inner
}
outer

# ---

#### 9. Funzioni e return condizionale
verifica() {
    if [ -z "$1" ]; then
        echo "Errore: argomento mancante"
        return 1
    fi
    echo "Argomento OK: $1"
}

verifica "ciao"    # ritorna 0
verifica ""        # ritorna 1

# ---

#### 10. Esempio pratico — Mini script con funzioni
leggi_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "File inesistente: $file"
        return 1
    fi
    while IFS= read -r riga; do
        echo "-> $riga"
    done < "$file"
}

stampa_data() {
    echo "Data corrente: $(date)"
}

main() {
    stampa_data
    leggi_file "testo.txt"
}

main  # esegue la funzione principale
