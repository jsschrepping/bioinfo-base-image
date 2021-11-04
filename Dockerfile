# Set the base image to debian based miniconda3
FROM continuumio/miniconda3:4.10.3

# File Author/Maintainer
MAINTAINER Jonas Schulte-Schrepping

# This will make apt-get install without question
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git \
    cmake \
    zlib1g \
    libhdf5-dev \
    build-essential \
    wget \
    curl \
    unzip \
    jq \
    bc \
    openjdk-8-jre \
    perl \
    libxml2-dev \
    aria2 \
    subread \
    libcurl4-openssl-dev \
    less \
    gcc \
    gawk && \
    apt-get clean

# Update conda
RUN conda update -n base -c defaults conda

# Set channels
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

# Install conda packages
RUN conda install -y numpy=1.21.3 \
    	  	     scipy=1.7.1 \ 
		     cython=0.29.24 \
		     numba=0.54.1 \
		     matplotlib=3.4.3 \
		     scikit-learn=1.0.1 \
		     h5py=3.4.0 \
		     click=8.0.3 \
		     emacs=27.2 \
		     R=4.6.1 \
		     rpy2=3.4.5 \
		     git=2.33.1 \
		     multiqc=1.11 \
		     snakemake=6.10.0 \
		     ucsc-bedgraphtobigwig=377-0 \ 
		     r-devtools=2.0.2  && \
		     cellsnp-lite=1.2.2 \
    conda install -c bioconda -y samtools=1.14 \
    	  	     	      	 fastqc=0.11.9 \
    	  	     	      	 homer=4.11 \
    	  	     	      	 star=2.7.9a \
				 hisat2=2.2.1 \
				 rseqc=4.0.0 \
				 stringtie=2.1.7 \
				 gffcompare=0.11.2 \
				 kallisto=0.46.2 \
				 trimmomatic=0.39 \
				 cutadapt=3.5 \
				 seqtk=1.3 \
				 picard=2.26.4 
				 

# pip install
RUN pip install CITE-seq-Count==1.4.1
RUN pip install vireoSNP==0.5.6

# gnu parallel
RUN aria2c http://ftpmirror.gnu.org/parallel/parallel-20170922.tar.bz2 && \
    bzip2 -dc parallel-20170922.tar.bz2 | tar xvf - && \
    cd parallel-20170922 && \
    ./configure && make && make install && \
    cd .. && rm -rf parallel-20170922*

# drop-seq-tools 2.1.0
ENV DROPSEQPATH /usr/local/drop-seq-tools
COPY binaries/Drop-seq_tools-2.4.1.zip .
RUN unzip Drop-seq_tools-2.4.1.zip -d /tmp && \
    mv /tmp/Drop-seq_tools-2.4.1 $DROPSEQPATH && \
    rm Drop-seq_tools-2.4.1.zip
ENV PATH "$PATH:$DROPSEQPATH"

# for the sanity of python packages
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
