#!/bin/bash

#SBATCH --job-name=combine_SNPsets
#SBATCH --time=02:00:00
#SBATCH --qos=preemptable
#SBATCH -n 1
#SBATCH --mem=1000
#SBATCH --output=./outerr/combine.out
#SBATCH --error=./outerr/combine.err

date
hostname

### concatenate all results files
cat ./results/*.csv > ./results/CF_stats.csv
### remove intermediate files
rm ./code/*.R
### remove all lines that contain Z_Estimate after the first occurence (used to indicate header line)
sed -i '1!{/Z_Estimate/d;}' ./results/CF_sumstats.txt

date
