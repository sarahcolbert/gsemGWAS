#!/bin/bash
#SBATCH -J multi-GWAS
#SBATCH --qos=preemptable
#SBATCH --mem=10gb
#SBATCH -t 02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --output=./outerr/set.%a.out
#SBATCH --error=./outerr/set.%a.err
#SBATCH --array=1-#OF SNP SUBSETS

### display time at beginning and end of script to track how long it takes
date
### display node that job was run on
hostname

### set variable that will be the number of the SNP set
cc="${SLURM_ARRAY_TASK_ID}"

### replace "NUMBER" variable in R script with the number of the SNP set the job is running
### you can delete these scripts after you're done with the analyses
sed "s/NUMBER/$cc/g" multi_GWAS.R > ./code/$cc.R

### run the Rscript
ml load R
Rscript ./code/$cc.R

date
