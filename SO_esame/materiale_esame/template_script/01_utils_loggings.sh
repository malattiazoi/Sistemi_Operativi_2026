#!/bin/bash

# ==============================================================================
# UTILS: LOGGING & OUTPUT GRAFICO (MACOS COMPATIBLE)
# ==============================================================================
# OBIETTIVO:
# Fornire funzioni standard per stampare messaggi di Info, Errore, Successo e Warning.
# Gestire l'uscita forzata dallo script in caso di errore critico.
#
# COME USARLO:
# Copia queste funzioni all'inizio del tuo script d'esame.
# Poi usa: log_info "Messaggio" o die "Errore grave"
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. DEFINIZIONE COLORI (ANSI ESCAPE CODES)
# ------------------------------------------------------------------------------
# tput è il comando più sicuro su Mac per ottenere i codici colore.
# Se tput fallisce (terminale dumb), usa stringhe vuote.

BOLD=$(tput bold 2>/dev/null || echo "")
RED=$(tput setaf 1 2>/dev/null || echo "")
GREEN=$(tput setaf 2 2>/dev/null || echo "")
YELLOW=$(tput setaf 3 2>/dev/null || echo "")
BLUE=$(tput setaf 4 2>/dev/null || echo "")
RESET=$(tput sgr0 2>/dev/null || echo "")

# ------------------------------------------------------------------------------
# 2. FUNZIONI DI LOGGING
# ------------------------------------------------------------------------------

# Stampa un messaggio informativo (Blu)
# Uso: log_info "Stiamo iniziando il backup..."
log_info() {
    local MSG="$1"
    # printf è meglio di echo perché gestisce formattazione e newline (\n) in modo sicuro
    printf "${BLUE}[INFO]${RESET} %s\n" "$MSG"
}

# Stampa un messaggio di successo (Verde)
# Uso: log_success "Operazione completata."
log_success() {
    local MSG="$1"
    printf "${GREEN}[OK]${RESET}   %s\n" "$MSG"
}

# Stampa un avviso (Giallo)
# Uso: log_warning "Spazio disco basso."
log_warning() {
    local MSG="$1"
    printf "${YELLOW}[WARN]${RESET} %s\n" "$MSG"
}

# Stampa un errore (Rosso) - NON ESCE DALLO SCRIPT
# Uso: log_error "File non trovato, provo il prossimo..."
log_error() {
    local MSG="$1"
    # >&2 redirige su STDERR (Standard Error), buona pratica Unix
    printf "${RED}[ERR]${RESET}  %s\n" "$MSG" >&2
}

# ------------------------------------------------------------------------------
# 3. GESTIONE USCITA (DIE)
# ------------------------------------------------------------------------------

# Stampa un errore rosso ed ESCE dallo script con codice di errore 1.
# Fondamentale per bloccare tutto se manca qualcosa di critico.
# Uso: [ -f "file" ] || die "File mancante!"
die() {
    local MSG="$1"
    local CODE="${2:-1}" # Codice di uscita (default 1 se non specificato)
    
    printf "${RED}${BOLD}[FATAL] %s${RESET}\n" "$MSG" >&2
    exit "$CODE"
}

# ------------------------------------------------------------------------------
# ESEMPIO DI UTILIZZO (Test)
# ------------------------------------------------------------------------------
# Decommenta le righe sotto per provare
# log_info "Avvio script..."
# log_success "Connessione stabilita."
# log_warning "La batteria è scarica."
# log_error "Impossibile scrivere il log."
# die "Errore critico, mi fermo qui."