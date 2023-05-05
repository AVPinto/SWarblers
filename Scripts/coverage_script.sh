#!/bin/bash
#SBATCH --job-name=Coverage_bam
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G 
#SBATCH --output=Coverage-%j.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=s.a.gonzalez.mollinedo@rug.nl

data_name=$1

module load SAMtools

# make directories
# only need to run once
mkdir /scratch/p309374/SW_genomics/Clean_aligned/${data_name}_coverage/

# run flagstat to check mapping efficiency 
# use samtools to remove all unmapped reads from the bam (using the -F 4 flag option)
# rerun flagstat to check read numbers in clean bam files

for f in /scratch/p309374/SW_genomics/Aligned/${data_name}/*all.bam;
do FBASE=$(basename $f)
	BASE=${FBASE%all_mapped.bam}
	samtools depth /scratch/p309374/SW_genomics/Clean_aligned/${BASE}all_mapped.bam  |  awk '{sum+=$3; sumsq+=$3*$3} END { print ${BASE}"_Average = ",sum/1091184475; print "Stdev = ",sqrt(sumsq/1081119075 - (sum/1081119075)**2)}'> ${BASE}_coverage.txt 
done