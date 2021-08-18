# R version 4.0.5 (2021-03-31)
# GitHub ID: sneha-mr




# ---- Install Packages ----

  # BiocManager::install("") to install packages
library(oligo)
library(GEOquery)

library(ggplot2)
library(pheatmap)
library(limma)

library(org.Hs.eg.db)
library(clusterProfiler)
library(enrichplot)

library(hgu133plus2.db)
library(WGCNA)
library(cluster)




# ---- Data Importation ----

  # get raw data
getGEOSuppFiles("GSE98979")
list.files("GSE98979")
untar("GSE98979/GSE98979_RAW.tar", exdir = "GSE98979/CEL")
list.files("GSE98979/CEL")
  # use oligo pkg to read in multiple files using a vector
raw_data <- read.celfiles(list.files("GSE98979/CEL", full = TRUE))
  # Create data frame & export colnames for metadata
df <- as.data.frame(exprs(raw_data))
View(head(df))
write.csv(colnames(df), "/Users/Siya/Desktop/StemAway/Final Project/premeta.csv")




# ---- Quality Control ----

  # import metadata
metadata <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/MetadataGSE98979.csv", row.names=1)
  # Plot boxplots of the RLE (Relative Log Expression) and NUSE (Normalized Unscaled Standard Error) scores
PLM_data <- fitProbeLevelModel(raw_data, normalize = TRUE, background = TRUE)
RLE(PLM_data, main="RLE for GSE98979")
NUSE(PLM_data, main="NUSE for GSE98979")

  # rma background correction & normalization
    # use oligo::rma() to specify version of rma
# rma_data <- rma(raw_data)
# write.csv(exprs(rma_data), "/Users/Siya/Desktop/StemAway/Final Project/norm_data.csv")
rma_data <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/norm_data.csv", row.names=1)

  #principal component analysis (PCA)
group <- as.factor(metadata$CN)

pca_raw <- prcomp(exprs(raw_data), scale=F, center=F)
pca_raw <- as.data.frame(pca_raw$rotation)
ggplot(pca_raw, aes(x=PC1, y=PC2, color=group))+ geom_point()+ stat_ellipse()+ labs(title="PCA Raw GSE98979")

pca_norm <- prcomp(rma_data, scale=F, center=F)
pca_norm <- as.data.frame(pca_norm$rotation)
ggplot(pca_norm, aes(x=PC1, y=PC2, color=group))+ geom_point()+ stat_ellipse()+labs(title="PCA Normalized GSE98979")




# ---- DGE Analysis ----

  # Identify & remove outliers
    # calculate the mean IAC for each array and examine this distribution:
    # source: https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/HumanBrainTranscriptome/Identification%20and%20Removal%20of%20Outlier%20Samples.pdf
IAC=cor(rma_data,use="p")
meanIAC=apply(IAC,2,mean)
sdCorr=sd(meanIAC)
numbersd=(meanIAC-mean(meanIAC))/sdCorr
plot(numbersd)
abline(h=-2)
    # prints the outliers
sdout=-2
outliers=dimnames(rma_data)[[2]][numbersd<sdout]
outliers
    # "GSM2629584_H1975_TGFb_48h_1.CEL.gz" "GSM2629585_H1975_TGFb_48h_2.CEL.gz" "GSM2629586_H1975_TGFb_48h_3.CEL.gz"
    # However, these are likely not outliers because they all represent the TGFb 48h sample
    # No outliers are removed

  # Annotation
rma_rownames <- rownames(rma_data)
ann_data <- AnnotationDbi::select(hgu133plus2.db, keys=rma_rownames, columns="SYMBOL")


# ---- Functional Analysis ----






