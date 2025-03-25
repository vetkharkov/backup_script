#!/bin/bash
# -----------------------------
# Linux script backup folder  |   
#                             |
# Author: Vitaliy Bindyug     |
# -----------------------------

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

CONFIG_FILE_JSON="backup_config.json"

# Проверка наличия программы jq
if ! command -v jq &> /dev/null; then
   echo -e "${RED}Error: jq is not installed ${ENDCOLOR}"
   echo "Please install jq"
   echo "sudo apt install jq"
   exit 1
fi

BACKUP_COUNT=$(jq ".backups | length" "$CONFIG_FILE_JSON")

for ((i=0; i<BACKUP_COUNT; i++)); do
    BACKUP_NAME=$(jq -r ".backups[$i].backup_name" "$CONFIG_FILE_JSON")
    SOURCE_FOLDER=$(jq -r ".backups[$i].source_folder" "$CONFIG_FILE_JSON")
    TARGET_FOLDER=$(jq -r ".backups[$i].target_folder" "$CONFIG_FILE_JSON")
    
    echo -e "---${GREEN}START BACKUP: $BACKUP_NAME ${ENDCOLOR}"

    if [ ! -d "$SOURCE_FOLDER" ]; then
       echo -e "${RED}Skipping $BACKUP_NAME: Source folder $SOURCE_FOLDER does not exist.${ENDCOLOR}"
       continue # i++
    fi

    if [ ! -d "$TARGET_FOLDER" ]; then
       echo -e "${RED}Skipping $BACKUP_NAME: Target folder $TARGET_FOLDER does not exist.${ENDCOLOR}"
       echo -e "${GREEN}-CREATING FOLDER: $TARGET_FOLDER ${ENDCOLOR}"
       mkdir -p $TARGET_FOLDER
    fi

    TIMESTAMP=$(date +'%Y-%m-%d_%H:%M:%S')
    BACKUP_FILE="$TARGET_FOLDER/$BACKUP_NAME-$TIMESTAMP.tar.gz"

    echo -e "Backing up $SOURCE_FOLDER to $BACKUP_FILE"
    tar -czf "$BACKUP_FILE" -C "$SOURCE_FOLDER" .
    if [ $? -eq 0 ]; then
       echo -e "${GREEN}BACKUP SUCCESSFULLY${ENDCOLOR}"
    else
       echo -e "${RED}BACKUP FAILED${ENDCOLOR}"
    fi

    echo -e "---${GREEN}BACKUP FINISH${ENDCOLOR}"
done




