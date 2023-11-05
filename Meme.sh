#!/bin/bash

# List of input bases or samples
input_bases=("$1")

ref_fa="/Users/naouel/Documents/Genome/Yeast_genome/ref_info/Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.fa"
output_dir="/Users/naouel/Documents/Genome/Yeast_genome/Results/"
homer_bin="/Users/naouel/Documents/Genome/Software/bin"
for input_base in "${input_bases[@]}"; do
  input_dir="/Users/naouel/Documents/Genome/Yeast_genome/Results/$input_base.peak_call"
  
  echo "Processing: $input_base"
  echo "Input Directory: $input_dir"

  # Create the output directory for this input base
  base_output_dir="$output_dir/$input_base"
  mkdir -p "$base_output_dir"
  annotation_dir="$output_dir/annotations"
  mkdir -p "$annotation_dir"
  annotation_file="$annotation_dir/$input_base.txt"
  # Merge BED files
cat "$input_dir/sample_0_peaks.bed" "$input_dir/sample_1_peaks.bed" > "$base_output_dir/merged_bed.bed"

  # Run HOMER findMotifsGenome.pl
  "$homer_bin/findMotifsGenome.pl" "$base_output_dir/merged_bed.bed" "$ref_fa" "$base_output_dir"
  "$homer_bin/annotatePeaks.pl" "$base_output_dir/merged_bed.bed" "$ref_fa" -m  > "$annotation_file"

  echo "HOMER analysis completed: $input_base"
done
