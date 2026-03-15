
# GitHub Copilot
# Esempio-commentato di molti usi comuni di grep.
# Salva questo file come grep.sh e rendilo eseguibile: chmod +x grep.sh
# Quando esegui lo script, creerà file di esempio e mostrerà vari comandi grep
set -euo pipefail

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

# Creo file di prova
cat > "$WORKDIR/file1.txt" <<'EOF'
Hello World
hello world
Number: 12345
apple banana apple
ERROR: something failed
warning: minor issue
line with word: grep
emptyline

last line
EOF

cat > "$WORKDIR/file2.log" <<'EOF'
INFO startup
ERROR crash
another line with grep
pattern PATTERN Pattern
EOF

echo "Directory di lavoro di esempio: $WORKDIR"
echo

# Funzione helper per mostrare e eseguire il comando
run() {
    printf '+ %s\n' "$*"
    eval "$*"
    echo "----"
}

# Uso base: cerca la stringa "grep" (case-sensitive)
# Opzione: nessuna, output = linee che contengono il pattern
run "grep 'grep' $WORKDIR/file1.txt"

# -i : ignore case (case-insensitive)
run "grep -i 'hello' $WORKDIR/file1.txt"

# -v : invert match (mostra le linee che NON contengono il pattern)
run "grep -v 'ERROR' $WORKDIR/file1.txt"

# -n : mostra numero di riga
run "grep -n 'apple' $WORKDIR/file1.txt"

# -c : conta il numero di linee che contengono il pattern (per file)
run "grep -c 'apple' $WORKDIR/file1.txt"

# -o : mostra solo la porzione di linea che matcha (utile per contare occorrenze reali)
run "grep -o 'apple' $WORKDIR/file1.txt | wc -l"

# -H / -h : -H mostra nome file; -h sopprime il nome file (utile con più file)
run "grep -H 'ERROR' $WORKDIR/*"
run "grep -h 'ERROR' $WORKDIR/*"

# -l : lista file che contengono il pattern (utile per ricerca veloce)
run "grep -l 'pattern' $WORKDIR/*"

# -L : lista file che NON contengono il pattern
run "grep -L 'pattern' $WORKDIR/*"

# -r / -R : ricerca ricorsiva in directory
# --include / --exclude permettono di filtrare nomi file
run "grep -R --include='*.txt' 'line' $WORKDIR"
run "grep -R --exclude='*.log' 'ERROR' $WORKDIR"

# -m NUM : ferma dopo NUM corrispondenze (per file)
run "grep -m 1 'apple' $WORKDIR/file1.txt"

# -A NUM, -B NUM, -C NUM : contesto dopo/prima/entrambi i lati della linea matchata
run "grep -n -A 1 -B 1 'ERROR' $WORKDIR/*"

# -E : usa Extended Regular Expressions (equivale a egrep)
# Esempio: alternation (a|b) e quantificatori più leggibili
run "grep -n -E 'ERROR|warning' $WORKDIR/*"

# -F : fixed-strings, interpreta pattern letteralmente (più veloce per testo semplice)
run "grep -F 'Number: 12345' $WORKDIR/file1.txt"

# -P : usa PCRE (espressioni regolari di tipo Perl) — non sempre disponibile su tutte le piattaforme
# Esempio: \b per confini di parola (funziona con -P)
run "grep -n -P '\\bpattern\\b' $WORKDIR/file2.log || true"

# Esempi di regex utili:
# ^ inizio linea, $ fine linea, . qualsiasi carattere, [a-z] classi
run "grep -n '^Hello' $WORKDIR/file1.txt"
run "grep -n 'line$' $WORKDIR/file1.txt"
run "grep -n -E '[0-9]{3,}' $WORKDIR/file1.txt"

# Contare tutte le occorrenze (non solo linee) usando -o
run "grep -o 'apple' $WORKDIR/file1.txt | wc -l"

# Uso in pipe: combinare con altri comandi
# esempio: mostra righe uniche (sort|uniq)
run "grep -i 'pattern' $WORKDIR/* | sort | uniq -c"

# --color : evidenzia il match (utile in terminale)
run "grep --color=always -n 'grep' $WORKDIR/* | sed -n '1,3p'"

# -q : quiet / exit code only (utile in script per testare presenza)
# exit code 0 = trovato, 1 = non trovato
if grep -q 'ERROR' "$WORKDIR/file1.txt"; then
    echo 'ERROR trovato in file1.txt'
fi

# -s : sopprime messaggi di errore (utile quando si cercano file che potrebbero non esistere)
run "grep -s 'something' /no/such/file || echo 'nessun output perché -s sopprime errori'"

# -a : tratta file binari come testo
# --binary-files=TYPE : come trattare i file binari (e.g. text, binary, without-match)
# Esempio non dimostrato su file binari qui.

# Suggerimenti rapidi (note):
# - Usa -E per regex più complesse senza backslash extra.
# - Usa -F per velocità su pattern letterali multipli (con -f file_di_pattern).
# - Usa -P quando hai bisogno di \b, lookahead/lookbehind (se supportato).
# - Per cercare parole intere, preferisci -w (corrispondenza di parola intera)
run "grep -w 'line' $WORKDIR/file1.txt"

echo "Fine dimostrazione. Rimuovendo i file temporanei..."