### Read in summary statistics for latent factor which you wish to calculate Neff for
factor <- read.csv(paste(Sys.getenv("results_dir"),"F",Sys.getenv("i"),"_sumstats.csv", sep = ""), header = TRUE)

### Restrict to MAF of 40% and 10%
factor<-subset(factor, factor$MAF <= .4 & factor$MAF >= .1)

### Calculate Neff using equation from Mallard et al.
Effective_N<-(mean(((factor$Z_Estimate/factor$est)^2)/(2*factor$MAF*(1-factor$MAF))))

### Save Neff estimate to file
write.table(Effective_N, file=paste(Sys.getenv("results_dir"),"F",Sys.getenv("i"),"_Neff.txt", sep = ""))
