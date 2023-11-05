#!/bin/bash

# Check for the correct number of arguments

input_base="$1"
input_dir="/Users/naouel/Documents/Genome/Yeast_genome/Data/Output/$input_base.aln"
FASTQC_EXECUTABLE="/opt/anaconda3/envs/myenv2/bin/fastqc"  # Provide the path to your FastQC executable here

# Check if the directory exists
if [ ! -d "$input_dir" ]; then
    echo "Directory not found: $input_base"
    exit 1
fi

# Change to the specified directory
cd "$input_dir" || exit 1

# Loop through all .fastq.gz files in the directory
for file in *.fastq.gz; do
    if [ -e "$file" ]; then
        # Check if FastQC output files already exist for the input file
        if [ ! -e "${file}_fastqc.html" ] && [ ! -e "${file}_fastqc.zip" ]; then
            echo "Running FastQC on: $file"
            "$FASTQC_EXECUTABLE" -t 5 "$file"
        else
            echo "FastQC output files already exist for: $file. Skipping analysis."
        fi
    fi
done




