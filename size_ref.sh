#!/bin/bash
# Replace 'your_reference_genome.fa' with the path to your reference genome FASTA file
ref_genome="/Users/naouel/Documents/Genome/Yeast_genome/ref_info/Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.fa"


# Calculate the genome size
genome_size=$(grep -v ">" "$ref_genome" | tr -d '\n' | wc -c)

# Print the genome size
echo "Genome size: $genome_size"
