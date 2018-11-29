#!/bin/sh
#
# Enter Brief description of script
#

#
# Changelog
# v1.0 kerst1 06/01/16 - Original version
#

#
# Versioning Info called by -v flag
#
VERSION="1.0"
LASTUPDATE="NOV 28 2018"
OWNER="Eduardo Janicas ejanicas@amazon.com"

#
# Exit Codes - Optional but useful
#
# 1 = Not root
# 3 = Wrong Usage
# 5 = -v Version Number
# 10 = xxx
# 15 = xxx

#
# Set PATH - Edit as required
#
PATH=/usr/bin:/usr/sbin:/bin:/sbin:/etc:/usr/local/bin
export PATH

#
#Optional Debug - uncomment to enable debugging
#
#set -x

#
# Set Default Flags that may be chaged by flags in command line
#
BACREC=NOTSM

#
# VERSION Function w/exit code
#
version_num () {
    echo "--- Running Script = `basename $0` ---"
    echo "--- Version = $VERSION ---"
    echo "--- Last Updated on $LASTUPDATE ---"
    echo "--- Written by $OWNER ---"
    exit 5
}

#
# Usage Statement Example - Function
#
#
# [-xyz] Options without operands - may be case sensitive if desired
# [-c US|UK] Options with exclusive operands US or UK
# args Argument(s) If required use req1 or req_arg - may be more than one
#
usage () {
  echo "usage: $(basename $0) USER PUT|GET filepath"
  echo " -h = Displays USAGE Statement aka help"
  echo " -v = Displays VERSION Information"
  echo " filepath = Enter the path of the file to PUT|GET"
  echo " PRE = Pre-build checks"
  echo " VER = Verify Settings"
  echo " AUD = Perform Audit Checks"
  echo " Example"
  echo " `basename $0` ejanicas GET WhyDoYouGoBird.logicx"
  exit 3
}

#
# GETOPTS - Adjust based on required flags for script
#
# x: flag x has required variable OPTARG (COLON = Required OPTARG)
# v flag v no variable argument - may set variable
#
# Note - flag options are nonsense and used as examples only
# Edit as requried
#
while getopts hv OPTIONS
do
    case "$OPTIONS"
    in
        v) version_num ;;
        h) usage ;;
        *) usage ;;
    esac
done

#
# Verify Options
#
# argc - argument count / argv - argument array
# OPTIND - Index of next element to be processed by argv. Intialized to 1
# $# is number of parameter passed on command line to script
# $* & $@ - all command line arguments - double quoted output on one line
# No quotes output is on separate lines
# $* - entire list one arg with spaces
# $@ - entire list separated into separate args
# $? - Exit status / typical 0 = success 1 = failure / other values may exist
#
if [ "$OPTIND" -gt "$#" ]
then
    usage
    exit 3
fi

#
# Shift removes N strings from posistional parameters list. Removes all options
# parsed by getopts so that $1 will refer to FIRST NON-OPTION argument passed to script
#
shift `expr $OPTIND - 1`

#
# Translate varibles to use all UPPER CASE
# Just examples from various scripts
#
OSTYPE=`uname -s`
# Set SITE based on $1 - shift has taken place
USER="$1"
MODE="$2"
FILE="$3"

#
# MAIN LOGIC GOES HERE
#
echo "Username: ${USER}"
echo "Mode: ${MODE}"
echo "${FILE}"

if [ $MODE == "GET" ]
then
    sftp -r ${USER}@s-716883d9badc4db19.server.transfer.eu-west-1.amazonaws.com:${FILE} ${FILE}
elif [ $MODE == "PUT" ]
then
    sftp ${USER}@s-716883d9badc4db19.server.transfer.eu-west-1.amazonaws.com:${FILE} <<< $"put -r $FILE"
else
   echo "None of the condition met"
fi

#
# OPERATORS
#
# Some of the operators string and file that I forget about and
# just some useful stuff as well
#
# String tests (double quote variables to avoid issues)
# STRING='' # NULL
# -z // Checks string is NULL - TRUE if string is EMPTY (false NOT null)
# -n // Checks string is NOT NULL - TRUE if string is NOT EMPTY (false if null)
# File Tests
# -f // true if file exits and is regular file
# -d // true if file exists and is a directory
# true if file exists and is // -c char special file // -b block // -p pipe // -S socket
# true if file exists and is // -g sgid bit set // -u suid bit set
# true if file exists and is // -r readable // -x executable // -w writeable
# -s // true if file exists and bigger than 0 not empty
# if [ $X != $Y ] X NOT EQUAL Y
# if [ ! -d /path/to/dir ] Directory does NOT Exist
# if [ ! -f /path/to/file ] FILE does NOT Exist
#EOF
