#!/bin/bash

# ==============================================================================
# 31. LE VARIABILI PS (PROMPT STRING): PS1, PS2, PS3, PS4
# ==============================================================================
# FONTE: Appunti + Integrazione macOS (Bash vs Zsh)
#
# DESCRIZIONE:
# Bash usa 4 variabili speciali per definire "cosa vedi" quando la shell ti parla.
# - PS1: Il prompt normale (chi sei, dove sei).
# - PS2: Il prompt di continuazione (quando scrivi su più righe).
# - PS3: Il prompt dei menu "select" (script interattivi).
# - PS4: Il prompt di DEBUG (fondamentale con set -x).
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PS1 - IL PROMPT PRINCIPALE (Primary Prompt)
# ------------------------------------------------------------------------------
# È quello che vedi ogni volta che la shell aspetta un comando.
# Default tipico: "[\u@\h \W]\\$ " -> "[utente@host cartella]$ "

# Codici speciali per PS1 (Bash):
# \u = username
# \h = hostname (nome computer)
# \w = percorso completo (es. /Users/mlazoi/Desktop)
# \W = solo cartella corrente (es. Desktop)
# \d = data
# \t = ora
# \$ = mostra '#' se sei root, '$' se sei utente normale

# ESEMPIO: Cambiare il prompt al volo per non perdersi
# (Utile all'esame se hai tanti terminali aperti)
PS1="ESAME_BASH: \w $ "

# ESEMPIO: Prompt colorato (ANSI Colors)
# \e[32m = Verde, \e[0m = Reset
PS1="\e[32m\u\e[0m@\h:\w $ "


# ------------------------------------------------------------------------------
# 2. PS2 - IL PROMPT DI CONTINUAZIONE (Secondary Prompt)
# ------------------------------------------------------------------------------
# Appare quando lanci un comando incompleto (es. apri virgolette senza chiuderle).
# Default: "> "

# Cambiamolo per renderlo più visibile
PS2="...continua... > "

# Esempio pratico (copia-incolla nel terminale per vederlo):
echo "Questa è una frase spezzata
su due righe"
# Noterai che dopo la prima riga appare il tuo PS2 personalizzato.


# ------------------------------------------------------------------------------
# 3. PS3 - IL PROMPT DEI MENU 'SELECT' (CRITICO PER SCRIPT)
# ------------------------------------------------------------------------------
# Il comando 'select' permette di creare menu interattivi all'istante.
# Se NON imposti PS3, il prompt sarà "#?", che è brutto e confonde l'utente.

PS3="Scegli la tua operazione (1-3): "

# Esempio di menu (NOTA: Premi Ctrl+C per uscire se lo esegui):
echo "--- ESEMPIO MENU SELECT ---"
select opzione in "Avvia" "Ferma" "Esci"; do
    case $opzione in
        "Avvia") echo "Start...";;
        "Ferma") echo "Stop...";;
        "Esci")  break;;
        *)       echo "Opzione non valida!";;
    esac
    break # Rimuovi questo break se vuoi che il menu cicli all'infinito
done


# ------------------------------------------------------------------------------
# 4. PS4 - IL PROMPT DI DEBUG (LA TUA ARMA SEGRETA)
# ------------------------------------------------------------------------------
# Quando usi 'set -x' per fare debug, Bash stampa i comandi eseguiti preceduti da PS4.
# Default: "+ "

# TRUCCO D'ESAME:
# Modifica PS4 per mostrarti IL NUMERO DI RIGA ($LINENO) e il file ($BASH_SOURCE).
# Così sai esattamente dove scoppia l'errore.

PS4='+ [RIGA $LINENO]: '
set -x  # Attiva debug

echo "Questo comando verrà tracciato con il numero di riga"
ls -d /tmp

set +x  # Disattiva debug per pulizia


# ==============================================================================
# 📊 TABELLA RIEPILOGATIVA VARIABILI PS
# ==============================================================================
# | VAR  | NOME COMPLETO    | QUANDO APPARE                            | DEFAULT |
# |------|------------------|------------------------------------------|---------|
# | PS1  | Prompt String 1  | Shell pronta (attesa comandi)            | \s-\v\$ |
# | PS2  | Prompt String 2  | Comando incompleto (multilinea)          | >       |
# | PS3  | Prompt String 3  | Dentro un ciclo `select` (input utente)  | #?      |
# | PS4  | Prompt String 4  | Modalità debug `set -x` (xtrace)         | +       |

# ==============================================================================
# 💡 SUGGERIMENTI E SCENARI D'ESAME (MACOS)
# ==============================================================================

# --- SCENARIO 1: "Lo script con select non mostra cosa devo digitare" ---
# Errore classico: Hai dimenticato di definire PS3.
# Soluzione: Scrivi `PS3="Fai una scelta: "` PRIMA del blocco `select`.

# --- SCENARIO 2: "Non capisco quale if sta fallendo nel debug" ---
# Il debug standard (+ echo...) è confuso se hai tanti if uguali.
# Usa: export PS4='+($LINENO) '
# Ora ogni riga di debug ti dice il numero di riga del codice sorgente.

# --- SCENARIO 3: "Il prompt è sparito o è strano" ---
# Se sbagli la sintassi di PS1 (es. colori non chiusi), il terminale impazzisce.
# Comando di emergenza per ripristinare:
# PS1="\\$ "

# --- NOTA SU ZSH (DEFAULT MACOS) ---
# Se apri il terminale su Mac e scrivi `echo $PS1`, potresti vedere roba strana (`%n@%m`).
# Zsh usa `%` al posto di `\` per i codici (es. `%n` user, `%m` host).
# Ma quando scrivi uno SCRIPT con `#!/bin/bash`, valgono le regole di Bash (\u, \h).