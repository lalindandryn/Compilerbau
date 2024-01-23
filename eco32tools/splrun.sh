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

without_extension="${spl_file_path%.*}"

SCRIPTDIR=$(dirname "$0")

"$SCRIPTDIR/compile.sh" $@ || exit

if ! "$phase_option"; then
    "$SCRIPTDIR/run.sh" "$without_extension.bin"
fi
