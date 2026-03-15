#!/bin/bash

#scrivere uno script che prende in imput una directory e:
#1 verifica che esiste
#2 cerca tutti i file tipo .log
#3 per ogni file: 
#	controlla se contiene la parole "FATAL"
#	se la contiene stampa nome file e quante volte c'è la parola
#	rinomino il "file.log" con il suffisso DANGER "file_DANGER.log"
#	se non ci sono file log non deve dare errori particolari

if [ $# -lt 1 ]; then
	echo "ERRORE: inserire directory da analizzare"
	echo "[UTILIZZO]: ./directory_file_check.sh nome_directory"
	exit 1
fi

DIR=$1

if [ ! -d "$DIR" ]; then
	echo "ERRORE: '$DIR' non è una directory"
	exit 1
fi 

echo "Analisi log in corso..."

shopt -s nullglob 
#praticamente shopt -s attiva nullglob che quanto viene trovato il nulla 
#non restituisce niente, senza attivarlo restituisce l'asterisco null.

for FILE in "$DIR"/*.log; do
	#controllo di sicurezza o FILE è un file o salta
	[ -f $FILE ] || continue
	
	#grep -c conta tutto e da il conto, con -q sarebbe quiet 0 se non trova
	#1 se trova quindi meglio per gli if
	COUNT=$(grep -c "FATAL" "$FILE")

	if [ "$COUNT" -gt 0 ]; then
		echo "Trovato $FILE con $COUNT errori FATAL."
		
		#calcolo nuovo nome ${FILE%.*} prende il nome senza estensione
		#${FILE##*.} prende l'estensione
		BASE_NAME="${FILE%.*}"
		EXTENSION="${FILE##*.}"
		NEW_NAME="${BASE_NAME}_DANGER.${EXTENSION}"
		
		#rinomino
		mv "$FILE" "$NEW_NAME"
		echo "Rinominato -> $NEW_NAME"
	fi
done

shopt -u nullglob #unset nullglob
echo "the end"











# #!/bin/bash

# # ==============================================================================
# # UTILS (Copia-Incolla)
# # ==============================================================================

# log_info() { echo "[INFO] $1"; }
# log_warn() { echo "[WARN] $1"; }

# check_args() {
#     if [ "$1" -lt "$2" ]; then
#         echo "[ERRORE] Argomenti insufficienti. $3" >&2
#         exit 1
#     fi
# }

# check_dir() {
#     if [ ! -d "$1" ]; then
#         echo "[ERRORE] La directory '$1' non esiste." >&2
#         exit 1
#     fi
# }

# # Funzione per manipolare estensioni (simil utils_files.sh)
# add_suffix() {
#     local FILE="$1"
#     local SUFFIX="$2"
#     local BASE="${FILE%.*}"
#     local EXT="${FILE##*.}"
#     echo "${BASE}${SUFFIX}.${EXT}"
# }

# # ==============================================================================
# # MAIN
# # ==============================================================================

# check_args $# 1 "Uso: ./script.sh <cartella>"

# TARGET_DIR="$1"
# check_dir "$TARGET_DIR"

# log_info "Scansione directory: $TARGET_DIR"

# shopt -s nullglob

# for LOG_FILE in "$TARGET_DIR"/*.log; do
#     # Salto se per caso non è un file regolare
#     [ -f "$LOG_FILE" ] || continue

#     # Conto le occorrenze
#     OCCORRENZE=$(grep -c "FATAL" "$LOG_FILE")

#     if [ "$OCCORRENZE" -gt 0 ]; then
#         log_warn "File infetto: $LOG_FILE ($OCCORRENZE errori)"
        
#         # Calcolo nome usando la funzione helper
#         NUOVO_NOME=$(add_suffix "$LOG_FILE" "_DANGER")
        
#         mv "$LOG_FILE" "$NUOVO_NOME"
#         log_info "Rinominato in: $NUOVO_NOME"
#     fi
# done

# shopt -u nullglob
# log_info "Operazione completata."

# #!/bin/bash

# # Imports
# source ./_UTILS/utils_logging.sh
# source ./_UTILS/utils_checks.sh
# source ./_UTILS/utils_files.sh

# # Setup
# check_args $# 1 "Directory richiesta"
# DIR="$1"

# # Verifica directory (se non hai check_dir nelle utils, usa il test manuale o aggiungilo)
# if [ ! -d "$DIR" ]; then die "Directory non trovata"; fi

# log_info "Inizio scansione logs..."

# shopt -s nullglob
# for FILE in "$DIR"/*.log; do
#     [ -f "$FILE" ] || continue

#     # Logica di business
#     if grep -q "FATAL" "$FILE"; then
#         # grep -c per il conteggio da mostrare
#         NUM=$(grep -c "FATAL" "$FILE")
#         log_warning "Trovato 'FATAL' ($NUM volte) in $FILE"
        
#         # Manipolazione stringa manuale o via funzione se l'avessimo creata
#         # Usiamo bash standard qui per velocità
#         NEW_NAME="${FILE%.*}_DANGER.${FILE##*.}"
        
#         mv "$FILE" "$NEW_NAME"
#         log_success "Rinominato -> $NEW_NAME"
#     fi
# done
# shopt -u nullglob