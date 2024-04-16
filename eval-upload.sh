#!/usr/bin/env sh

# Uploads the files to the FM server.

PROJ_ROOT="ext/llm_test/"

# echo "Uploading scripts"

rsync --progress -p "eval-esbmc.sh" "fm05:$PROJ_ROOT"
rsync --progress -p "eval-get-verdict.sh" "fm05:$PROJ_ROOT"

echo "Uploading includes"

rsync --progress -r "includes" "fm05:$PROJ_ROOT"

echo "Uploading samples-patched"

rsync --progress -r "samples-patched" "fm05:$PROJ_ROOT"

echo "Uploading samples-patched-single"

rsync --progress -r "samples-patched-single" "fm05:$PROJ_ROOT"

echo "Uploading samples-patched-2"

rsync --progress -r "samples-patched-2" "fm05:$PROJ_ROOT"
