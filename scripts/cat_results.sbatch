#!/bin/bash

#SBATCH --job-name=combine_SNPsets
#SBATCH --time=02:00:00
#SBATCH --mem=1G
#SBATCH --output=./outerr/combine.out
#SBATCH --error=./outerr/combine.err

date
hostname

### concatenate all results files and only keep header from first file
awk 'FNR>1 || NR==1' ${results_dir}*.csv > ${results_dir}CF_sumstats.csv

date
