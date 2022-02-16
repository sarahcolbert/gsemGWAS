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

### identify model
### use unit loading identification
model <- 'F1 =~ Trait1 + Trait2
             F2 =~ Trait3
             F3 =~ Trait4 + Trait5
             F1~~F3
             F2~~F3
             F1~~F2
             F1~SNP
             F2~SNP
             F3~SNP'

### run a user model for one subset of SNPs
CommonFactor <- userGWAS(covstruc=LDSCoutput, SNPs=split_sumstats, model=model, sub=c("F1~SNP", "F2~SNP", "F3~SNP"), parallel = FALSE)

### subset results from first common factor and write to csv file
CF1 <- CommonFactor[[1]]
write.csv(CF1, file=paste(Sys.getenv("results_dir"),"F1_sumstats/",Sys.getenv("cc"),".csv", sep = ""), row.names=FALSE)

### subset results from second common factor and write to csv file
CF2 <- CommonFactor[[2]]
write.csv(CF2, file=paste(Sys.getenv("results_dir"),"F2_sumstats/",Sys.getenv("cc"),".csv", sep = ""), row.names=FALSE)

### subset results from third common factor and write to csv file
CF3 <- CommonFactor[[3]]
write.csv(CF3, file=paste(Sys.getenv("results_dir"),"F3_sumstats/",Sys.getenv("cc"),".csv", sep = ""), row.names=FALSE)
