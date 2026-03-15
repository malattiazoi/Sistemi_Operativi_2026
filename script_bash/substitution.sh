#command substitution example
echo "ciao" | tr "[[:lower:]]" "[[:upper:]]"
#process substitution
echo "ciao" > >(tr "[[:lower:]]" "[[:upper:]]")
#trasformo in maiuscolo con due > e process substitution
#process substitution with input redirection
tr "[[:lower:]]" "[[:upper:]]" < <(echo "ciao")
#trasformo in maiuscolo con < e process substitution   
#process substitution with input and output redirection
tr "[[:lower:]]" "[[:upper:]]" < <(echo "ciao") > output.txt
#trasformo in maiuscolo con < e > e process substitution   
cat output.txt
#visualizzo il contenuto del file output.txt

#process substitution with multiple commands
diff <(echo "ciao") <(echo "CIAO")
#confronto due comandi con process substitution e diff
#diff confronta il contenuto di due file o comandi e mostra le differenze tra di essi
