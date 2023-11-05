
# Define the URI and base file name for downloading chromosome sequences
uri <- "ftp.ensembl.org/pub/release-108/fasta/saccharomyces_cerevisiae/dna/"
base <- "Saccharomyces_cerevisiae.R64-1-1.dna.chromosome."
chrs <- c(as.character(as.roman(seq(1:16))))

# Create a directory to store the downloaded files (you may customize the path)
download_dir <- "downloaded_chromosome_files"
dir.create(download_dir, showWarnings = FALSE)

# Download chromosome sequences
for (chr in chrs) {
  fname <- paste0(base, chr, ".fa.gz")
  download_url <- paste0(uri, fname)
  download_file <- file.path(download_dir, fname)
  
  # Download the file and save it in the download directory
  download.file(download_url, destfile = download_file, mode = "wb")
}

# Concatenate chromosome sequences and compress them into the output FASTA file
output_fasta <- "Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.fa"

# Create an empty FASTA file
cat("", file = output_fasta)

# Concatenate chromosome sequences into the output FASTA file
for (chr in chrs) {
  fname <- paste0(base, chr, ".fa.gz")
  file_to_concat <- file.path(download_dir, fname)
  
  if (file.exists(file_to_concat)) {
    # Read the downloaded file and append it to the output FASTA
    file_content <- readLines(file_to_concat)
    cat(file_content, sep = "\n", file = output_fasta, append = TRUE)
    
    # Remove the downloaded file
    file.remove(file_to_concat)
  } else {
    cat("Warning: File not found -", fname, "\n")
  }
}

# Compress the resulting FASTA file
system2("bgzip", args = c("-k", output_fasta))

# Clean up the download directory
unlink(download_dir, recursive = TRUE, force = TRUE)


