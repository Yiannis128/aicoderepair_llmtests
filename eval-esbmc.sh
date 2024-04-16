#!/usr/bin/env sh

# The following script will execute ESBMC on the machine.

INPUT_DIR="samples-patched-2"
OUTPUT_DIR="esbmc_output_2"

ESBMC_PARAMS="--interval-analysis --goto-unwind --unlimited-goto-unwind --incremental-bmc --state-hashing --add-symex-value-sets --k-step 2 --floatbv --unlimited-k-steps --memory-leak-check --context-bound 2 --timeout 300 -Iincludes -Inetworks"

mkdir -p "$OUTPUT_DIR"

touch "processed.txt"

sample_idx=0
for name in $(ls "$INPUT_DIR"); do
	# Check if we have already processed the file and skip
	if [ "$name" = "$(grep -w "$name" 'processed.txt')" ]; then
		echo "Skipping $sample_idx $name"
		sample_idx="$(expr $sample_idx + 1)"
		continue
	fi
	echo "Checkpoint $sample_idx: $name"
	# Run ESBMC and time it.
	(time esbmc $ESBMC_PARAMS "$INPUT_DIR/$name") 2>&1 | tee "$OUTPUT_DIR/$name"
	# Write current progress
	echo "$name" >> processed.txt
	sample_idx="$(expr $sample_idx + 1)"
done

echo "Finished all files"

