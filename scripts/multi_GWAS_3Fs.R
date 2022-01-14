### load necessary packages
library(devtools)
require(GenomicSEM)
library(dplyr)

### load the summary statistics RData file in the split form
split_sumstats <- read.table("./split_sumstats/sumstatsNUMBER.txt", header = TRUE)

### load the LDSC covariance matrix
load("LDSCoutput.RData")

### identify model
model <- 'F1 =~ NA*Trait1 + Trait2
             F2 =~ NA*Trait3
             F3 =~ NA*Trait4 + Trait5
             F1~~F3
             F2~~F3
             F1~~F2
             F1~~1*F1
             F2~~1*F2
             F3~~1*F3
             F1~SNP
             F2~SNP
             F3~SNP'

### run a user model for one subset of SNPs
CommonFactor <- userGWAS(covstruc=LDSCoutput, SNPs=split_sumstats, model=model, sub=c("F1~SNP", "F2~SNP", "F3~SNP"), parallel = FALSE)

### subset results from first common factor and write to csv file
CF1 <- CommonFactor[[1]]
write.csv(CF1, file="./results/F1_sumstats/NUMBER.csv", row.names=FALSE)

### subset results from second common factor and write to csv file
CF2 <- CommonFactor[[2]]
write.csv(CF2, file="./results/F2_sumstats/NUMBER.csv", row.names=FALSE)

### subset results from third common factor and write to csv file
CF3 <- CommonFactor[[3]]
write.csv(CF3, file="./results/F3_sumstats/NUMBER.csv", row.names=FALSE)