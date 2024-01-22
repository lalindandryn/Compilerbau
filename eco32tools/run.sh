#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters."
    echo "Usage: $0 <path_to_executable_eco32_file>"
    exit 1
fi

SCRIPTDIR=$(dirname "$0")
BIN="$SCRIPTDIR"/bin

display_exists=false

# Check if a display exists.
# DISABLED for now because the graphical options on the simulator were disabled for compatiblity reasons. 
# if command -v xhost > "/dev/null" && xhost >& /dev/null; then display_exists=true; fi

if [ "$display_exists" = true ] ; then
    $BIN/sim -x -l $1 -s 1 -stdt 0 -g
else
    "$BIN/sim" -x -l $1 -s 1 -stdt 0
fi
