This is a base image for all your alignment and qc needs based on miniconda3.

Feel free to extend/update this image with new software.

So far stuff that's included:

- snakemake
- python 3
- R
- fastqc
- multiqc
- samtools
- hisat2
- stringtie
- gffcompare
- rseqc
- star
- kallisto
- trimmomatic
- cutadapt
- gnu-parallel
- drop-seq tools 2.4.1
- CITE-seq-Count
- seqtk
- picard
- homer
- subread

You can either use this as a base for your own docker image or
extend this image with new tools if you find them generally useful.