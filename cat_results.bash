#!/bin/bash

#SBATCH --job-name=combine_SNPsets
#SBATCH --time=02:00:00
#SBATCH --qos=preemptable
#SBATCH -n 1
#SBATCH --mem=1000
#SBATCH --output=../outerr/combine.out
#SBATCH --error=../outerr/combine.err

date
hostname

### concatenate all results files
cat ../results/*.txt > ../results/CF_stats.txt
### remove error and warning columns
awk '{$11=$12=""; print $0}' ../results/CF_stats.txt > ../results/CF_sumstats.txt
### remove intermediate files
rm ../results/CF_stats.txt
rm ../code/*.R
### remove all lines that aren't the first occurrence of Z_Estimate (used to indicate header line)
sed -i '1!{/Z_Estimate/d;}' ../results/CF_sumstats.txt


date
