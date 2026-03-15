
# GitHub Copilot
# File: /Users/mattialazoi/Desktop/Sistemi Operativi/script_bash/PID.sh
#
# Script dimostrativo (in italiano) su UID, EUID, GID, PID e gli "affiliati":
# - UID / EUID: identificatori utente reale ed effettivo
# - GID / groups: gruppi e group id
# - PID: process id ($$, $BASHPID, $!)
# - PPID: parent PID
# - PGID: process group id
# - SID: session id
# - TPGID: foreground process group of controlling terminal (se presente)
# - setuid/setgid bits (mostrati con stat; attenzione: setuid su script spesso ignorato)
#
# Il file è pensato per essere eseguito da un utente normale; alcune dimostrazioni che
# richiedono privilegi (es. sudo) vengono saltate automaticamente.

print_title() {
    printf "\n===== %s =====\n" "$1"
}

# helper: show a labeled command and its output
run() {
    printf "\n$ %s\n" "$*"
    eval "$@" 2>&1 | sed 's/^/    /'
}

# 1) UID ed EUID (reale vs effettivo)
print_title "UID ed EUID (reale vs effettivo)"
# variabili di bash
echo "Variabili di bash:"
echo "  UID   = ${UID-<undefined>}"
echo "  EUID  = ${EUID-<undefined>}"
echo "  PPID  = ${PPID-<undefined>}"
echo "  BASHPID = ${BASHPID-<undefined>}"
run id
run id -u -n   # username dal uid
run id -u      # solo UID numerico
run id -g -n   # gruppo principale (nome)
run id -G      # tutti i GID numerici

cat <<'EOF'
Spiegazione breve:
    - UID   : user id "reale" nel processo (in bash è UID).
    - EUID  : effective UID (diritti effettivi). Un eseguibile con setuid cambia l'EUID.
    - id mostra UID/EUID e gruppi. "whoami" equivale a id -un.
EOF

run whoami

# 2) PID, PPID, BASHPID, $! (background job)
print_title "PID, PPID, BASHPID e $!"
echo "Variabili della shell corrente:"
echo "  PID della shell (\$\$)       = $$"
echo "  BASHPID (PID del processo bash corrente) = ${BASHPID-<n/a>}"
echo "  PPID (parent PID)           = ${PPID-<n/a>}"

# background: mostrare $! (PID dell'ultimo job in background)
echo
echo "Esempio: avvio un 'sleep 3' in background e mostro \$!"
sleep 0.2
sleep 3 &
bgpid=$!
echo "    PID del job background (\$!) = $bgpid"
# mostrare info di processo con ps
run ps -o pid,ppid,pgid,sid,tty,stat,comm -p $$,$bgpid

# attendere il termine del background prima di proseguire (pulizia)
wait "$bgpid" 2>/dev/null || true

# 3) PGID (process group id) e SID (session id), TPGID
print_title "PGID (process group) e SID (session) e TPGID (foreground pgid del terminale)"
# per la shell corrente
my_pid=$$
run ps -o pid,ppid,pgid,sid,tty,tpgid,comm -p "$my_pid"

cat <<'EOF'
Spiegazione:
    - PGID: ogni processo appartiene a un process group; i segnali del terminale sono inviati al process group.
    - SID: session id; un insieme di process group. 'setsid' crea una nuova sessione.
    - TPGID: l'ID del process group in primo piano del terminale (se terminale disponibile).
EOF

# dimostrazione di setsid (crea nuova sessione)
print_title "Esempio: avvio di un processo in una nuova sessione con setsid"
if command -v setsid >/dev/null 2>&1; then
    # avvia sleep in una nuova sessione; non vogliamo bloccare la shell
    setsid sleep 30 >/dev/null 2>&1 &
    sidpid=$!
    echo "    PID del processo lanciato con setsid = $sidpid"
    run ps -o pid,ppid,pgid,sid,tty,tpgid,comm -p "$sidpid"
    # lo uccidiamo subito per non lasciare processi in background
    kill "$sidpid" >/dev/null 2>&1 || true
else
    echo "    setsid non disponibile: salto questa dimostrazione"
fi

# 4) Esempio: exec e fork (sostituzione vs nuovo processo)
print_title "exec vs fork (sostituzione vs nuovo processo)"
echo "Esecuzione di 'bash -c \"echo PID=\$\$; sleep 0.5\"' crea un nuovo processo:"
run bash -c 'echo "    inside subshell: PID=$$"; sleep 0.5'
echo "Eseguendo 'exec' si sostituisce il processo corrente (come demo in una sottoshell):"
run bash -c 'exec echo "    after exec: this replaced the shell (PID still shown by caller)"; echo "    (this line non verrà eseguita)"'

# 5) setuid / setgid bits (attenzione)
print_title "setuid / setgid bits (mostrati via stat)"
tmpf="$(mktemp /tmp/demo_setuid.XXXXXX)"
echo 'echo "hello from demo"' > "$tmpf"
chmod 755 "$tmpf"
echo "File creato: $tmpf"
run stat -c '%A %u %g %n' "$tmpf" 2>/dev/null || run stat -f '%A %u %g %N' "$tmpf" 2>/dev/null
cat <<'EOF'
Nota:
    - Il bit setuid (u+s) cambia l'EUID quando il file è un eseguibile binario eseguibile da utente.
    - Su molti sistemi il setuid sui script shell viene ignorato per motivi di sicurezza.
    - Operazioni di chown/chmod che richiedono root non vengono eseguite automaticamente da questo script.
EOF
# pulizia file demo
rm -f "$tmpf"

# 6) Dimostrazione pratica: cambiare utente (se sudo è disponibile)
print_title "Esempio: mostrare differenza reale/effettivo usando sudo -u (se disponibile)"
if command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
    echo "Esegue 'sudo -u nobody id' (nessuna password richiesta):"
    run sudo -u nobody id
else
    echo "Non posso eseguire 'sudo' senza password in modo sicuro qui; per provarlo usa:"
    echo "  sudo -u nobody id"
fi

# 7) riepilogo
print_title "Riepilogo rapido"
cat <<'EOF'
- UID: id numerico dell'utente (reale).
- EUID: id con cui il processo viene eseguito (permessi effettivi).
- GID/GROUPS: gruppo principale e gruppi supplementari.
- PID: identificatore del processo ($$ per la shell).
- PPID: parent PID.
- PGID: process group id (utile per segnali e job control).
- SID: session id (setsid crea una nuova sessione).
- TPGID: process group in foreground del terminale.
EOF

echo
echo "Fine dimostrazione."
#exit 0

#### $!
#PID (Process ID) dell'ultimo comando eseguito in backgorund (&).
sleep 30 &
echo "PID del processo sleep in background: $!"

#### $$
#PID della shell corrente.
echo "PID della shell corrente: $$"

#### $_
#Ultimo argomento dell'ultimo comando eseguito.
echo "Ultimo argomento dell'ultimo comando eseguito: $_"

#### $BASHPID
#PID della shell bash corrente (diverso da $$ in caso di subshell).
echo "BASHPID della shell corrente: $BASHPID"

#### $PPID
#PID del processo padre della shell corrente.
echo "PPID (Parent PID) della shell corrente: $PPID"
#il processo padre di una shell è generalmente il terminale o la shell da cui è stata lanciata.