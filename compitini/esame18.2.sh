#!/bin/bash

NOME_DIR=$1
echo nome directory: $NOME_DIR

HASH_STUTTURA_DIR=$(find $NOME_DIR | md5sum | cut -d " " -f1)

echo hash struttura directory: $HASH_STUTTURA_DIR

HASH_CONTENUTO_DIR=$(find $NOME_DIR -type f | xargs md5sum | md5sum | cut -d " " -f1)

echo hash contenuto directory: $HASH_CONTENUTO_DIR

echo stringa di controllo: $HASH_STUTTURA_DIR$HASH_CONTENUTO_DIR

