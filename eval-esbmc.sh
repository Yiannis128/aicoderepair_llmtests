#!/usr/bin/env sh

# The following script will execute ESBMC on the machine.

ESBMC_PARAMS="--interval-analysis --goto-unwind --unlimited-goto-unwind --incremental-bmc --state-hashing --add-symex-value-sets --k-step 2 --floatbv --unlimited-k-steps --memory-leak-check --context-bound 2 --timeout 300 -Iincludes -Inetworks"

mkdir -p "esbmc_output"

touch "processed.txt"

sample_idx=0
for name in $(ls samples-patched); do
	# Check if we have already processed the file and skip
	if [ "$name" = "$(grep $name 'processed.txt')" ]; then
		echo "Skipping $sample_idx $name"
		sample_idx="$(expr $sample_idx + 1)"
		continue
	fi
	echo "Checkpoint $sample_idx: $name"
	# Run ESBMC and time it.
	(time esbmc $ESBMC_PARAMS "samples-patched/$name") 2>&1 | tee "esbmc_output/$name"
	# Write current progress
	echo "$name" >> processed.txt
	sample_idx="$(expr $sample_idx + 1)"
done

echo "Finished all files"

