#!/bin/bash

BASEDIR=$1  # E.g.: ~/src/v8
OUTDIR=$2   # E.g.: ~/src/v8/out/release

rsync -c --progress $OUTDIR/obj/libv8_monolith.a lib/
rsync -cr --progress --include='*/' --include='*.h' --exclude='*' $BASEDIR/include .
