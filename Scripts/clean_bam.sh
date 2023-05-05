#!/bin/bash
#SBATCH --job-name=Clean_bam
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --time=150:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=5G 
#SBATCH --output=Clean-%j.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=s.a.gonzalez.mollinedo@rug.nl

data_name=$1

module load SAMtools

# make directories
# only need to run once
mkdir /scratch/p309374/SW_genomics/Flagstat/
mkdir /scratch/p309374/SW_genomics/Flagstat/${data_name}/
mkdir /scratch/p309374/SW_genomics/Clean_aligned/${data_name}/

# run flagstat to check mapping efficiency 
# use samtools to remove all unmapped reads from the bam (using the -F 4 flag option)
# rerun flagstat to check read numbers in clean bam files

for f in /scratch/p309374/SW_genomics/Aligned/${data_name}/*all.bam;
do FBASE=$(basename $f)
	BASE=${FBASE%all.bam}
	samtools flagstat /scratch/p309374/SW_genomics/Aligned/${data_name}/${BASE}all.bam > /scratch/p309374/SW_genomics/Flagstat/${data_name}/${BASE}.flagstat
	samtools view -F 4 -b /scratch/p309374/SW_genomics/Aligned/${data_name}/${BASE}all.bam > /scratch/p309374/SW_genomics/Clean_aligned/${data_name}/${BASE}all_mapped.bam
	samtools flagstat /scratch/p309374/SW_genomics/Clean_aligned/${data_name}/${BASE}all_mapped.bam > /scratch/p309374/SW_genomics/Flagstat/${data_name}/${BASE}mapped.flagstat
done