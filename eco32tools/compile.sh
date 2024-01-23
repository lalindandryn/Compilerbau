#!/bin/bash

options=""
spl_file_path=""
phase_option=false

# Iterate command line arguments to extract file path and compiler options
for ((i = 1; i <= "$#"; i++)); do
    arg="${!i}"

    if [[ $arg = --* ]]; then
        case "$arg" in
        "--tokens") ;&
        "--absyn") ;&
        "--tables") ;&
        "--semant") ;&
        "--vars")
            phase_option=true
            ;;
        esac

        options="$options $arg"
    else
        if [ -z "${VAR}" ]; then
            spl_file_path="$arg"
        fi
    fi
done

without_extension=${spl_file_path%.*}

SCRIPTDIR=$(dirname "$0")
BIN="$SCRIPTDIR"/bin
LIB="$SCRIPTDIR"/lib

function fail() {
    echo "$1"
    exit 1
}

$BIN/refspl "$spl_file_path" $options "$without_extension.s" || fail "Compilation failed"

if ! "$phase_option"; then
    $BIN/as -o "$without_extension.o" "$without_extension.s" || fail "Assembly failed"
    $BIN/ld -s "$LIB/stdalone.lnk" "-L$LIB" -o "$without_extension.x" "$LIB/start.o" "$without_extension.o" -lsplrts || fail "Linking failed"
    $BIN/load "$without_extension.x" "$without_extension.bin" || fail "Loading failed"
fi
