
#Set up 
#Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#Conda 
brew install --cask miniconda
#R
conda create -n myenv r-base
#wget
brew install wget
#Java
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk11
#edirect
sh -c "$(wget -q https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh -O -)"
#Add edirect to Your Shell Environment
export PATH=$PATH:$HOME/edirect
#Replace $HOME/edirect with the actual path where edirect is installed.
#Load the updated configuration with:
source ~/.bashrc

# Create a directory for software and navigate to it
mkdir software
cd software

# Clone Trimmomatic repository and build it
git clone https://github.com/usadellab/Trimmomatic.git

# Download and extract SRA Toolkit
cd software
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-centos_linux64-cloud.tar.gz
mkdir sratoolkit
tar -xzf sratoolkit.3.0.0-centos_linux64-cloud.tar.gz –C sratoolkit
./sratoolkit/usr/local/ncbi/sra-tools/bin/vdb-config --interactive


# GATK install
wget https://github.com/broadinstitute/gatk/releases/download/4.2.6.1/gatk-4.2.6.1.zip
unzip gatk-4.2.6.1.zip
#bedtools
conda install -c bioconda bedtools
#bowtie2
brew install bowtie2
#samtools
brew install samtools
#mac2
conda install -c bioconda macs2
#Homer
wget http://homer.ucsd.edu/homer/configureHomer.pl
perl ./configureHomer.pl -install
nano ~/.bash_profile
#Replace $HOME/edirect with the actual path where edirect is installed.
#Load the updated configuration with:
export PATH="$PATH:/path/to/your/custom/binaries"
source ~/.my_software_profile
