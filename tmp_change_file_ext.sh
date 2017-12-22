#!/bin/sh
# tmpextch -- Temporarily change the file extensions of files. The original file names can later be restored.
# written by TS


APPTAG="[TMPEXTCH]"
SEARCH_DIR="."
ORIGINAL_EXTENSION="jsx"
TEMP_EXTENSION="js"
MODIFIED_FILES_LIST="./renamed_files.lst"

if [ "$1" = "--rename" ]; then
    if [ -f "$MODIFIED_FILES_LIST" -a ! "$2" = "--force" ]; then
        echo "$APPTAG WARNING: File list already exists at '$MODIFIED_FILES_LIST'. Re-running this script will erase the old file list. Add --force parameter to force this."
        exit 1
    fi
    if [ ! -f "$MODIFIED_FILES_LIST" ]; then
        touch "$MODIFIED_FILES_LIST"
    fi
    if [ ! -w "$MODIFIED_FILES_LIST" ]; then
        echo "$APPTAG File list nto writable."
        exit 1
    fi
    find "${SEARCH_DIR}" -type f -name *.${ORIGINAL_EXTENSION} > ${MODIFIED_FILES_LIST}
    
    for ORIG_FILE in $(cat "${MODIFIED_FILES_LIST}"); do
        ORIG_FILE_NO_EXT=${ORIG_FILE%.*}
        NEW_FILE=${ORIG_FILE_NO_EXT}.${TEMP_EXTENSION}
        echo "$APPTAG Handling file '$ORIG_FILE', renaming to '$NEW_FILE'."
        mv "$ORIG_FILE" "$NEW_FILE"
    done
    
    echo "$APPTAG Files renamed (see list in ${MODIFIED_FILES_LIST} if you care.)"
elif [ "$1" = "--restore" ]; then
    if [ ! -f "$MODIFIED_FILES_LIST" ]; then
        echo "$APPTAG ERROR: File list does not exist at '$MODIFIED_FILES_LIST'."
        exit 1
    fi
    for ORIG_FILE in $(cat "${MODIFIED_FILES_LIST}"); do
        ORIG_FILE_NO_EXT=${ORIG_FILE%.*}
        NEW_FILE=${ORIG_FILE_NO_EXT}.${TEMP_EXTENSION}
        RESTORED_FILE=${ORIG_FILE_NO_EXT}.${ORIGINAL_EXTENSION}
        echo "$APPTAG Restoring file '$NEW_FILE' to its original name '$RESTORED_FILE'."
        mv "$NEW_FILE" "$RESTORED_FILE"
    done
else
    echo "$APPTAG Usage: $0 --rename | --restore [--force]"
    exit 1
fi
