<h1>RNA-Seq Workflow Analysis for Komagataeibacter Europaeus</h1>



<p>
  <strong>Link to the Study:</strong><br>
  <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4492376/" target="_blank">Read the full study</a>
</p>

<p>
  <strong>Inspired by:</strong><br>
  Dr. Arends' RNA-Seq analysis pipeline <a href="https://www.youtube.com/watch?v=PlqDQBl22DI&list=PLhR2Go-lh6X63hnyBzwWNvsaw1R79ESPI&pp=iAQB" target="_blank">Watch here</a>
</p>
<p>
<h2>Workflow:</h2>
<p><strong>Step 1:</strong> Install the necessary software for your RNA-Seq analysis.</p>
<p><strong>Step 2:</strong> Obtain the FASTA file of the reference genome and the GTF files. Index the reference genome for efficient analysis.</p>
<p><strong>Step 3:</strong> build reference genome</p>
<p><strong>Step 4:</strong> Download the SRR files containing your sequencing data. Check the quality of the data using FastQC.</p>
<p><strong>Step 5:</strong> Trim and preprocess your sequencing data using Trimmomatic for quality control.</p>
<p><strong>Step 6:</strong> Perform sequence alignment to map the reads to the reference genome.</p>
<p><strong>Step 7:</strong> Utilize Picard for  manipulations and analyses of BAM files, particularly for read grouping.</p>
<p><strong>Step 8:</strong> Index the processed data using Samtools for subsequent analysis and visualization.</p>
<p><strong>Step 9:</strong> variant calling using GATK.</p>
<p><strong>Step 10:</strong> Calculate genome size for peak calling.</p>
<p><strong>Step 11:</strong> Identify peaks in the data, often used for ChIP-Seq.</p>
<p><strong>Step 12:</strong>Visualize the results of peak calling using an R script.</p>
<p><strong>Step 13:</strong>Merge bed file for motif discovery.</p>
<p><strong>Step 14:</strong>Execute a script for motif discovery and analysis, typically used for ChIP-Seq data.</p>
<p>
<h3>Scripts:</h3>
<p><strong>Step 1</strong> is found in install_software </p>
<p><strong>Step 2</strong> is found in the prepare_genome.sh </p>
<p><strong>Step 3</strong> is found in the build_genome.r </p>
<p><strong>Step4</strong>/<strong>Step5</strong> is found in the rnaseq_yeast.r </p>
<p><strong>Step 6</strong> is found in the bashalignment.sh </p>
<p><strong>Step7</strong>/<strong>Step8</strong>/<strong>Step9</strong> is found in the samtoolindex.sh </p>
<p><strong>Step 10</strong> is found in the size_ref.sh </p>
<p><strong>Step 11</strong> is found in the peak_calling.sh </p>
<p><strong>Step 12</strong> is found in the peak_calling_visualization.sh </p>
<p><strong>Step 13</strong> is found in the merged.sh </p>
<p><strong>Step14</strong> is found in the Meme.sh </p>
<h2>Installation of Tools:</h2>
<h3>For Data Gathering, Cleaning, and Sequence Alignment:</h3>
<ol>
  <li>Trimmomatic</li>
  <li>SRA Toolkit</li>
  <li>Bowtie 2</li>
  <li>Picard</li>
  <li>Samtools</li>
  <li>Htslib</li>
  <li>Bcftools</li>
  <li>IGV (Integrative Genomics Viewer)</li>
  <li>FastQC</li>
  <li>MultiQC</li>
  <li><strong>GATK (Genome Analysis Toolkit):</strong> Used for analyzing high-throughput DNA sequencing data, used for variant discovery.</li>
</ol>
<h3>For Peak calling:</h3>
<ol>
<li><strong>bedtools:</strong> A set of tools for manipulating genomic intervals and working with BED, GFF, VCF, and other genomic file formats.</li>
<li><strong>macs2:</strong>Used for calling peaks from ChIP-Seq data, which is commonly used in the analysis of transcription factor binding sites.</li>
</ol>
</ol>
<h3>For Peak calling visualization:</h3>
<ol>
<li>Rsamtools</li>
<li>GenomicFeatures</li>
<li>PreprocessCore</li>
<li>rtracklayer</li>
<li>BiocParallel</li>
<li>GenomicAlignments</li>
<li>ggplot2</li>
<li>ggplot2</li>
<li><strong>ChIPseeker:</strong>R package for annotating ChIP-seq data with genomic features and finding enriched GO terms and KEGG pathways.</li>
<li><strong>TxDb.Scerevisiae.UCSC.sacCer3.sgdGene:</strong> A Bioconductor package providing access to the Saccharomyces cerevisiae (yeast) genome annotations.</li>
<li><strong>AnnotationDbi:</strong> A Bioconductor package for querying and manipulating annotation data, particularly for use with genomic features.</li>
<li><strong>GenomicRanges:</strong> A Bioconductor package for working with and manipulating genomic intervals and ranges.</li>
<li><strong>clusterProfiler:</strong> A Bioconductor package for analyzing and visualizing enrichment results in gene set or pathway analysis.</li>

</ol>
<h3>For Motif discovery:</h3>
<ol>
<li><strong>Homer</strong>: is a suite of tools for analyzing ChIP-Seq and other types of genomic data. I’ll use it for motif discovery and annotation. The simplicity and efficiency of use for the motif discovery process made it a better suit than the MEME suite.
provided To install HOMER, you can follow the installation instructions on the HOMER website: http://homer.ucsd.edu/homer/download.html </li>
</ol>

<h2>Data Gathering, Cleaning, and Alignment:</h3>

<h3>Setting up the required data for RNA-seq experiment:</h3>

<p> - The vcf file link:<a href="http://ftp.ensembl.org/pub/release-108/variation/vcf/saccharomyces_cerevisiae/saccharomyces_cerevisiae.vcf.gz">Download Link</a> </p>
<p> - The gtf file link:<a href=" http://ftp.ensembl.org/pub/release-108/gtf/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.108.gtf.gz">Download Link</a> </p>
<p>  Chromosomes I to XVI were assembled as one reference genome, the link is provided here: <a href="ftp.ensembl.org/pub/release-108/fasta/saccharomyces_cerevisiae/dna/">Download Link</a> </p>
<p> The SRR numbers can be downloaded from here: <a href="https://www.ncbi.nlm.nih.gov/Traces/study/?query_key=1&WebEnv=MCID_65481570ff982c6a638a6b67&o=acc_s%3Aa">Download Link</a> </p>
<p>-There are 12 runs each 3 runs comprised of (wild_type,sir2_,sir3_,sir4_), but for this study 8 runs were selected that consisted of 2 runs for each state. </p>
<p><strong>-<span style="color:#FF5733;">SRR1811834</span></strong> and <strong><span style="color:#FF5733;">SRR1812759</span></strong>: wild_type</p>
<p><strong>-<span style="color:#FF5733;">SSRR1812760</span></strong> and <strong><span style="color:#FF5733;">SRR1812767</span></strong>:sir2_ </p>
<p><strong>-<span style="color:#FF5733;">SRR1812770</span></strong> and <strong><span style="color:#FF5733;">SRR1812772</span></strong>:sir3_</p>
<p><strong>-<span style="color:#FF5733;">SRR1812973</span></strong>:sir4_</p>
  <h3>1. Fastq check using Multiqc:</h3>



