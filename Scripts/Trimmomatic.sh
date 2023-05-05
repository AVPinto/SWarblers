#!/bin/bash
#SBATCH --job-name=Trimmomatic
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --time=72:00:00
#SBATCH --mem=4G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=s.a.gonzalez.mollinedo@rug.nl

module load Trimmomatic

data_name=$1
mkdir /scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/

for f in /scratch/p309374/SW_genomics/${data_name}/Sample*/*"R1"*".fastq.gz";
do FBASE=$(basename $f)
	BASE=${FBASE%*R1*.fastq.gz}
	java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads 4 -phred33 \
	/scratch/p309374/SW_genomics/${data_name}/Sample*/${BASE}*R1*.fastq.gz \
	/scratch/p309374/SW_genomics/${data_name}/Sample*/${BASE}*R2*.fastq.gz \
	/scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}trimmed_paired_R1.fastq.gz \
	/scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}trimmed_unpaired_R1.fastq.gz \
	/scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}trimmed_paired_R2.fastq.gz \
	/scratch/p309374/SW_genomics/Trimmed_seqs/${data_name}/${BASE}trimmed_unpaired_R2.fastq.gz \
	ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:12 SLIDINGWINDOW:4:30 MINLEN:80
done