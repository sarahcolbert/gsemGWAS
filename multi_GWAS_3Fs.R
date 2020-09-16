### load necessary packages
library(devtools)
require(GenomicSEM)
library(dplyr)

### load the summary statistics RData file in the split form
load("split_sumstats.RData")

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
CommonFactor <- userGWAS(covstruc=LDSCoutput, SNPs=split_sumstats[[NUMBER]], model=model, sub=c("F1~SNP", "F2~SNP", "F3~SNP"))

### remove unnecessary columns from the dataframe
CommonFactor[[1]]$free <- NULL
CommonFactor[[1]]$label <- NULL
CommonFactor[[1]]$lhs <- NULL
CommonFactor[[1]]$op <- NULL
CommonFactor[[1]]$rhs <- NULL

### remove any rows that produce a warning
CF1 <- filter(CommonFactor[[1]], warning==0)

write.table(CF1, file="./results/F1_sumstats/NUMBER.txt", row.names=FALSE, quote=FALSE)

### remove unnecessary columns from the dataframe
CommonFactor[[2]]$free <- NULL
CommonFactor[[2]]$label <- NULL
CommonFactor[[2]]$lhs <- NULL
CommonFactor[[2]]$op <- NULL
CommonFactor[[2]]$rhs <- NULL

### remove any rows that produce a warning
CF2 <- filter(CommonFactor[[2]], warning==0)

write.table(CF2, file="./results/F2_sumstats/NUMBER.txt", row.names=FALSE, quote=FALSE)

### remove unnecessary columns from the dataframe
CommonFactor[[3]]$free <- NULL
CommonFactor[[3]]$label <- NULL
CommonFactor[[3]]$lhs <- NULL
CommonFactor[[3]]$op <- NULL
CommonFactor[[3]]$rhs <- NULL

### remove any rows that produce a warning
CF3 <- filter(CommonFactor[[3]], warning==0)

write.table(CF2, file="./results/F3_sumstats/NUMBER.txt", row.names=FALSE, quote=FALSE)
