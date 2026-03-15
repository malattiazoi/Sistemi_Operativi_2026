#!/bin/bash

# check_linux_compat.sh
# Analizza uno script per individuare comandi o opzioni non portabili tra macOS e Linux

FILE=$1

if [[ -z "$FILE" ]]; then
    echo "Utilizzo: $0 nome_script.sh"
    exit 1
fi

echo "--- Analisi di compatibilità per: $FILE ---"

# 1. Verifica dello Shebang
SHEBANG=$(head -n 1 "$FILE")
if [[ ! "$SHEBANG" =~ ^#!/bin/bash ]] && [[ ! "$SHEBANG" =~ ^#!/usr/bin/env\ bash ]]; then
    echo "[!] ATTENZIONE: Shebang non standard o mancante. Usa #!/usr/bin/env bash per massima portabilità."
fi

# 2. Controllo comandi GNU vs BSD (i "soliti sospetti")
# macOS usa versioni BSD di sed, grep, find; Linux usa GNU.
KEYWORDS=("sed" "grep" "find" "xargs" "stat" "date")

for cmd in "${KEYWORDS[@]}"; do
    if grep -q "\<$cmd\>" "$FILE"; then
        echo "[?] INFO: Trovato comando '$cmd'. Verifica che le opzioni usate siano GNU-compatibili."
        # Esempio: sed -i su macOS richiede un argomento, su Linux no.
        if [[ "$cmd" == "sed" ]]; then
             grep -n "sed.*-i" "$FILE" && echo "    -> Nota: 'sed -i' differisce tra macOS e Linux."
        fi
    fi
done

# 3. Verifica percorsi tipici di macOS non presenti su Linux
if grep -q "/Library/" "$FILE" || grep -q "/Volumes/" "$FILE"; then
    echo "[!] ERRORE: Trovati percorsi specifici di macOS (/Library o /Volumes)."
fi

# 4. Suggerimento strumento professionale (ShellCheck)
if ! command -v shellcheck &> /dev/null; then
    echo "---"
    echo "Consiglio: Installa 'shellcheck' (brew install shellcheck)."
    echo "È il gold standard per trovare errori di portabilità (POSIX)."
else
    echo "--- Risultato ShellCheck (Portabilità) ---"
    shellcheck -s bash -p portability "$FILE"
fi