#!/bin/bash

#SBATCH --job-name=combine_SNPsets
#SBATCH --time=02:00:00
#SBATCH --qos=preemptable
#SBATCH -n 1
#SBATCH --mem=1000
#SBATCH --output=../outerr/combine.out
#SBATCH --error=../outerr/combine.err
#SBATCH --1-3

date
hostname

### create variable that is equal to the number of factors (3)
cc="${SLURM_ARRAY_TASK_ID}"

### concatenate all results files
cat ../results/F"$cc"_sumstats/*.txt > ../results/F"$cc"_sumstats/F"$cc"_stats.txt
### remove error and warning columns
awk '{$11=$12=""; print $0}' ../results/F"$cc"_sumstats/F"$cc"_stats.txt > ../results/F"$cc"_sumstats/f"$cc"_sumstats.txt
### remove intermediate files
rm ../results/F"$cc"_sumstats/F"$cc"_stats.txt
rm ../code/*.R
### remove all lines that aren't the first occurrence of Z_Estimate (used to indicate header line)
sed -i '1!{/Z_Estimate/d;}' ../results/F"$cc"_sumstats/F"$cc"_sumstats.txt


date
