#!/bin/bash

bedtools="/opt/anaconda3/envs/myenv2/bin/bedtools"
macs2="/opt/anaconda3/envs/myenv2/bin/macs2"

# Set the path to the ChIP-seq BAM file
input_base="$1"
chip_file="/Users/naouel/Documents/Genome/Yeast_genome/Data/Output/$input_base.aln/$input_base.sorted.RD.RG.recal.bam"

# Set the path to the control BAM files for each sample
Sample_1="/Users/naouel/Documents/Genome/Yeast_genome/Data/Output/SRR1811834.aln/SRR1811834.sorted.RD.RG.recal.bam"
Sample_2="/Users/naouel/Documents/Genome/Yeast_genome/Data/Output/SRR1812759.aln/SRR1812759.sorted.RD.RG.recal.bam"
control_files=("$Sample_1" "$Sample_2")  # Specify the control BAM files for each sample

# Set the common options for macs2 callpeak
genome_size="12071326"  # Change to your genome size
output_dir="/Users/naouel/Documents/Genome/Yeast_genome/Results/$input_base.peak_call"
mkdir -p "$output_dir"
# Loop through the control files and run macs2 callpeak
for ((i=0; i<${#control_files[@]}; i++)); do
    control_bam="${control_files[i]}"
    output_prefix="sample_${i}"  # You can customize the output prefix as needed
    
    macs2 callpeak -t "$chip_file" -c "$control_bam" -f BAMPE -g "$genome_size" -n "$output_dir/$output_prefix"
    awk 'BEGIN {OFS="\t"} {print $1, $2, $3, "peak_" NR, $5, "."}' "$output_dir/${output_prefix}_peaks.narrowPeak" > "$output_dir/${output_prefix}_peaks.bed"
done

