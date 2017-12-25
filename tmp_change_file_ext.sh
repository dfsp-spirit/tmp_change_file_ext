#!/bin/bash
# tmpextch -- Temporarily change the file extensions of files. The original file names can later be restored.
# written by TS

### Settings -- Adapt these to your needs

APPTAG="[TMPEXTCH]"
SEARCH_DIR="."
ORIGINAL_EXTENSION="jsx"
TEMP_EXTENSION="js"
MODIFIED_FILES_LIST="$HOME/.renamed_files.lst"

### There should be no need to modify stuff below this line.

### Functions

function show_help {
    echo "$APPTAG USAGE: $0 -c <options> [-f]"
    echo "$APPTAG USAGE: $0 -r <options>"
    echo "$APPTAG USAGE: $0 -h"
	echo "$APPTAG valid options are:"
	echo "$APPTAG   -c         : change mode (rename files according to settings and create mapping file)"
	echo "$APPTAG   -r         : restore mode (restore previsously renamed files to their original file extensions)"
	echo "$APPTAG   -s <ext>   : set source or original file extension to <ext>. Defaults to 'jsx' if omitted."
	echo "$APPTAG   -t <ext>   : set temporary file extension to <ext>. Defaults to 'js' if omitted."
	echo "$APPTAG   -d <dir>   : set directory to work on to <dir>. Defaults to '.' if omitted."
	echo "$APPTAG   -f         : force action, even if this means overwriting an existing file extension mapping file (only applies to change mode)."
	echo "$APPTAG   -m <file>  : set mapping file location to <file>. Defaults to '~/.renamed_files.lst' if omitted."
	echo "$APPTAG   -h         : show this help and exit"
	echo "$APPTAG EXAMPLES:"
	echo "$APPTAG * Rename all jsx files to js in ~/my_project/:"
	echo "$APPTAG    $0 -c -d ~/my_project/"
	echo "$APPTAG   Restore the file names from the last action:"
	echo "$APPTAG    $0 -r -d ~/develop/my_project/"
    echo "$APPTAG * Rename all txt files to lst in /tmp/doc/:"
	echo "$APPTAG    $0 -c -s txt -t lst -d /tmp/doc/"
	echo "$APPTAG   Restore the file names from the last action:"
	echo "$APPTAG    $0 -r -s txt -t lst -d /tmp/doc/"
} 


# Parse command line args (using getops)

OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize our own variables:

MODE=""
FORCE="FALSE"

while getopts "hcrfs:t:d:" opt; do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    c)  MODE="MODE_RENAME"
        ;;
    r)  MODE="MODE_RESTORE"
        ;;
    f)  FORCE="TRUE"
        ;;
    d) SEARCH_DIR="$OPTARG"
        ;;
    s) ORIGINAL_EXTENSION="$OPTARG"
        ;;
    t) TEMP_EXTENSION="$OPTARG"
       ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift


if [ "$MODE" = "MODE_RENAME" ]; then
    if [ -f "$MODIFIED_FILES_LIST" -a ! "$FORCE" = "TRUE" ]; then
        echo "$APPTAG WARNING: Mapping file already exists at '$MODIFIED_FILES_LIST'. Re-running this script would erase the old file list. Add -f parameter to force this action."
        exit 1
    fi
    if [ ! -f "$MODIFIED_FILES_LIST" ]; then
        touch "$MODIFIED_FILES_LIST"
    fi
    if [ ! -w "$MODIFIED_FILES_LIST" ]; then
        echo "$APPTAG Mapping file or directory at '$MODIFIED_FILES_LIST' not writable."
        exit 1
    fi
    find "${SEARCH_DIR}" -type f -name *.${ORIGINAL_EXTENSION} > ${MODIFIED_FILES_LIST}
    
    for ORIG_FILE in $(cat "${MODIFIED_FILES_LIST}"); do
        ORIG_FILE_NO_EXT=${ORIG_FILE%.*}
        NEW_FILE=${ORIG_FILE_NO_EXT}.${TEMP_EXTENSION}
        echo "$APPTAG Handling file '$ORIG_FILE', renaming to '$NEW_FILE'."
        mv "$ORIG_FILE" "$NEW_FILE"
    done
    
    echo "$APPTAG Files renamed to temporary extension '${TEMP_EXTENSION}', see list in ${MODIFIED_FILES_LIST} for details."
elif [ "$MODE" = "MODE_RESTORE" ]; then
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

    NUM_FILES=$(wc -l $MODIFIED_FILES_LIST | awk '{print $1}')
    echo "$APPTAG Restored $NUM_FILES files to their original file extension '${ORIGINAL_EXTENSION}'."
    rm "$MODIFIED_FILES_LIST"
else
    show_help
    exit 1
fi
