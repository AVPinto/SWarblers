#!/bin/bash
#SBATCH --job-name=SNPs_SW
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --time=150:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G 
#SBATCH --output=SNPS_SW-%j.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=s.a.gonzalez.mollinedo@rug.nl

module load BCFtools
src=$1

# make new directories for vcf file and cleaned file
mkdir /scratch/$USER/SW_genomics/vcf/$src/

# index genome file for bcftools to use
samtools faidx /scratch/p309374/Ref_genome/ragtag.scaffold.fasta


# Make file of list of bam files
ls /scratch/SW_genomics/Clean_aligned/$src/*all_mapped.bam > /scratch/$USER/bamFiles_$src.txt


# run bcftools mpileup
##-Ou: ouput an uncompressed bam file. This is the option to use when piping the output to another command for optimum performance/speed.
##–max-depth 10000: the maximum number of sequences considered per position
##-q 20: filter out alignments with mapping quality <20
##-Q 20: filter out bases with QS < 20
##-P ILLUMINA: use Illumina platform for indels
##-a FORMAT/DP,FORMAT/AD: output depth and allelic depth
##-f specify the genome reference file, which must be faidx-indexed
##-b list of input bam alignment files
# pipe output and call snps
##-m: use the multiallelic caller
##-v: output variants only
##-P 1e-6: prior for expected substitution rate
##-f GQ: output genotype quality
##-O b: output in compressed VCF format

bcftools mpileup -Ou \
--max-depth 10000 -q 20 -Q 20 \
-P ILLUMINA -a FORMAT/DP,FORMAT/AD \
-f /scratch/p309374/Ref_genome/ragtag.scaffold.fasta \
-b bamFiles_$src.txt | \
bcftools call -mv -P 1e-6 -f GQ \
-O z -o /scratch/$USER/SW_genomics/vcf/$src/SW_$src.vcf.gz