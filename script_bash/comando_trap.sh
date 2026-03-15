#!/bin/bash
# ==============================================================================
# SCRIPT DIMOSTRATIVO: USO DEL COMANDO TRAP IN BASH
# Prof. F. Tommasi - Corso di Sistemi Operativi
# ==============================================================================    
echo "############################################################"
echo "### Spiegazione del Comando TRAP in Bash                ###"
echo "############################################################"
echo ""
echo "Il comando 'trap' permette di eseguire comandi specifici quando"
echo "lo script riceve determinati segnali (ad esempio, SIGINT, SIGTERM)."
echo "Questo è utile per gestire la pulizia delle risorse o per eseguire"
echo "azioni specifiche prima che lo script termini."
echo ""
# --- SINTASSI BASE ---
echo "### 1. Sintassi del Comando TRAP ###"
echo "La sintassi generale è:"
echo "trap 'comandi_da_eseguire' segnali"
echo ""
echo "Esempi:"
trap 'echo \"Script interrotto! Pulizia in corso...\"' SIGINT SIGTERM # Esegue il comando quando riceve SIGINT o SIGTERM
echo "------------------------------------------------------------"
#ESEMPIO PRATICO ---
echo ""echo "### 2. Esempio Pratico di TRAP ###"
echo "In questo esempio, lo script cattura il segnale SIGINT (Ctrl+C)"
echo "e esegue una pulizia prima di terminare."
echo ""
# Definizione della funzione di pulizia
pulizia() {
    echo "Esecuzione della pulizia delle risorse..."
    # Aggiungi qui i comandi di pulizia necessari
    echo "Pulizia completata. Uscita dallo script."
    exit 0
}
# Impostazione del trap per SIGINT
trap pulizia SIGINT
echo "Esegui lo script. Premi Ctrl+C per interromperlo e vedere il trap in azione."
#Esempio con Ctrl+Z
trap 'echo "Ricevuto segnale SIGTSTP. Sospensione in corso..."; exit 0' SIGTSTP
#Esempio con SIGTERM avviene quando si usa il comando kill
trap 'echo "Ricevuto segnale SIGTERM. Terminazione in corso..."; exit 0' SIGTERM
# Simulazione di un processo lungo
while true; do
    echo "Script in esecuzione... Premi Ctrl+C per interrompere."
    sleep 5
done
echo "------------------------------------------------------------"
echo ""
# --- CONCLUSIONI ---
echo "### 3. Conclusioni ###"
echo "Il comando 'trap' è uno strumento potente per gestire i segnali"
echo "in uno script Bash, permettendo di eseguire azioni specifiche"
echo "prima che lo script termini. Utilizzalo per migliorare la robustezza"
echo "dei tuoi script!"
echo "############################################################"
echo ""
#Trap con debug
echo "### 4. Uso di TRAP per il Debug ###"
echo "Puoi usare 'trap' per catturare errori e fare il debug dello script."
echo "Ad esempio, puoi catturare il segnale ERR per eseguire comandi quando si verifica un errore."
echo ""
# Impostazione del trap per ERR
trap 'echo "Errore rilevato nello script alla riga $LINENO"' ERR
echo "Esempio di comando che genera un errore:"
# Comando che genera un errore (divisione per zero)
echo $((1/0))
echo "------------------------------------------------------------"
echo ""
echo "Fine dello script dimostrativo sul comando TRAP."
echo "############################################################"
