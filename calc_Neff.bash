#!/bin/bash
#SBATCH -J Neff
#SBATCH --qos=preemptable
#SBATCH --mem=10gb
#SBATCH -t 01:00:00
#SBATCH --output=./outerr/neff.%a.out
#SBATCH --error=./outerr/neff.%a.err
#SBATCH --array=1-3

### display time at beginning and end of script to track how long it takes
date
### display node that job was run on
hostname

### set variable that will be the number of the SNP set
cc="${SLURM_ARRAY_TASK_ID}"

### replace "NUMBER" variable in R script with the number of the factor the job is running
### you can delete these scripts after you're done with the analyses
sed "s/NUMBER/$cc/g" calc_Neff.R > ./code/calc_Neff_F$cc.R

### run the Rscript
ml load R
Rscript ./code/calc_Neff_F$cc.R

date
