#!/usr/bin/env sh

# Gets the verdict and puts it into verdict-1 verdict-single verdict-clang

mkdir -p verdicts

experiments="1 single 2"

for exp in $experiments; do
    echo "Experiment $exp"
    # Finds out how many samples have compiled.
    grep -rl "VERIFICATION\|ERROR: Timed out" "esbmc_output_$exp" > "verdicts/compiles_$exp.txt"
    # Samples that have verified successfully or failed.
    grep -rl "VERIFICATION" "esbmc_output_$exp" > "verdicts/verification_$exp.txt"
    grep -rl "VERIFICATION SUCCESSFUL" "esbmc_output_$exp" > "verdicts/verification_successful_$exp.txt"
    grep -rl "VERIFICATION FAILED" "esbmc_output_$exp" > "verdicts/verification_failed_$exp.txt"
    grep -rl "VERIFICATION UNKNOWN" "esbmc_output_$exp" > "verdicts/verification_unknown_$exp.txt"
    # Samples that have timed out
    grep -rl "ERROR: Timed out" "esbmc_output_$exp" > "verdicts/timeout_$exp.txt"
    # Samples that have had parsing errors.
    grep -rl "ERROR: PARSING ERROR" "esbmc_output_$exp" > "verdicts/parsing_error_$exp.txt"
    # Find anything else missed.
    grep -rL "ERROR: Timed out\|VERIFICATION\|ERROR: PARSING ERROR" "esbmc_output_$exp" > "verdicts/other_err_$exp.txt"
done

echo "Finished"
