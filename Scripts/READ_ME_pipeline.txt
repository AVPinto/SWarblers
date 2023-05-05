The pipeline runs as follows:

1. Run Trimmomatic on raw reads (fastq.gz files). Important to have TruSeq file in the same directory as the script.
	a. Optional run of QC, but it is fine. Flagstat does this down the line.
2. Run BWA_script to align sequences to the reference genome. RagTag genome should be indicated.
3. Run clean_bam to improve the quality of the bam files.
4. Run SW_SNPs to call SNPs for the different plates.
5. Merge the resulting vcf files into a block ready to be read by PLINK.