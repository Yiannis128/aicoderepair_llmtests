#!/usr/bin/env python3

# Extracts from the log file the raw inputs to the LLM and places them into their respective folders.
# Raw input: Is the raw prompt to the LLM
# Raw output: The response from the LLM

import os

dirs: list[str] = [
    "llm_raw_input_1", "llm_raw_output_1", "llm_raw_input_single", "llm_raw_output_single", "llm_raw_input_2", "llm_raw_output_2",
]

# Create directories
for dir in dirs:
    if not os.path.exists(dir):
        os.mkdir(dir)

# Open and read the log.txt file.
with open("log.txt", "r") as file:
    text_file: list[str] = file.readlines()

# Current save file name.
save_file: str = ""
# Output folder names
raw_input_folder: str = "llm_raw_input_1"
raw_output_folder: str = "llm_raw_output_1"
# Flags for recording which data.
record_input = False
record_output = False
# Buffers to record data in
raw_input_lines: list[str] = []
raw_output_lines: list[str] = []
for line in text_file:
    clean_line: str = " ".join(line.rstrip().split(" ")[2:])
    # Set folder checks
    if clean_line == "Running Contextual Strategy":
        print("Base Experiments")
        raw_input_folder = "llm_raw_input_1"
        raw_output_folder = "llm_raw_output_1"
        continue
    elif clean_line == "Running Contextual Strategy: Single Line":
        print("Single Line Experiments")
        raw_input_folder = "llm_raw_input_single"
        raw_output_folder = "llm_raw_output_single"
        continue
    elif clean_line == "Running Contextual Strategy: 2nd Iteration Clang Assist":
        print("Clang 2nd Iteration Experiments")
        raw_input_folder = "llm_raw_input_2"
        raw_output_folder = "llm_raw_output_2"
        continue
    # Set new file check
    elif "Notice: Checkpoint " in line:
        if save_file != "":
            print("\t\tWriting files")
            # Save the recorded data.
            with open(f"{raw_input_folder}/{save_file}", "w") as file:
                file.writelines(raw_input_lines)

            with open(f"{raw_output_folder}/{save_file}", "w") as file:
                file.writelines(raw_output_lines)

        # Initialize/set the file to save to.
        save_file = line.split(" ")[4].strip()
        record_input = False
        record_output = False
        raw_input_lines = []
        raw_output_lines = []
        print("\tReading", save_file)
    elif "Log: " in line:
        # Stop recording if any other if any other log message is found.
        record_input = False
        record_output = False
    elif save_file == "":
        # If save file is empty, then simply continue to next line, until a
        # checkpoint is found.
        continue

    # Check if recording raw input.
    if "LLM Raw Input:" in line:
        print("\t\tReading raw input")
        record_input = True
        record_output = False
        continue

    if "Raw Response" in line:
        print("\t\tReading raw response")
        record_input = False
        record_output = True
        continue

    if record_input:
        raw_input_lines.append(line)

    if record_output:
        raw_output_lines.append(line)

