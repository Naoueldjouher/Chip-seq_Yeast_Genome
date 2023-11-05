
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("TxDb.Scerevisiae.UCSC.sacCer3.sgdGene")
BiocManager::install("DESeq2")




library("ChIPseeker")
library("GenomicFeatures")
library("DESeq2")
library("AnnotationDbi")
library("GenomicRanges")
library("clusterProfiler")
library("ggplot2")
library("org.Sc.sgd.db")
library("KEGGREST")
library("TxDb.Scerevisiae.UCSC.sacCer3.sgdGene")

annotation_file<-"/Users/naouel/Documents/Genome/Yeast_genome/Saccharomyces_cerevisiae.R64-1-1.110.gff3"


# Specify the input bases
input_bases <- c("SRR1812767", "SRR1812770", "SRR1812772", "SRR1812973")

# Load the annotation file
annotation_file <- "/Users/naouel/Documents/Genome/Yeast_genome/Saccharomyces_cerevisiae.R64-1-1.110.gff3"

# Create an empty list to store sample files
samplefiles_list <- list()

# Read and process the peak files for each input base
for (input_base in input_bases) {
  input_dir <- file.path("/Users/naouel/Documents/Genome/Yeast_genome/Results", paste0(input_base, ".peak_call"))
  
  # List all the sample files in the input directory
  samplefiles <- list.files(input_dir, pattern = "sample_1_summits.bed", full.names = TRUE)
  
  # Store the list of sample files in the samplefiles_list
  samplefiles_list[[input_base]] <- samplefiles
}

# Initialize an empty list to store the peak annotations
peakAnnoList <- list()

# Create a TxDb object from the annotation file
txdb <- makeTxDbFromGFF(annotation_file)

# Loop through the input bases and annotate peaks for each
for (input_base in input_bases) {
  samplefiles <- samplefiles_list[[input_base]]
  
  # Annotate peaks with genomic features
  annotated_peaks <- annotatePeak(samplefiles, TxDb = txdb, tssRegion = c(-1000, 1000), verbose = FALSE)
  
  # Store the annotated peaks in the peakAnnoList
  peakAnnoList[[input_base]] <- annotated_peaks
}
# Loop through the peakAnnoList and generate bar plots for each input base
for (input_base in input_bases) {
  annotated_peaks <- peakAnnoList[[input_base]]
  
  # Generate the bar plot
  plot <- plotAnnoBar(annotated_peaks)
  
  # Customize the plot as needed
  # For example, you can set the title:
  plot <- plot + ggtitle(paste("Annotation Bar Plot for Input Base:", input_base))
  
  # Display or save the plot
  print(plot)  # Display the plot in the R console
  ggsave(paste("annotation_bar_plot_", input_base, ".png"), plot = plot)  # Save the plot as a PNG file
}
# Specify the input bases
input_bases <- c("SRR1812767", "SRR1812770", "SRR1812772", "SRR1812973")

# Loop through the peakAnnoList and generate bar plots for each input base
for (input_base in input_bases) {
  annotated_peaks <- peakAnnoList[[input_base]]
  
  # Define a function to create histograms
  create_histograms <- function(peak_annotation, input_base) {
    # Convert the <csAnno> object to a data frame
    peak_df <- as.data.frame(peak_annotation)
    
    # Create histograms for peak widths and peak distances to TSS
    peak_width_histogram <- ggplot(peak_df, aes(x = width)) +
      geom_histogram(binwidth = 100, fill = "skyblue", color = "black") +
      labs(
        title = "Peak Width Distribution",
        x = "Peak Width",
        y = "Count"
      ) +
      theme_minimal()
    
    peak_distance_histogram <- ggplot(peak_df, aes(x = distanceToTSS)) +
      geom_histogram(binwidth = 500, fill = "skyblue", color = "black") +
      labs(
        title = "Peak Distance to TSS Distribution",
        x = "Distance to TSS",
        y = "Count"
      ) +
      theme_minimal()
    
    # Save the histograms to files
    ggsave(paste("peak_width_histogram_", input_base, ".png"), plot = peak_width_histogram)
    ggsave(paste("peak_distance_histogram_", input_base, ".png"), plot = peak_distance_histogram)
    
    return(list(peak_width_histogram, peak_distance_histogram))
  }
  
  # Call the create_histograms function with annotated_peaks
  histograms <- create_histograms(annotated_peaks, input_base)
}
# Specify the input bases
input_bases <- c("SRR1812767", "SRR1812770", "SRR1812772", "SRR1812973")

# Loop through the peakAnnoList and generate bar plots for each input base
for (input_base in input_bases) {
  annotated_peaks <- peakAnnoList[[input_base]]
  peak_df <- as.data.frame(annotated_peaks)  # Corrected the variable name
  gene_id <- peak_df$geneId
  
  # Define a function to perform GO term enrichment analysis
  perform_go_enrichment <- function(gene_id, output_dir) {
    # Perform GO term enrichment analysis
    go_enrichment <- enrichGO(
      gene = gene_id,
      OrgDb = org.Sc.sgd.db,
      keyType = "ENSEMBL",
      ont = "BP",
      pAdjustMethod = "BH",
      pvalueCutoff = 0.05
    )
    
    # Set the working directory to the output directory
    setwd(output_dir)
    
    # Output results from GO analysis to a table
    cluster_summary <- data.frame(go_enrichment)
    write.csv(cluster_summary, "clusterProfiler_Nanog.csv")
    
    # Create dotplot
    p <- dotplot(go_enrichment, showCategory = 10) +
      theme(axis.text.x = element_text(size = 10))
    ggsave("go_enrichment_dotplot.pdf", plot = p)
  }
  
  # Replace the comment with code to retrieve gene IDs for the current input_base
  # For example:
  # gene_id <- your_code_to_retrieve_gene_ids(input_base)
  
  output_dir <- file.path("/Users/naouel/Documents/Genome/Yeast_genome/Results", paste0(input_base, "_GO_enrichment"))
  
  # Create the output directory if it doesn't exist
  dir.create(output_dir, showWarnings = FALSE)
  
  # Call the perform_go_enrichment function
  perform_go_enrichment(gene_id, output_dir)
}
  

