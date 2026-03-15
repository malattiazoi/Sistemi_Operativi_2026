
# ============================================================
# REGEX DEMO - Regular Expressions & Extended Regular Expressions
# File: regex_demo.sh
# Autore: ChatGPT
# Uso: bash regex_demo.sh
# ============================================================
# Questo script spiega e mostra esempi pratici di:
# 1. Regular Expression (RE)
# 2. Extended Regular Expression (ERE)
# ------------------------------------------------------------
# NOTA:
# - Le RE sono usate da comandi come: grep, sed, awk, ecc.
# - grep usa RE semplici per default
# - grep -E abilita le Extended Regular Expressions (ERE)
# ============================================================

echo "===== CREAZIONE FILE DI TEST ====="
cat <<EOF > test.txt
apple
apples
Apple
application
happy
maple
grape
12345
abc123
EOF

echo "File di test creato:"
cat test.txt
echo
echo "============================================================"

# ============================================================
# 1️⃣ Regular Expressions (RE)
# ============================================================

echo "===== 1️⃣ REGULAR EXPRESSIONS (RE) ====="

# ^ inizio linea
echo -e "\n# ^ = inizio linea (linee che iniziano con 'a'):"
grep '^a' test.txt

# $ fine linea
echo -e "\n# $ = fine linea (linee che finiscono con 'e'):"
grep 'e$' test.txt

# . (punto) = qualsiasi carattere singolo
echo -e "\n# . = un carattere qualsiasi (a qualsiasi p + un carattere + le):"
grep 'ap.le' test.txt

# [] = insieme di caratteri
echo -e "\n# [] = insieme di caratteri (linee che contengono 'apple' o 'apples'):"
grep 'apples\?' test.txt  # ? non funziona qui (serve -E per ERE)
echo "# Notare: in RE base '?' NON è supportato"

# * = zero o più occorrenze del carattere precedente
echo -e "\n# * = zero o più occorrenze (linee con 'ap' seguito da 0 o più 'p'):"
grep 'app*' test.txt

# ============================================================
# 2️⃣ Extended Regular Expressions (ERE)
# ============================================================
echo
echo "===== 2️⃣ EXTENDED REGULAR EXPRESSIONS (ERE) ====="

# Attiviamo con -E
# | (alternanza)
echo -e "\n# | = OR (apple oppure happy):"
grep -E 'apple|happy' test.txt

# + = una o più occorrenze
echo -e "\n# + = una o più occorrenze (almeno una 'p'):"
grep -E 'ap+p' test.txt

# ? = zero o una occorrenza
echo -e "\n# ? = zero o una occorrenza (apple o apples):"
grep -E 'apples?' test.txt

# () = gruppi
echo -e "\n# () = gruppo (application o apple):"
grep -E 'app(lication|le)' test.txt

# {} = numero di ripetizioni
echo -e "\n# {} = numero di ripetizioni (3 cifre consecutive):"
grep -E '[0-9]{3}' test.txt

# Combinazione complessa
echo -e "\n# Combinazione: inizia con a, finisce con e, qualsiasi cosa in mezzo:"
grep -E '^a.*e$' test.txt

# ============================================================
# 3️⃣ RIASSUNTO RAPIDO
# ============================================================
echo
cat <<EOF
===== RIASSUNTO RAPIDO =====

Caratteri base (RE):
^   = inizio linea
$   = fine linea
.   = un carattere qualsiasi
[]  = insieme di caratteri
*   = zero o più occorrenze

Estensioni (solo con -E):
|   = alternanza (OR)
+   = una o più occorrenze
?   = zero o una occorrenza
()  = raggruppamento
{}  = intervallo di ripetizione

EOF

echo "============================================================"
echo "DEMO COMPLETATA ✅"
