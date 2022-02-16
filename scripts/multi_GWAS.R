### load necessary packages
require(GenomicSEM)

### load the summary statistics RData file in the split form
print("loading summary statistics from set NUMBER...")
split_sumstats <- read.table("./split_sumstats/sumstatsNUMBER.txt", header = TRUE)
print("finished loading summary statistics from set NUMBER")

### load the LDSC covariance matrix
print("loading LDSC covariance matrix...")
load("LDSCoutput.RData")
print("finished loading LDSC covariance matrix")

### run a common factor model for one subset of SNPs
print("running models...")
CommonFactor <- commonfactorGWAS(covstruc=LDSCoutput, SNPs=split_sumstats)
print("GWAS completed")

print("writing results to file...")
write.csv(CommonFactor, file="./results/NUMBER.csv", row.names=FALSE)
print("analysis for set NUMBER complete")
