# Set the base image to debian based miniconda3
FROM continuumio/miniconda3:4.10.3

# File Author/Maintainer
MAINTAINER Jonas Schulte-Schrepping

# This will make apt-get install without question
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /usr/share/man/man1

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends software-properties-common &&\ 
    add-apt-repository ppa:webupd8team/java && \ 
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
    openjdk-11-jre \
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
RUN conda install -y numpy \
    	  	     scipy \ 
		     cython \
		     numba \
		     matplotlib \
		     scikit-learn \
		     h5py \
		     click \
		     emacs \
		     git \
		     multiqc \
		     snakemake \
		     ucsc-bedgraphtobigwig \ 
		     cellsnp-lite

RUN conda install -c bioconda -y samtools \
    	  	     	      	 fastqc \
    	  	     	      	 homer \
    	  	     	      	 star \
				 hisat2 \
				 rseqc \
				 stringtie \
				 gffcompare \
				 kallisto \
				 trimmomatic \
				 cutadapt \
				 seqtk \
				 picard 
				 

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
