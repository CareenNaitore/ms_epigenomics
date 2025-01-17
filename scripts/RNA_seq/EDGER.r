#careen Naitore
#17.4.2022
# This script is for EdgeR Analysis
rm(list=ls())
library(edgeR)
rm(list=ls())
#Diseased_vs_control analysis

## Set working directory.
setwd("")

data <- read.delim("/home/icipe/Documents/careenwork/objectivethree/novelmiRNA/Rawdata/Rawcounts_data.csv", sep = "," , row.names = 1)
data2
Dieased_v_control=(data [ ,c( 2, 3, 4,5)])

rm("data")
write.csv(Adultmale_vs_wildtype, file = "/home/icipe/Documents/careenwork/objectivethree/novelmiRNA/Rawdata/Dieased_vs_control_DE_data.csv")
#creates a grouping factor which defines the sample types and replicates.
group <- factor(c("control", "control","Diseased","Diseased"))

#Define the reference value as Control.
group <- relevel(group,ref = "control")

#Create a EdgeR DGE list object which stores the counts for each gene per sample. The grouping factor is used to define the samples.
y <- DGEList(counts=diseased_vs_control[1:4],group=group)

#Generate a list with which to filter out genes with low expression values. To be included gene must have at least 1 count per million in at least 2 samples.
keep <- rowSums(cpm(y)>10) >= 2

#Use the keep list to remove genes with low expression values from the DGELIST object.
y <- y[keep, , keep.lib.sizes=FALSE]

#Calculate normalization factors for the DGELIST object.
y <- calcNormFactors(y)

#Print the samples, their respective library sizes and their nomalization factor.
y$samples

#Apply sample grouping to a data object.
design <- model.matrix(~group)

#Estimate dispersions for tags
y <- estimateDisp(y,design)

#Fit a generalized likelyhood model to the DGELIST using the Sample Grouping Data
fit <- glmFit(y,design)

#Perform likelyhood ratio test on to identify differentially expressed genes
lrt <- glmLRT(fit,coef = 2)

#Print the genes with the most significant differences.
topTags(lrt)
topGenes <- topTags(lrt, n=Inf)

#Output a summary of the top differentially expressed genes at 5% FDR
summary(de <- decideTestsDGE(lrt))

#Convert counts per million per gene to log counts per million for further downstream analyses.
logcpm <- cpm(y, prior.count = 10, log = TRUE)

#Create a data frame with final analysis data
Adultmale_vs_wildtype_DE_data <- topGenes$table
#create a data matrix with original count data 
counts <- fit$counts
#Convert data matrix to a data frame
countsdf <- as.data.frame(counts)
#Merge the analysis data with the original count data
Diseased_vs_control_data_combined <- merge(Dieased_vs_control_DE_data, countsdf, by="row.names")
#Add gene descriptions to data frame
#Extract gene subset used in the analysis
gene_names <- subset(Diseased_vs_control, keep)
#Append description data onto the data fram
Adultmale_vs_wildtype_data_combined$description <- gene_names$Description
Adultmale_vs_wildtype_data_combined$de <- de

#output the data frame to a csv file
write.csv(Diseased_vs_control_data_combined, file = "/home/icipe/Documents/careenwork/objectivethree/novelmiRNA/edgeranalysis/Diseased_vs_control_Analysis.csv")

#Extract the subset of upregulated genes from the gene names table
upregulated_genes <- subset(Diseased_vs_control_data_combined, PValue < 1E-3 & de == 1, select=c(Row.names, logCPM,logFC,PValue))
#Extract the subset of downregulated genes from the gene names table
downregulated_genes <- subset(Diseased_vs_control_data_combined, PValue < 1E-3 ,select=c(Row.names, logCPM,logFC, PValue))

#Plot log-fold change against log-counts per million, with differentially expressed genes highlighted
detags <- rownames(y)[as.logical(de)]
plotSmear(lrt, de.tags = detags, smooth.scatter = FALSE, pch= 16, cex= .7, lowess = FALSE, xlab = "Average log Counts per Million", ylab = "log Fold Change" , ylim=c(-10,10) , main = "low density control versus Diseased")
abline(h=c(-1,1),col="blue")
#Use the information in the up and downregulated genes tables to label the smear plot
#Label with Gene Identifiers
text(x=upregulated_genes$logCPM, y=upregulated_genes$logFC, labels = upregulated_genes$Row.names, cex = .5, pos=3)
text(x=downregulated_genes$logCPM, y=downregulated_genes$logFC, labels = downregulated_genes$Row.names, cex = .5, pos=1)

#Label with Gene Descriptions
text(x=upregulated_genes$logCPM, y=upregulated_genes$logFC, labels = upregulated_genes$Description, cex = .5, pos=3)
text(x=downregulated_genes$logCPM, y=downregulated_genes$logFC, labels = downregulated_genes$Description, cex = .5, pos=1)
