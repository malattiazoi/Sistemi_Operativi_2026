#!/bin/bash
# Scrivere uno script bash che cerchi tutti i files il cui nome contiene caratteri diversi da lettere o 
# cifre e, per ciascun file trovato, proponga all'utente la sostituzione di ciascuno di tali caratteri 
# con un carattere proposto dall'utente.

if [ $# -ne 1 ]; then
    echo "Usage: $0 <char_substitute>"
    exit 1
fi
char_substitute="$1"

find . -type f | while read -r file; do
    filename=$(basename "$file")
    dir=$(dirname "$file")
    
    if [[ "$filename" =~ [^a-zA-Z0-9] ]]; then
        new_filename="$filename"
        
        
        for (( i=0; i<${#filename}; i++ )); do
            char="${filename:$i:1}"
            if [[ ! "$char" =~ [a-zA-Z0-9] ]]; then
                new_filename="${new_filename//$char/$char_substitute}"
            fi
        done
        
    
        echo "File found: $file"
        echo "Proposed new filename: $new_filename"
        read -p "Do you want to rename the file? (y/n): " yn < /dev/tty
        if [[ "$yn" == "y" ]]; then
            mv "$file" "$dir/$new_filename"
            echo "File renamed to: $dir/$new_filename"
        else
            echo "File not renamed."
        fi
    fi
done