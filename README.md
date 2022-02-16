# Optimizing genomic-SEM GWAS for faster completion


This github repository outlines a framework used to run genomic-SEM for a large number of SNP sets. By breaking the summary statistics input up into smaller sets of SNPs, one can submit many jobs at once that do not require as much memory or time as it would take to run every SNP model in a single job. commonfactorGWAS() automatically calculates the heterogeneity estimate for each SNP, but userGWAS() does not. I am working on adding my code for calculating Qsnp for user models, but you should include chisq = TRUE in userGWAS() to be able to eventually calculate Qsnp. (The newest version of GSEM no longer makes the modelchi function optional, so as long as you have updated to v0.0.4 you do not need to add this flag).

### Pre-Step 1: Downloading and running the pipeline

Navigate to the directory where you want to download the repository. The repository can then be downloaded using git: <br>
> git clone https://github.com/sarahcolbert/gsemGWAS <br>

### Pre-Step 2: Editing the config file

These scripts should be run in a directory which already contains the following contents. Running the config file will set up your directory to meet these requirements.

* the location of the RData file with the LDSC matrix
* the location of the RData file with the G-SEM generated summary statistics
* an "outerr" directory
* a "code" directory
* a "split_sumstats" directory
* a "results" directory
  * a subdirectory for each factor if you wish to run multiple, for example: "results/F1_sumstats", "results/F2_sumstats", etc. If subdirectories are necessary, you will need to create these yourself after configuration. 

To edit the config file navigate to the repository's directory and add the required information to the file. You can then run the config file using:  <br>
> source ./config <br>

You should also make sure to check what your R objects are saved as, so that they are compatible with these scripts.
For example, the summary statistics are saved in an R dataframe called sumstats and the covariance matrix data is in an object called LDSCoutput.

## Step 1: Splitting up the summary statistics

Using the script [split_sumstats.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/split_sumstats.R) in R. This script chooses to split the SNPs up into sets of 5000. If you wish, you can change how large you would like each set of SNPs to be. The larger the sets, the less jobs you will run, but the longer those jobs will take. You should also take into consideration how many jobs you are able to submit/should submit as to not hog resources, particularly if using multiple CPUs. If you are satisfied with SNP sets of 5,000 you can go ahead and run the code:

```
Rscript ./scripts/split_sumstats.R
```

If you'd prefer a different size for your SNP sets (in this example we would prefer SNP sets of 1000), you should edit the script before running it like so:

```
sed -i 's/5000/1000/g' ./scripts/split_sumstats.R
```

There are two outputs from this script: (1) the new summary statistics files saved as "/split_sumstats/sumstats*.txt" and (2) the number of SNP subsets created which is saved as "num_SNP_sets.txt". The number of subsets created determines how many jobs must be ran (see part 3).

## Step 2: Create an R script that runs the specific GWAS you wish to perform

An example of this script is located in [multi_GWAS.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/multi_GWAS.R). This script only runs for one subset of SNPs, identified using the variable "NUMBER", which is later replaced. This script will be the basis for all runs using each subset of SNPs. One thing to note is that this script identifies a common factor GWAS, but can be used with user-specified GWASs as long as the script is edited.

An example script using a 3 factor user GWAS is also available in [multi_GWAS_3Fs.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/multi_GWAS_3Fs.R). If you wish to use this script make sure to save the filename as multi_GWAS.R to be compatible with subsequent scripts.

** NOTE: If you are using the userGWAS function, I have found that jobs run better serially (this is a good solution if you are coming across the error _Error in { : task 1 failed - "infinite or missing values in 'x'"_). You should therefore included "parallel = FALSE" as an option in your code (see line 27 in [multi_GWAS_3Fs.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/multi_GWAS_3Fs.R)).


## Step 3: Run the GWAS for each subset of SNPs.
Using the bash script [multi_GWAS.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/multi_GWAS.bash), you can run a separate job for each set of SNPs that will create an R script using that subset of SNPs, run that Rscript and then save the output into a results directory. In this script make sure to set the number of jobs to the number of SNPs subsets you want to run (see note above about considering how many jobs you can/should run). Depending on the size of your SNP sets you will also probably need to change how much memory and time you request.

## Step 4: Compile your results files
Use the script [cat_results.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/cat_results.bash) to combine all of your results files into one set of summary statistics for a common factor. This file will be saved as CF_sumstats.csv.

To compile your results into multiple sets of summary statistics for multiple factors, you may wish to use the script [cat_results_3Fs.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/cat_results_3Fs.bash).

## Step 5: Calculate Neff for latent factors
You can calculate the effective sample size for each latent factor using the scripts [calc_Neff.R](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/calc_Neff.R) and [calc_Neff.bash](https://github.com/sarahcolbert/quickSEMGWAS/blob/master/scripts/calc_Neff.bash). Effective sample size is calculated using the code from the [genomic-SEM wiki](https://github.com/MichelNivard/GenomicSEM/wiki/4.-Common-Factor-GWAS) and the equation developed by [Mallard et al.](https://www.biorxiv.org/content/10.1101/603134v1.abstract)
