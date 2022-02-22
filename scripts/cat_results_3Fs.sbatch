#!/bin/bash

#SBATCH --job-name=combine_SNPsets
#SBATCH --time=02:00:00
#SBATCH -n 1
#SBATCH --mem=1000
#SBATCH --output=./outerr/combine_Factor%a.out
#SBATCH --error=./outerr/combine_Factor%a.err
#SBATCH --array=1-3

date
hostname

### create variable that is equal to the number of factors (3)
cc="${SLURM_ARRAY_TASK_ID}"

### concatenate all results files and only keep header from first file
awk 'FNR>1 || NR==1' ${results_dir}F"$cc"_sumstats/*.csv > ${results_dir}F"$cc"_stats.csv

date
