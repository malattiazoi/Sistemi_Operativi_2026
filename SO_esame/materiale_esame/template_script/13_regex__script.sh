#!/bin/bash

# ==============================================================================
#   IL MANUALE DEFINITIVO DELLE REGEX IN BASH (MASTER EDITION)
#   Autore: Il tuo AI Thought Partner
#   Versione: 1.0
#   Compatibilità: Bash 3.2+ (macOS/Linux)
# ==============================================================================

# --- CONFIGURAZIONE COLORI (Per output belli) ---
R="\033[0;31m" # Red (Errore)
G="\033[0;32m" # Green (Successo)
Y="\033[1;33m" # Yellow (Titoli)
C="\033[0;36m" # Cyan (Info)
X="\033[0m"    # Reset

clear
echo -e "${Y}"
echo "############################################################"
echo "#           REGEX MASTER CLASS - HANDBOOK .SH              #"
echo "############################################################"
echo -e "${X}"
echo "Questo script ti insegna e testa le Regex più utili per l'esame."
echo "La sintassi usata è quella nativa di Bash: [[ stringa =~ regex ]]"
echo ""

# Funzione helper per testare le regex visualmente
test_regex() {
    local str="$1"
    local pat="$2"
    local desc="$3"

    echo -ne "${C}[TEST]${X} $desc ('$str')... "
    
    # NOTA TECNICA IMPORTANTE:
    # In Bash, la variabile della regex NON va messa tra virgolette dentro [[ ]]
    if [[ "$str" =~ $pat ]]; then
        echo -e "${G}MATCH (Vero)${X}"
    else
        echo -e "${R}NO MATCH (Falso)${X}"
    fi
}

# ==============================================================================
# CAPITOLO 1: LE BASI (ANCORE E CARATTERI)
# ==============================================================================
echo -e "\n${Y}=== CAPITOLO 1: LETTERE E BASI ===${X}"
# SPIEGAZIONE:
# ^      = Inizio della stringa (Anchor Start)
# $      = Fine della stringa (Anchor End)
# [a-z]  = Solo lettere minuscole
# [A-Z]  = Solo lettere maiuscole
# +      = "Uno o più" (Obbligatorio almeno un carattere)
# * = "Zero o più" (Accetta anche stringa vuota)

# 1. Solo Lettere (Nomi propri semplici)
REGEX_SOLO_LETTERE="^[a-zA-Z]+$"
test_regex "Mario" "$REGEX_SOLO_LETTERE" "Solo lettere (No spazi)"
test_regex "Mario123" "$REGEX_SOLO_LETTERE" "Lettere con numeri (Fallimento)"

# 2. Lettere con Spazi (Nomi completi)
# Nota: [a-zA-Z\ ] include lo spazio dopo la Z.
REGEX_NOME_COGNOME="^[a-zA-Z\ ]+$"
test_regex "Mario Rossi" "$REGEX_NOME_COGNOME" "Nome e Cognome con spazio"

# ==============================================================================
# CAPITOLO 2: I NUMERI
# ==============================================================================
echo -e "\n${Y}=== CAPITOLO 2: NUMERI E QUANTIFICATORI ===${X}"
# SPIEGAZIONE:
# [0-9]  = Qualsiasi cifra da 0 a 9
# {N}    = Esattamente N volte (es. {3} = 3 cifre)
# {N,M}  = Da N a M volte (es. {2,4} = min 2, max 4 cifre)

# 1. Numeri interi positivi (ID, Quantità)
REGEX_INTERO="^[0-9]+$"
test_regex "2024" "$REGEX_INTERO" "Numero intero"
test_regex "24a" "$REGEX_INTERO" "Numero sporco"

# 2. Codice a lunghezza fissa (Es. PIN 4 cifre)
REGEX_PIN="^[0-9]{4}$"
test_regex "1234" "$REGEX_PIN" "PIN corretto (4 cifre)"
test_regex "12345" "$REGEX_PIN" "PIN errato (5 cifre)"

# ==============================================================================
# CAPITOLO 3: FORMATI COMPLESSI (DATE E EMAIL)
# ==============================================================================
echo -e "\n${Y}=== CAPITOLO 3: FORMATI UTILI (DATE, EMAIL) ===${X}"

# 1. Data Formato GG/MM/AAAA
# [0-9]{2} = Due cifre
# \/       = Lo slash va "escapato" con \ per dire che è un carattere vero
REGEX_DATA="^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$"
test_regex "27/01/2026" "$REGEX_DATA" "Data valida GG/MM/AAAA"

# 2. Email Semplice (Per esami)
# [a-zA-Z0-9._%+-]+  = Nome utente (lettere, numeri, punti, ecc.)
# @                  = La chiocciola obbligatoria
# [a-zA-Z0-9.-]+     = Dominio (es. gmail)
# \.                 = Il punto vero
# [a-zA-Z]{2,}       = Estensione (com, it, org) di almeno 2 lettere
REGEX_EMAIL="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
test_regex "mattia@esame.it" "$REGEX_EMAIL" "Email valida"
test_regex "mattia@.it" "$REGEX_EMAIL" "Email senza dominio"

# ==============================================================================
# CAPITOLO 4: VALIDAZIONI SPECIALI (FILTRI E INPUT)
# ==============================================================================
echo -e "\n${Y}=== CAPITOLO 4: VALIDAZIONI SPECIALI ===${X}"

# 1. Codice Fiscale (Semplificato per struttura)
# 6 Lettere + 2 Numeri + 1 Lettera + 2 Numeri + 1 Lettera + 3 Numeri + 1 Lettera
REGEX_CF="^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$"
test_regex "RSSMRA80A01H501U" "$REGEX_CF" "Codice Fiscale Struttura"

# 2. Input Sì/No (Case insensitive)
# [Yy] = Y maiuscola O y minuscola
# (es|ES) = Accetta 'yes' o 'YES' (più avanzato, usa pipe | per OR)
REGEX_YES="^([Yy][Ee][Ss]|[Ss][Ii]|[Yy])$" 
test_regex "Si" "$REGEX_YES" "Risposta Affermativa (Si)"
test_regex "yes" "$REGEX_YES" "Risposta Affermativa (yes)"

# ==============================================================================
# AREA DI TEST INTERATTIVA
# ==============================================================================
echo -e "\n${Y}===========================================${X}"
echo -e "${Y}   LABORATORIO: CREA LA TUA REGEX        ${X}"
echo -e "${Y}===========================================${X}"
echo "Scrivi 'exit' per uscire."

while true; do
    echo ""
    read -p "Inserisci la REGEX da testare (es. ^[0-9]+$): " user_regex
    
    # Controllo uscita
    if [[ "$user_regex" == "exit" ]]; then break; fi
    
    read -p "Inserisci la STRINGA di prova: " user_str
    
    echo -n "Risultato: "
    if [[ "$user_str" =~ $user_regex ]]; then
         echo -e "${G}MATCH RIUSCITO!${X}"
    else
         echo -e "${R}NESSUN MATCH.${X}"
    fi
done

echo "Chiusura manuale regex. Buona fortuna per l'esame!"