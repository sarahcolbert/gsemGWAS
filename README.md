# Optimizing genomic-SEM GWAS for quicker completion by performing jobs for smaller sets of SNPs


This github repository outlines a framework used to run genomic-SEM for a large number of SNP sets.

These scripts should be run in a directory which already contains:

* an RData file with the LDSC matrix (LDSCoutput.RData)
* an RData file with the G-SEM generated summary statistics (sumstats.RData)
* an "outerr" directory
* a "code" directory
* a "results" directory
  * a subdirectory for each factor if you wish to run multiple, for example: "results/F1_sumstats", "results/F2_sumstats", etc.  

You should also make sure to check what your objects are saved as, so that they are compatible with these scripts.
For example, these summary statistics are saved as sumstats and the covariance matrix is saved as LDSCoutput.

### Part 1: Splitting up the summary statistics

Using the script [split_sumstats.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/split_sumstats.R) in R. This script chooses to split the SNPs up into sets of 8000. If you wish, you can change how large you would like each set of SNPs to be. The larger the sets, the less jobs you will run, but the longer those jobs will take. You may also want to consider how many jobs you are able to submit (RC can't submit more than 1000, I think).

There are two outputs from this script: (1) the new summary statistics object saved as "split_sumstats.RData" and (2) the number of SNP subsets created which is saved as "num_SNP_sets.txt". The number of subsets created determines how many jobs must be ran.

### Part 2: Create an R script that runs the specific GWAS you wish to perform

An example of this script is located in [multi_GWAS.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/multi_GWAS.R). This script only runs for one subset of SNPs, identified using the variable "NUMBER", which is later replaced. This script will be the basis for all runs using each subset of SNPs. One thing to note is that this script identifies a common factor GWAS, but can be used with user-specified GWASs as long as the script is edited.

An example script using a 3 factor user GWAS is also available in [multi_GWAS_3Fs.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/multi_GWAS_3Fs.R).


### Part 3: Run the GWAS for each subset of SNPs.
Using the bash script [multi_GWAS.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/multi_GWAS.bash), you can run a separate job for each set of SNPs that will create an R script using that subset of SNPs, run that Rscript and then save the output into a results directory. In this script make sure to set the number of jobs to the number of SNPs subsets!

### Part 4: Compile your results files
Use the script [cat_results.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/cat_results.bash) to combine all of your results files into one set of summary statistics for a factor. This file will be saved as CF_sumstats.txt.
