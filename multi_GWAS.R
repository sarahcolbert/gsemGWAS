### load necessary packages
library(devtools)
require(GenomicSEM)
library(dplyr)

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

### remove unnecessary columns from the dataframe
CommonFactor$free <- NULL
CommonFactor$label <- NULL
CommonFactor$lhs <- NULL
CommonFactor$op <- NULL
CommonFactor$rhs <- NULL

### remove any rows that produce a warning
print("removing SNPs that produce a warning...")
CF <- filter(CommonFactor, warning==0)
print("SNPs with warnings removed")

print("writing results to file...")
write.table(CF, file="./results/NUMBER.txt", row.names=FALSE, quote=FALSE)
print("analysis for set NUMBER complete")

