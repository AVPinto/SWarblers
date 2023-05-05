#!/bin/bash
#SBATCH --job-name=BWA_align
#SBATCH --partition=regular
#SBATCH --cpus-per-task=6
#SBATCH --time=150:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=s.a.gonzalez.mollinedo@rug.nl

data_name=$1

module load BWA
module load SAMtools

# make directories
# only need to run once
mkdir /scratch/p309374/SW_genomics/Aligned/
mkdir /scratch/p309374/SW_genomics/Aligned/${data_name}/

# index file to be used by bwa
# only need to run once
#bwa index /scratch/p309374/Ref_genome/ragtag.scaffold.fasta

# align paired reads using bwa mem and output as bam file using samtools
for f in /scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/*_trimmed_paired_R1.fastq.gz;
do 		FBASE=$(basename $f)
        BASE=${FBASE%_trimmed_paired_R1.fastq.gz}
        bwa mem -t 6 \
		/scratch/p309374/Ref_genome/ragtag.scaffold.fasta \
		/scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}_trimmed_paired_R1.fastq.gz \
		/scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}_trimmed_paired_R2.fastq.gz| \
		samtools sort -o /scratch/p309374/SW_genomics/Aligned/${data_name}/${BASE}_paired.bam
done

# combine single end reads into one file
# align unpaired reads using bwa mem and output as bam file using samtools
# merge paired and unpaired alignments


for f in /scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/*_trimmed_unpaired_R1.fastq.gz;
do 		FBASE=$(basename $f)
        BASE=${FBASE%_trimmed_unpaired_R1.fastq.gz}
        zcat /scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}_trimmed_unpaired_R1.fastq.gz /scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}_trimmed_unpaired_R2.fastq.gz > /scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}_trimmed_unpaired_both.fastq.gz
        bwa mem -t 4 \
		/scratch/p309374/Ref_genome/ragtag.scaffold.fasta \
		/scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}_trimmed_unpaired_both.fastq.gz| \
		samtools sort -o /scratch/p309374/SW_genomics/Aligned/${data_name}/${BASE}_unpaired.bam
		samtools merge -@ 4 /scratch/p309374/SW_genomics/Aligned/${data_name}/${BASE}_all.bam /scratch/p309374/SW_genomics/Aligned/${data_name}/${BASE}_paired.bam /scratch/p309374/SW_genomics/Aligned/${data_name}/${BASE}_unpaired.bam
done