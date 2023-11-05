# Define an array of input bases
input_bases="$1"

# Define paths to reference genome and VCF file
ref_fa="/Users/naouel/Documents/Genome/Yeast_genome/ref_info/Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.fa"
ref_snps="/Users/naouel/Documents/Genome/Yeast_genome/ref_info/Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.vcf.gz"
dict_file="/Users/naouel/Documents/Genome/Yeast_genome/ref_info/Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.dict"
fai_file="/Users/naouel/Documents/Genome/Yeast_genome/ref_info/Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.fa.fai"
tbi_file="/Users/naouel/Documents/Genome/Yeast_genome/ref_info/Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.vcf.gz.tbi"
# Path to the samtools executable
samtools="/opt/anaconda3/envs/myenv2/bin/samtools"

# Java command for Picard
java_cmd="java -Xmx4g -jar"

# Path to the Picard tools executable
picard="/opt/anaconda3/envs/myenv2/share/picard-2.27.5-0/picard.jar"

# Path to the GATK executable
gatk_exec="java -Xmx4g -jar /opt/anaconda3/envs/myenv2/share/gatk4-4.0.5.1-0/gatk-package-4.0.5.1-local.jar"

# Define GATK options
gatk_opts="-R $ref_fa --known-sites $ref_snps"





# Define the base output directory
output_base_dir="/Users/naouel/Documents/Genome/Yeast_genome/Data/Output"

for input_base in "${input_bases[@]}"; do
    output_dir="${output_base_dir}/${input_base}.aln"
    outbase="${output_dir}/${input_base}"

    # Define the BAM file
    bam_file="${outbase}.sorted.bam"
    echo "Value of bam_file: $bam_file"

    # STEP 4 - Add read group (1) and sample run, library, and name
    rg_bam="${output_dir}/${input_base}.sorted.RD.RG.bam"
    rg_opts="-PL ILLUMINA -PU run -LB $(echo $input_base | sed 's/SRR//') -SM $input_base"
    p_cmd="$java_cmd $picard AddOrReplaceReadGroups -I $bam_file -O $rg_bam $rg_opts"
    $p_cmd

    # STEP 4.1 - Create a samtools index for the final BAM file
    $samtools index "$rg_bam"

    # STEP 5.1 - GATK BaseRecalibrator
    # Define GATK options

    gatk_cov1="${rg_bam%.bam}_cov1.txt"
    gatk_cmd="$gatk_exec BaseRecalibrator $gatk_opts -I $rg_bam -O $gatk_cov1"
    $gatk_cmd

    # STEP 5.2 - GATK ApplyBQSR
    recal_bam="${rg_bam%.bam}.recal.bam"
    gatk_cmd="$gatk_exec ApplyBQSR -R $ref_fa -bqsr $gatk_cov1 -I $rg_bam -O $recal_bam"
    $gatk_cmd

    # STEP 5.3 - GATK BaseRecalibrator
    gatk_cov2="${recal_bam%.bam}_cov2.txt"
    gatk_cmd="$gatk_exec BaseRecalibrator $gatk_opts -I $recal_bam -O $gatk_cov2"
    $gatk_cmd

    # STEP 5.4 - GATK AnalyzeCovariates
    recal_plot="${rg_bam%.bam}_AnalyzeCovariates.pdf"
    gatk_cmd="$gatk_exec AnalyzeCovariates -before $gatk_cov1 -after $gatk_cov2 -plots $recal_plot"
    $gatk_cmd

    # STEP 6 - Index the recalibrated BAM files
    $samtools index $recal_bam

    # STEP 6.1 - Create mapping and coverage statistics
    $samtools flagstat $recal_bam
    $samtools coverage $recal_bam
done
