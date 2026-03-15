#!/bin/bash

# percorso assoluto dello script
SCRIPT_PATH="$(realpath "$0")"

# il filesystem in cui si trova lo script
FS_MOUNT_POINT=$(df --output=target "$SCRIPT_PATH" | tail -1)

# trova il numero di inode utilizzati in quel filesystem
INODES_USATI=$(df -i --output=iused "$FS_MOUNT_POINT" | tail -1)

echo "Filesystem: $FS_MOUNT_POINT"
echo "Inodes utilizzati: $INODES_USATI"
