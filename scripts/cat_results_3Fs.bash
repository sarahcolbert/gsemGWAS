#!/bin/bash

#SBATCH --job-name=combine_SNPsets
#SBATCH --time=02:00:00
#SBATCH -n 1
#SBATCH --mem=1000
#SBATCH --output=./outerr/combine.out
#SBATCH --error=./outerr/combine.err
#SBATCH --array=1-3

date
hostname

### create variable that is equal to the number of factors (3)
cc="${SLURM_ARRAY_TASK_ID}"

### concatenate all results files
cat ./results/F"$cc"_sumstats/*.csv > ./results/F"$cc"_sumstats/F"$cc"_stats.csv
### remove intermediate files
rm ./code/*.R
### remove all lines that contain Z_Estimate after the first occurence (used to indicate header line)
sed -i '1!{/Z_Estimate/d;}' ./results/F"$cc"_sumstats/F"$cc"_sumstats.csv

date
