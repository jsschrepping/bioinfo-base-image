# Set the base image to debian based miniconda3
FROM continuumio/miniconda3:4.5.12

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
    python2.7 \
    python-pip \
    gawk && \
    apt-get clean

# Update conda
RUN conda update -n base -c defaults conda

# Set channels
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

# Install conda packages
RUN conda install -y numpy=1.16.1 \
    	  	     scipy=1.2.0 \ 
		     cython=0.29.4 \
		     numba=0.41.0 \
		     matplotlib=3.0.2 \
		     scikit-learn=0.20.2 \
		     h5py=2.9.0 \
		     click=7.0 \
		     emacs=26.1 \
		     R=3.5.1 \
		     rpy2=2.9.4 \
		     git=2.20.1 \
		     multiqc=1.6 \
		     snakemake=5.4.0 \
		     r-devtools=2.0.1  && \
    conda install -c bioconda -y samtools=1.9 \
    	  	     	      	 fastqc=0.11.8 \
    	  	     	      	 homer=4.9.1 \
    	  	     	      	 star=2.6.1b \
				 hisat2=2.1.0 \
				 rseqc=3.0.0 \
				 stringtie=1.3.4 \
				 gffcompare=0.10.6 \
				 kallisto=0.45.0 \
				 trimmomatic=0.38 \
				 cutadapt=1.18 \
				 seqtk=1.3 \
				 picard=2.18.26

# gnu parallel
RUN aria2c http://ftpmirror.gnu.org/parallel/parallel-20170922.tar.bz2 && \
    bzip2 -dc parallel-20170922.tar.bz2 | tar xvf - && \
    cd parallel-20170922 && \
    ./configure && make && make install && \
    cd .. && rm -rf parallel-20170922*

# drop-seq-tools 2.1.0
ENV DROPSEQPATH /usr/local/drop-seq-tools
COPY binaries/Drop-seq_tools-2.1.0.zip .
RUN unzip Drop-seq_tools-2.1.0.zip -d /tmp && \
    mv /tmp/Drop-seq_tools-2.1.0 $DROPSEQPATH && \
    rm Drop-seq_tools-2.1.0.zip
ENV PATH "$PATH:$DROPSEQPATH"

# for the sanity of python packages
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
