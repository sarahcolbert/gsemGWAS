#!/bin/bash
#SBATCH -J Neff
#SBATCH --mem=4G
#SBATCH -t 01:00:00
#SBATCH --output=./outerr/neff.out
#SBATCH --error=./outerr/neff.err

date
hostname

### run the Rscript
ml load r
Rscript ${project_dir}scripts/calc_Neff.R

date
