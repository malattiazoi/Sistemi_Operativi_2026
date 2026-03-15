#!/bin/bash
# script: elimina

# elimina file1 [file2 file3 ...]

if [ "$#" -lt 1 ]; then
    echo "usage: $0 file..." >&2
    exit 1
fi

for f in "$@"; do

    # controllo esistenza file
    if [ ! -e "$f" ]; then
        echo "ops: '$f' non esiste. skip" >&2
        continue
    fi

    # controllo se è un file regolare
    if [ ! -f "$f" ]; then
        echo "ops: '$f' non è un file regolare. skip" >&2
        continue
    fi

    echo
    echo "file '$f'"

    # mountpoint filesystem su cui risiede il file
    mountpoint=$(df --output=target -- "$f" | tail -1)

    # eliminazione file e tutti i suoi hard link (stesso inode)
    echo "  - Rimozione file e hard link:"
    find "$mountpoint" -xdev -samefile "$f" -exec rm -i -- {} \;

    # cancellazione dei link simbolici che puntano esattamente a questo percorso
    # (funziona per symlink che contengono esattamente il path $f come target)
    echo "  - Rimozione link simbolici che puntano a '$f':"
    find "$mountpoint" -xdev -xtype l -lname "$f" -exec rm -i -- {} \;

done


