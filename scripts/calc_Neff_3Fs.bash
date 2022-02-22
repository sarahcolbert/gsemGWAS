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

### set variable that will be the number of factors
i="${SLURM_ARRAY_TASK_ID}"

### run the Rscript
ml load r
Rscript ${project_dir}scripts/calc_Neff_3Fs.R

date
