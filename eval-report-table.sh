#!/usr/bin/env bash

echo "This script generates the values from the report. Please run eval-count-metrics.sh
prior to running this script."

exps="1 single 2"

simple_prompts="0|1|2|3|4|5"
persona_prompts="6 7 8 9 10 11"
old_prompt="12"

no_esbmc="0|1|6|7"
esbmc_before="4|5|10|11"
esbmc_after="2|3|8|9" # Maybe include old prompt in here?

count_files() {
	ls esbmc_output_single | grep -E "^0\..+.c" | wc -l
}

for exp in $exps; do
	echo -e "\n\n"
	echo "Experiments: $exp"
	#
	# Simple prompts are collected together
	#
	echo "  Compiles:"
	
	total="$(count_files "$old_prompt")"
	echo -n "    Old ($total): "
	grep -E "^esbmc_output_$exp\/$old_prompt\..*" "verdicts/compiles_$exp.txt" -sc
	echo

	# Simple prompts are collected together
	total="$(count_files "$simple_prompts")"
	echo -n "    Simple ($total): "
	grep -E "^esbmc_output_$exp\/($simple_prompts)\..*" "verdicts/compiles_$exp.txt" -sc
	echo
	
	# Persona separateley
	idx=0
	for prompt_idx in $persona_prompts; do
		total="$(count_files "$prompt_idx")"
		echo -n "    Persona $idx ($total): "
		grep -e "^esbmc_output_$exp\/$prompt_idx\..*" "verdicts/compiles_$exp.txt" -sc
		idx=$((idx+1))
	done
	unset idx
	
	# Verifier output
	total="$(count_files "$no_esbmc")"
	echo -n "    No ESBMC ($total): "
	grep -E "^esbmc_output_$exp/$no_esbmc\..*" "verdicts/compiles_$exp.txt" -sc

	total="$(count_files "$esbmc_before")"
	echo -n "    ESBMC Before ($total): "
	grep -E "^esbmc_output_$exp/$esbmc_before\..*" "verdicts/compiles_$exp.txt" -sc

	total="$(count_files "$esbmc_after")"
	echo -n "    ESBMC After ($total): "
	grep -E "^esbmc_output_$exp/$esbmc_after\..*" "verdicts/compiles_$exp.txt" -sc

	#
	# Verification Stats
	#
	echo "  Verification:"
	
	# Simple prompts are collected together
	total="$(count_files "$old_prompt")"
	echo -n "    Old ($total): "
	grep -E "^esbmc_output_$exp\/$old_prompt\..*" "verdicts/verification_successful_$exp.txt" -sc
	echo

	# Simple prompts are collected together
	total="$(count_files "$simple_prompts")"
	echo -n "    Simple ($total): "
	grep -E "^esbmc_output_$exp\/($simple_prompts)\..*" "verdicts/verification_successful_$exp.txt" -sc
	echo
	
	# Persona separateley
	idx=0
	for prompt_idx in $persona_prompts; do
		total="$(count_files "$prompt_idx")"
		echo -n "    Persona $idx ($total): "
		grep -e "^esbmc_output_$exp\/$prompt_idx\..*" "verdicts/verification_successful_$exp.txt" -sc
		idx=$((idx+1))
	done
	unset idx
	
	# Verifier output
	total="$(count_files "$no_esbmc")"
	echo -n "    No ESBMC ($total): "
	grep -E "^esbmc_output_$exp/$no_esbmc\..*" "verdicts/verification_successful_$exp.txt" -sc

	total="$(count_files "$esbmc_before")"
	echo -n "    ESBMC Before ($total): "
	grep -E "^esbmc_output_$exp/$esbmc_before\..*" "verdicts/verification_successful_$exp.txt" -sc

	total="$(count_files "$esbmc_after")"
	echo -n "    ESBMC After ($total): "
	grep -E "^esbmc_output_$exp/$esbmc_after\..*" "verdicts/verification_successful_$exp.txt" -sc
done

