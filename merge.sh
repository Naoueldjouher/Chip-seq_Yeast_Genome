#!/bin/bash
input_bases=("$1")

for input_base in "${input_bases[@]}"; do
    input_dir0="/Users/naouel/Documents/Genome/Yeast_genome/Results/$input_base.peak_call/initial_merged/sample_0_peaks.bed"
    input_dir1="/Users/naouel/Documents/Genome/Yeast_genome/Results/SRR1812767.peak_call/initial_merged/sample_1_peaks.bed"
    output_dir="/Users/naouel/Documents/Genome/Yeast_genome/Results/$input_base.peak_call/initial_merged/merged_bed.bed"
    cat "$input_dir0" "$input_dir1" > "$output_dir"
done
