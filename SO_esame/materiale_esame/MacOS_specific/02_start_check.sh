#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "[AVVISO] Questo script è stato scritto su macOS (BSD)."
    echo "Assicurati di non usare opzioni specifiche di BSD per i seguenti comandi:"
    
    # divergenze note GNU/BSD
    COMMANDS=("sed" "grep" "find" "stat" "date")
    
    for cmd in "${COMMANDS[@]}"; do
        if grep -q "\<$cmd\>" "$0"; then
            echo "  -> Rilevato comando '$cmd': verifica la sintassi GNU/Linux."
        fi
    done
    echo "----------------------------------------"
fi

#inizia a scrivere...