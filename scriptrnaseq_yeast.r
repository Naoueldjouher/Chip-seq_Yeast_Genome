#scriptrnaseq.R

# Define the input bases as command line arguments
cmdlineargs <- commandArgs(trailingOnly = TRUE)

# Check if at least one input base is provided
if (length(cmdlineargs) < 1) {
  cat("Usage: Rscript script.R input_base1 input_base2 ...\n")
  q("no")
}

execute <- function(x, outputfile = NA, intern = FALSE, quitOnError = FALSE){
  if(!is.na(outputfile) && file.exists(outputfile)){
    cat("Output for step exists, skipping this step\n");
    invisible("")
  }
  cat("----", x, "\n"); res <- system(x, intern = intern); cat(">>>>", res[1], "\n")
  if(res[1] >= 1){ 
    cat("Error external process did not finish\n\n");
    if(quitOnError) q("no")
  }
}
# Define input and output directories
input.dir <- "/Users/naouel/Documents/Genome/Yeast_genome/Data/Raw"
input.base <- cmdlineargs[1] 
output.dir <- paste0("Users/naouel/Documents/Genome/Yeast_genome/Data/Output/", input.base, ".aln")
#genome.path <- "/Users/naouel/Documents/Genome/Yeast_genome/bowtie2"
ref.fa<-"/Users/naouel/Documents/Genome/Yeast_genome/ref_info/Saccharomyces_cerevisiae.R64-1-1.dna.primary_assembly.fa"
# Create an output folder if it doesn't exist
if (!file.exists(input.dir)) { 
  dir.create(input.dir, recursive = TRUE)
}


# Set the path to the folder containing sratoolkit
path_to_sratoolkit <- "/Users/naouel/Documents/Genome/Software/sratoolkit.3.0.7-mac64/bin"
# Set the PATH environment variable to include the sratoolkit folder
Sys.setenv(PATH = paste0(path_to_sratoolkit, ":", Sys.getenv("PATH")))

# Run commands that rely on sratoolkit
setwd("/Users/naouel/Documents/Genome/Yeast_genome/Data/Raw")
execute(paste0("fasterq-dump -p --split-files ", input.base), paste0(input.base, "_1.fastq"))
execute(paste0("bgzip ", input.base, "_1.fastq"), paste0(input.base, "_1.fastq.gz"))
execute(paste0("bgzip ", input.base, "_2.fastq"), paste0(input.base, "_2.fastq.gz"))

#Perform quality check

bash_script <- "/Users/naouel/Documents/Genome/Yeast_genome/Scripts/fastqcyeast.sh"  
#execute(paste0("/bin/bash ", bash_script, " ", input.base))


 

# READ Trimming
input.base <- cmdlineargs[1] 
input.dir <- "/Users/naouel/Documents/Genome/Yeast_genome/Data/Raw"
output.dir <- paste0("/Users/naouel/Documents/Genome/Yeast_genome/Data/Output/", input.base, ".aln")
if (!file.exists(output.dir)) { 
  dir.create(output.dir, recursive = TRUE)
}
# Construct the file paths
trim.files <- c(
  paste0(input.dir, "/", input.base, "_1.fastq.gz"),
  paste0(input.dir, "/", input.base, "_2.fastq.gz"),
  paste0(output.dir, "/", input.base, "_1.P.fastq.gz"),
  paste0(output.dir, "/", input.base, "_1.U.fastq.gz"),
  paste0(output.dir, "/", input.base, "_2.P.fastq.gz"),
  paste0(output.dir, "/", input.base, "_2.U.fastq.gz")
)

# Define the path for Trimmomatic
trim.path <- "/Users/naouel/Documents/Genome/Software/Trimmomatic"
trim.jar <- "/Users/naouel/Documents/Genome/Software/Trimmomatic/dist/jar/trimmomatic-0.40-rc1.jar"

# Define the Java path
java_path <- "/usr/bin/java"

# Construct the Trimmomatic command
trim.exec <- paste0(java_path, " -jar ", trim.jar)
trim.opts <- paste0("ILLUMINACLIP:", trim.path, "/adapters/TruSeq3-PE-2.fa:2:30:10")
trim.opts <- paste0(trim.opts, " LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36")
trim.cmd <- paste0(trim.exec, " PE ", paste0(trim.files, collapse = " "), " ", trim.opts)

# Execute the Trimmomatic command
system(trim.cmd)  # Use system() for external command execution




#Perform alignment

bash_script <- "/Users/naouel/Documents/Genome/Yeast_genome/Scripts/bashalignmentyeast.sh"  
execute(paste0("/bin/bash ", bash_script, " ", input.base))
#Remove duplicate with picard
bash_script <- "/Users/naouel/Documents/Genome/Yeast_genome/Scripts/samtoolindexyeast.sh"  
execute(paste0("/bin/bash ", bash_script, " ", input.base))




