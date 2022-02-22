## print header
head -1 ${results_dir}CF_sumstats.csv > ${results_dir}CF_sumstats_cleaned.csv

## pull out signifiant Qsnps
awk -F"," '$17<5e-8' ${results_dir}CF_sumstats.csv > ${results_dir}qsnps.csv

## print sumstats removing sig QSNPs
awk -F"," '$17>5e-8' ${results_dir}CF_sumstats.csv >> ${results_dir}CF_sumstats_cleaned.csv
