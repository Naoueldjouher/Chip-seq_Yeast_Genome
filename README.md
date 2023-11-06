<h1>Chip-Seq Workflow Analysis for Saccharomyces cerevisiae</h1>
<p>Sir2, Sir3, and Sir4 are key proteins in yeast known for their roles in gene silencing through the formation of heterochromatin. ChIP-Seq analysis has been employed to investigate their functions by identifying their DNA binding sites. This analysis has revealed specific motifs associated with these proteins, shedding light on their regulatory roles in chromatin structure and gene expression. While Sir2 has diverse functions related to metabolism and gene silencing, Sir3 and Sir4 play central roles in maintaining silent chromatin states at specific loci. Understanding their binding patterns and motifs provides valuable insights into epigenetic regulation in yeast.</p>


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
<p> - The gtf file link:<a href="http://ftp.ensembl.org/pub/release-108/gtf/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.108.gtf.gz">Download Link</a> </p>
<p>  Chromosomes I to XVI were assembled as one reference genome, the link is provided here: <a href="ftp.ensembl.org/pub/release-108/fasta/saccharomyces_cerevisiae/dna/">Download Link</a> </p>
<p> The SRR numbers can be downloaded from here: <a href="https://www.ncbi.nlm.nih.gov/Traces/study/?query_key=1&WebEnv=MCID_65481570ff982c6a638a6b67&o=acc_s%3Aa">Download Link</a> </p>
<p>-There are 12 runs each 3 runs comprised of (wild_type,sir2_,sir3_,sir4_), but for this study 8 runs were selected that consisted of 2 runs for each state. </p>
<p><strong>-<span style="color:#FF5733;">SRR1811834</span></strong> and <strong><span style="color:#FF5733;">SRR1812759</span></strong>: wild_type</p>
<p><strong>-<span style="color:#FF5733;">SSRR1812760</span></strong> and <strong><span style="color:#FF5733;">SRR1812767</span></strong>:sir2_ </p>
<p><strong>-<span style="color:#FF5733;">SRR1812770</span></strong> and <strong><span style="color:#FF5733;">SRR1812772</span></strong>:sir3_</p>
<p><strong>-<span style="color:#FF5733;">SRR1812973</span></strong>:sir4_</p>
  <h3>1. Fastq check using Multiqc:</h3>

  
<h3>Fastqc check:</h3>
<img width="467" alt="Screenshot 2023-11-06 at 19 45 52" src="https://github.com/Naoueldjouher/Chip-seq/assets/80243706/e96b5232-0f97-4de3-9689-32d0b12b8708">

<img width="475" alt="Screenshot 2023-11-06 at 19 45 17" src="https://github.com/Naoueldjouher/Chip-seq/assets/80243706/6ed6c5f6-bc05-49d9-9978-4e1566eb4b6d">
<img width="464" alt="Screenshot 2023-11-06 at 19 49 03" src="https://github.com/Naoueldjouher/Chip-seq/assets/80243706/7f148e4e-0a33-4121-a9bb-3d6e67305a2e">

<h3>Gene enrichment analysis:</h3>
<h4><strong>SRR1812767_go_enrichment</strong></h4>

<img width="506" alt="Screenshot 2023-11-06 at 10 54 35" src="https://github.com/Naoueldjouher/Chip-seq/assets/80243706/133ab5e5-391f-4fa9-9d10-28b8945b5d3c">
<h4><strong>SRR1812770_go_enrichment</strong></h4>
<img width="504" alt="Screenshot 2023-11-06 at 10 55 25" src="https://github.com/Naoueldjouher/Chip-seq/assets/80243706/35583dfb-bf3f-4ba0-b4c2-6e2ef05c285a">
<h4><strong>SRR1812772_go_enrichment</strong></h4>
<img width="510" alt="Screenshot 2023-11-06 at 10 56 08" src="https://github.com/Naoueldjouher/Chip-seq/assets/80243706/85f02ac5-b693-4c72-adc1-0edd0b3cacb1">

<h4><strong>SRR1812973_go_enrichment</strong></h4>
<img width="506" alt="Screenshot 2023-11-06 at 10 56 29" src="https://github.com/Naoueldjouher/Chip-seq/assets/80243706/c18648ef-7d1f-400b-957f-afaaaa676b5f">
<p>The enrichment of metabolic and energy-related terms in Sir3's context implies a potential interplay between metabolic processes and its role in gene silencing. Sir4, associated with translation and cytoplasmic translation, may indicate connections between gene regulation and protein synthesis. Sir2's involvement in translation, ribosome biogenesis, and metabolic processes suggests its multifaceted role beyond chromatin silencing. Overall, these findings emphasize the interconnectedness of cellular functions. The roles of these proteins extend beyond their primary functions, with potential links to cellular metabolism, protein synthesis, and broader cellular activities, warranting further investigation.</p>

<h3>Motif Discovery and Analysis with Homer: Identifying Significantly Enriched DNA Motifs:</h3>
<p>These motifs were  selected based on their low p-values, which are indicative of their statistical significance in our analysis.</p>
<h4><strong> Main Motif found for sir2_</strong></h4>
<p>CBF3(AP2EREBP)</p>
<p>CBF2(AP2EREBP)</p>
<p>WRKY50(WRKY)</p>
<p>WRKY28(WRKY)</p>
<p>WRKY18(WRKY</p>
<h4><strong> Main Motif found for sir3_</strong></h4>
<p>DAL80</p>
<p>MEIS2</p>
<p>POL008.1_DCE_S_I</p>
<p>PRDM4</p>
<p>CEBP(bZIP)</p>
<p>ASHR1</p>
<p>WRKY40</p>
<h4><strong> Main Motif found for sir4_</strong></h4>
<p>CBF3(AP2EREBP)</p>
<p>CBF2(AP2EREBP)</p>
<p>RAP21(AP2EREBP)</p>
<p>At1g19210(AP2EREBP)</p>
<p>WRKY20(WRKY)</p>
<p>At1g75490(AP2EREBP)</p>
<p>MYB44(MYB)</p>


<h4><strong> Conclusion</strong></h4>

<p><strong>Shared AP2EREBP Motifs:</strong></p><p> CBF3(AP2EREBP) and CBF2(AP2EREBP) motifs are shared between Sir2 and Sir4. This could imply that these proteins might be involved in regulating gene expression through AP2EREBP transcription factors, suggesting a potential overlap in their roles.</p>

<p><strong>WRKY Motifs:</p></strong></p><p>Sir2 shares WRKY motifs (WRKY50, WRKY28, WRKY18) with Sir3 and Sir4. This indicates a possible connection between these proteins and the WRKY family of transcription factors in gene regulation. WRKY transcription factors are known to play essential roles in plant signaling, and their presence in this context could point to an interesting regulatory network.</p>

<p><strong>Unique Motifs:</p></strong></p><p> Sir3 and Sir4 have unique motifs (e.g., DAL80, MEIS2, PRDM4) that are not shared with Sir2. These unique motifs suggest that Sir3 and Sir4 may have distinct roles or interactions with specific transcription factor families.</p>

<p>In summary, the shared motifs among Sir2, Sir3, and Sir4 suggest potential interactions and collaborations with specific transcription factor families (AP2EREBP and WRKY). This could indicate their roles in diverse gene regulatory processes and highlight the complexity of their functions in yeast cells.</p>












