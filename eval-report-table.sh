#!/usr/bin/env bash

echo "This script generates the values from the report. Please run eval-count-metrics.sh
prior to running this script."

exps="1 single 2"

# Calculated all at once so need to have OR as they are used inside of regex
simple_prompts="0|1|2|3|4|5"
# Processed separatley
persona_prompts="6 7 8 9 10 11"
old_prompt="12"

no_esbmc="0|1|6|7"
esbmc_before="4|5|10|11"
esbmc_after="2|3|8|9" # Maybe include old prompt in here?

count_files() {
	ls esbmc_output_$exp | grep -E "^($1)\..+.c" | wc -l
}

report_total() {
	echo "$num/$total => $(echo "scale=2; $num*100.0/$total" | bc -l)%"
}

for exp in $exps; do
	echo -e "\n\n"
	echo "Experiments: $exp"
	#
	# Simple prompts are collected together
	#
	echo "  Compiles:"
	
	total="$(count_files "$old_prompt")"
	echo -n "    Old: "
	num="$(grep -E "^esbmc_output_$exp\/$old_prompt\..*" "verdicts/compiles_$exp.txt" -sc)"
	report_total

	# Simple prompts are collected together
	total="$(count_files "$simple_prompts")"
	echo -n "    Simple: "
	num="$(grep -E "^esbmc_output_$exp\/($simple_prompts)\..*" "verdicts/compiles_$exp.txt" -sc)"
	report_total
	
	# Persona separateley
	idx=0
	for prompt_idx in $persona_prompts; do
		total="$(count_files "$prompt_idx")"
		echo -n "    Persona-$idx ($prompt_idx): "
		num="$(grep -e "^esbmc_output_$exp\/$prompt_idx\..*" "verdicts/compiles_$exp.txt" -sc)"
		report_total
		idx=$((idx+1))
	done
	unset idx
	
	echo
	# Verifier output
	total="$(count_files "$no_esbmc")"
	echo -n "    No ESBMC: "
	num="$(grep -E "^esbmc_output_$exp/($no_esbmc)\..*" "verdicts/compiles_$exp.txt" -sc)"
	report_total

	total="$(count_files "$esbmc_before")"
	echo -n "    ESBMC Before: "
	num="$(grep -E "^esbmc_output_$exp/($esbmc_before)\..*" "verdicts/compiles_$exp.txt" -sc)"
	report_total

	total="$(count_files "$esbmc_after")"
	echo -n "    ESBMC After: "
	num="$(grep -E "^esbmc_output_$exp/($esbmc_after)\..*" "verdicts/compiles_$exp.txt" -sc)"
	report_total

	#
	# Verification Stats
	#
	echo -e "\n  Verification:"
	
	# Simple prompts are collected together
	total="$(count_files "$old_prompt")"
	echo -n "    Old: "
	num="$(grep -E "^esbmc_output_$exp\/$old_prompt\..*" "verdicts/verification_successful_$exp.txt" -sc)"
	report_total

	# Simple prompts are collected together
	total="$(count_files "$simple_prompts")"
	echo -n "    Simple: "
	num="$(grep -E "^esbmc_output_$exp\/($simple_prompts)\..*" "verdicts/verification_successful_$exp.txt" -sc)"
	report_total
	
	# Persona separateley
	idx=0
	for prompt_idx in $persona_prompts; do
		total="$(count_files "$prompt_idx")"
		echo -n "    Persona-$idx ($prompt_idx): "
		num="$(grep -e "^esbmc_output_$exp\/$prompt_idx\..*" "verdicts/verification_successful_$exp.txt" -sc)"
		report_total
		idx=$((idx+1))
	done
	unset idx
	
	echo
	# Verifier output
	total="$(count_files "$no_esbmc")"
	echo -n "    No ESBMC: "
	num="$(grep -E "^esbmc_output_$exp/($no_esbmc)\..*" "verdicts/verification_successful_$exp.txt" -sc)"
	report_total

	total="$(count_files "$esbmc_before")"
	echo -n "    ESBMC Before: "
	num="$(grep -E "^esbmc_output_$exp/($esbmc_before)\..*" "verdicts/verification_successful_$exp.txt" -sc)"
	report_total

	total="$(count_files "$esbmc_after")"
	echo -n "    ESBMC After: "
	num="$(grep -E "^esbmc_output_$exp/($esbmc_after)\..*" "verdicts/verification_successful_$exp.txt" -sc)"
	report_total
done

