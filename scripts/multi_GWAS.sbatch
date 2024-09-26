#!/bin/bash
#SBATCH -J multi-GWAS
#SBATCH --mem=5G
#SBATCH -t 02:00:00
#SBATCH --output=./outerr/set.%a.out
#SBATCH --error=./outerr/set.%a.err
#SBATCH --array=0-#OF SNP SUBSETS-1

### display time at beginning and end of script to track how long it takes
date
### display node that job was run on
hostname

### set variable that will be the number of the SNP set
export cc="${SLURM_ARRAY_TASK_ID}"
source ./config

### run the Rscript
ml load r
Rscript ${project_dir}scripts/multi_GWAS.R

date
