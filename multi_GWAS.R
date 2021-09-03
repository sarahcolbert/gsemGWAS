### load necessary packages
library(devtools)
require(GenomicSEM)
library(dplyr)

### load the summary statistics RData file in the split form
split_sumstats <- read.table("./split_sumstats/sumstatsNUMBER.txt", header = TRUE)

### load the LDSC covariance matrix
load("LDSCoutput.RData")

### run a common factor model for one subset of SNPs
CommonFactor <- commonfactorGWAS(covstruc=LDSCoutput, SNPs=split_sumstats)

### remove unnecessary columns from the dataframe
CommonFactor$free <- NULL
CommonFactor$label <- NULL
CommonFactor$lhs <- NULL
CommonFactor$op <- NULL
CommonFactor$rhs <- NULL

### remove any rows that produce a warning
CF <- filter(CommonFactor, warning==0)

write.table(CF, file="./results/NUMBER.txt", row.names=FALSE, quote=FALSE)
