### load necessary packages
require(GenomicSEM)

### load the summary statistics RData file in the split form
print(paste("loading summary statistics from set ",Sys.getenv("cc"),"...", sep = ""))
split_sumstats <- read.table(paste(Sys.getenv("sumstats_dir"),"sumstats",Sys.getenv("cc"),".txt", sep = ""), header = TRUE)
print(paste("finished loading summary statistics from set ",Sys.getenv("cc"), sep = ""))

### load the LDSC covariance matrix
print("loading LDSC covariance matrix...")
load(paste(Sys.getenv("ldsc_file")))
print("finished loading LDSC covariance matrix")

### run a common factor model for one subset of SNPs
print("running models...")
CommonFactor <- commonfactorGWAS(covstruc=LDSCoutput, SNPs=split_sumstats)
print("GWAS completed")

print("writing results to file...")
write.csv(CommonFactor, file=paste(Sys.getenv("results_dir"),Sys.getenv("cc"),".csv", sep = ""), row.names=FALSE)
print(paste("analysis for set ",Sys.getenv("cc")," complete", sep = ""))
