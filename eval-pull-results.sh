#!/usr/bin/env sh

# Uploads the files to the FM server.

PROJ_ROOT="ext/llm_test/"

echo "Downloading esbmc_output_1"

rsync --progress -r "fm05:$PROJ_ROOT/esbmc_output_1" "."

echo "Downloading esbmc_output_single"

rsync --progress -r "fm05:$PROJ_ROOT/esbmc_output_single" "."

echo "Downloading esbmc_output_2"

rsync --progress -r "fm05:$PROJ_ROOT/esbmc_output_2" "."

