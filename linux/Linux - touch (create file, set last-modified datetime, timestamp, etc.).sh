#!/bin/sh
# ------------------------------------------------------------
# Linux - touch (create file, set last-modified datetime, timestamp, etc.)
# ------------------------------------------------------------
#
# Create an empty file
#

touch "example.txt";


# ------------------------------------------------------------
#
# Set the last-modified datetime/timestamp for a file
#

# Set last-modified datetime using input format:  YYYY-MM-DD HH:MM:SS
touch -d "$(date -R --date='2018-10-01 14:54:22';)" "example.txt";


# Set last-modified datetime using input format:  @Unix-Seconds (Epoch Seconds)
touch -d "$(date -R --date='@1539785880';)" "example.txt";


# Set last-modified datetime using input format:  iso-8601
touch -d "$(date -R --date='2018-10-01T14:54:22,384929728-04:00';)" "example.txt";


# Set last-modified datetime - Parameterized example
if [[ 1 -eq 1 ]]; then
FILEPATH_TO_UPDATE="example.txt";  # Target filepath to update
DATE_LAST_MODIFIED="3000-12-31 23:59:59";  # Timestamp to set modified date to
touch -m -a -t "$(date --utc --date="${DATE_LAST_MODIFIED}" +'%Y%m%d%H%M.%S';)" "${FILEPATH_TO_UPDATE}";
stat --printf="%y  %n\n" "${FILEPATH_TO_UPDATE}";
fi;


# ------------------------------------------------------------
#
# Citation(s)
#
#   linux.die.net  |  "touch(1): change file timestamps - Linux man page"  |  https://linux.die.net/man/1/touch
#
# ------------------------------------------------------------