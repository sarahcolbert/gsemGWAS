# Optimizing genomic-SEM GWAS for faster completion


This github repository outlines a framework used to run genomic-SEM for a large number of SNP sets.

These scripts should be run in a directory which already contains:

* an RData file with the LDSC matrix (LDSCoutput.RData)
* an RData file with the G-SEM generated summary statistics (sumstats.RData)
* an "outerr" directory
* a "code" directory
* a "split_sumstats" directory
* a "results" directory
  * a subdirectory for each factor if you wish to run multiple, for example: "results/F1_sumstats", "results/F2_sumstats", etc.  

You should also make sure to check what your objects are saved as, so that they are compatible with these scripts.
For example, these summary statistics are saved in a dataframe called sumstats and the covariance matrix is called LDSCoutput.

### Part 1: Splitting up the summary statistics

Using the script [split_sumstats.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/split_sumstats.R) in R. This script chooses to split the SNPs up into sets of 8000. If you wish, you can change how large you would like each set of SNPs to be. The larger the sets, the less jobs you will run, but the longer those jobs will take. You should also take into consideration how many jobs you are able to submit/should submit as to not hog resources, particularly if using multiple CPUs.

There are two outputs from this script: (1) the new summary statistics files saved as "/split_sumstats/sumstats*.txt" and (2) the number of SNP subsets created which is saved as "num_SNP_sets.txt". The number of subsets created determines how many jobs must be ran (see part 3).

### Part 2: Create an R script that runs the specific GWAS you wish to perform

An example of this script is located in [multi_GWAS.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/multi_GWAS.R). This script only runs for one subset of SNPs, identified using the variable "NUMBER", which is later replaced. This script will be the basis for all runs using each subset of SNPs. One thing to note is that this script identifies a common factor GWAS, but can be used with user-specified GWASs as long as the script is edited.

An example script using a 3 factor user GWAS is also available in [multi_GWAS_3Fs.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/multi_GWAS_3Fs.R). If you wish to use this script make sure to save the filename as multi_GWAS.R to be compatible with subsequent scripts.

** NOTE: If you are using the userGWAS function, I have found that jobs run better serially. You should therefore included "parallel = FALSE" as an option in your code (see line 27 in [multi_GWAS_3Fs.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/multi_GWAS_3Fs.R)).


### Part 3: Run the GWAS for each subset of SNPs.
Using the bash script [multi_GWAS.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/multi_GWAS.bash), you can run a separate job for each set of SNPs that will create an R script using that subset of SNPs, run that Rscript and then save the output into a results directory. In this script make sure to set the number of jobs to the number of SNPs subsets you want to run (see note above about considering how many jobs you can/should run).

### Part 4: Compile your results files
Use the script [cat_results.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/cat_results.bash) to combine all of your results files into one set of summary statistics for a common factor. This file will be saved as CF_sumstats.txt.

To compile your results into multiple sets of summary statistics for multiple factors, you may wish to use the script [cat_results_3Fs.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/cat_results_3Fs.bash).

### Part 5: Calculate Neff for latent factors
You can calculate the effective sample size for each latent factor using the scripts [calc_Neff.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/calc_Neff.R) and [calc_Neff.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/calc_Neff.bash). Effective sample size is calculated using the code from the [genomic-SEM wiki](https://github.com/MichelNivard/GenomicSEM/wiki/4.-Common-Factor-GWAS) and the equation developed by [Mallard et al.](https://www.biorxiv.org/content/10.1101/603134v1.abstract)
