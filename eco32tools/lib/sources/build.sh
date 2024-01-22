#!/bin/bash

# This script builds the spl library binary file libsplrts.a as well as the startup module start.o

cd $(dirname $0)
SRCDIR=$(pwd)

BIN_DIR="$SRCDIR/../../bin"

# Assemble all .s-Files to object code
for f in ./*.s; do
    [ -f "$f" ] || break

    $BIN_DIR/as -o "${f%.s}.o" $f
done;

# Move start.o to the parent directory 'lib'.
mv start.o "$SRCDIR/"

# Bundle all other .o files to the spl library
$BIN_DIR/ar -cv "$SRCDIR/../libsplrts.a" *.o