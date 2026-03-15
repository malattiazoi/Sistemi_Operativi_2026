### STRONG vs WEAK QUOTING in Bash

# STRONG QUOTING - Apici singoli '...'
# - Tutto ciò che è dentro ' ' viene preso alla lettera.
# - Nessuna espansione di variabili, comandi o caratteri speciali.

# Esempio:
nome="Mario"
echo 'Ciao $nome'
# Output: Ciao $nome  <- non espande

echo 'Oggi è $(date)'
# Output: Oggi è $(date)

-> Usare gli apici singoli (' ') per scrivere testo letterale esatto.
" ' `
---

#### WEAK QUOTING - Apici doppi "..."
• Dentro " ", la shell espande:
  - variabili (`$VAR`)
  - sostituzioni di comando (`$(...)` o        `...`     )
  - caratteri di escape come `\n`, `\t` (in certe circostanze)
• Ma mantiene gli spazi e impedisce il word splitting.

Esempio:
nome="Mario"
echo "Ciao $nome"
# Output: Ciao Mario

echo "Oggi è $(date)"
# Output: Oggi è Thu Oct  9 20:00:00 CEST 2025

-> Usa apici doppi (" ") quando vuoi espansione ma protezione da spazi.

---

#### 3. Niente quoting
Se non usi virgolette, la shell divide le parole sugli spazi e interpreta tutti i caratteri speciali.

nome="Mario Rossi"
echo Ciao $nome
# Output: Ciao Mario Rossi   ← funziona
# Ma in certi contesti diventa pericoloso:
touch file con spazi.txt     # crea più file!
touch "file con spazi.txt"   # crea file singolo con nome contenente spazi

---

#### 4. Escaping con backslash
Il carattere `\` serve per escapare (disattivare) il significato speciale del carattere successivo.

echo "Ciao \"Mario\""
# Output: Ciao "Mario"

echo \$PATH
# Output: $PATH

---

#### 5. Quoting misto
Puoi mescolare strong e weak quoting:
echo "User: '$USER'"
# Output: User: 'tuo_nome'

---

#### 6. Differenze pratiche

- `'...'` (strong quoting)  
  - Non espande variabili   
  - Non espande comandi   
  - Protegge gli spazi   
  - Esempio: 'Ciao $USER' -> Ciao $USER  

- `"..."` (weak quoting)  
  - Espande variabili   
  - Espande comandi   
  - Protegge gli spazi   
  - Esempio: "Ciao $USER" -> Ciao marco  

- Nessun quoting  
  - Espande variabili   
  - Espande comandi   
  - Non protegge gli spazi (rischio word-splitting)
  - Esempio: echo Ciao $USER -> rischio split  

- `\` (escape singolo carattere)  
  - Non espande (protegge solo un carattere) 
  - Non espande comandi (protegge solo un carattere) ❌
  - Protegge un solo spazio o simbolo   
  - Esempio: echo \$HOME -> $HOME


---

#### Casi d'uso
- Usa "..." per la maggior parte dei casi (sicuro e flessibile).  
- Usa '...' solo quando vuoi disattivare completamente l’espansione.  
- Quota sempre variabili che potrebbero contenere spazi, come ad esempio i percorsi di file o cartelle.
