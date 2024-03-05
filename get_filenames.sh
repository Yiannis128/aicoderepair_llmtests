#!/usr/bin/env sh

# Prints all the filenames of the esbmc_output generated.

ssh $DATA_SERVER_LOGIN -T <<"EOF"
cd ext/plain_nn/esbmc_output/
find . -type f -name "*.c*" -exec grep -l "VERIFICATION FAILED" {} \; | sed 's/\.stdout\.txt$//'
EOF
