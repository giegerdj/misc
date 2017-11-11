#!/bin/sh
echo "Running..."

PROG=$0
HOME="/Users/dave/"
RSYNC="/usr/local/bin/rsync"
RSYNC_DEST="/Volumes/macos-rsync/"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $DIR;
if [ $# -eq 0 ] ; then
    echo "No arguments supplied"
    exit 1;
fi

DEST_FOLDER=${1}

# rsync options
# -v increase verbosity
# -a turns on archive mode (recursive copy + retain attributes)
# -x don't cross device boundaries (ignore mounted volumes)
# -E preserve executability
# -S handle spare files efficiently
# --delete delete deletes any files that have been deleted locally
# --exclude-from reference a list of files to exclude

echo "Start rsync"

$RSYNC -vaE -S --progress --human-readable --force --delete --fake-super --exclude-from=$SCRIPT_DIR/excludes.txt $HOME $RSYNC_DEST$DEST_FOLDER

echo "End rsync"

exit 0
