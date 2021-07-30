#R version 4.0.5 (03/31/2021)
#DGE Analysis
#GitHub ID: sneha-mr

library(affy)

library(ggplot2)
library(EnhancedVolcano) #does not work with Biocinuctor 3.12 (cannot update because Mac does not support R 5.1.0)
library(pheatmap)
library(limma)
library(hgu133plus2.db)
library(WGCNA)

library(cluster)




metadata <- read.csv(file="/Users/Siya/Desktop/StemAway/MetadataGSE19804.csv", row.names=1)
gse <- ReadAffy(compress=TRUE, celfile.path="/Users/Siya/Desktop/StemAway/Unit 2/GSE19804_RAW")
rma <- read.csv("/Users/Siya/Desktop/StemAway/gsenorm2.csv", row.names=1)




# Calculating IACs for all pairs of samples and examining the distribution of IACs in the dataset
# source: https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/HumanBrainTranscriptome/Identification%20and%20Removal%20of%20Outlier%20Samples.pdf

IAC=cor(rma,use="p")
hist(IAC,sub=paste("Mean=",format(mean(IAC[upper.tri(IAC)]),digits=3)))
# IAC Mean = 0.931

# Performing hierachical clustering (average linkage) using 1-IAC as a distance metric:
cluster1=hclust(as.dist(1-IAC),method="average")
plot(cluster1,cex=0.7,labels=dimnames(rma)[[2]])

# Another way to visualize outliers is to calculate the mean IAC for each array and examine this distribution:
meanIAC=apply(IAC,2,mean)
sdCorr=sd(meanIAC)
numbersd=(meanIAC-mean(meanIAC))/sdCorr
plot(numbersd)
abline(h=-2)
# prints the outliers
sdout=-2
outliers=dimnames(rma)[[2]][numbersd<sdout]
outliers
# [1] "GSM494571.CEL.gz" "GSM494572.CEL.gz" "GSM494582.CEL.gz" "GSM494591.CEL.gz" "GSM494596.CEL.gz"
# [6] "GSM494654.CEL.gz" "GSM494657.CEL.gz"

# remove outliers
# rma2=rma[,numbersd>sdout]
# write.csv(rma2, "/Users/Siya/Desktop/StemAway/gsenorm-nooutlier2.csv")
rma2 <- read.csv("/Users/Siya/Desktop/StemAway/gsenorm-nooutlier2.csv", row.names=1)
metadata_no <- read.csv("/Users/Siya/Desktop/StemAway/MetadataGSE19804-NoOutliers.csv", row.names=1)

# PCA for comparison
# group_no <- as.factor(metadata$CN)
# pca_norm2 <- prcomp(rma2, scale=F, center=F)
# pca_norm2 <- as.data.frame(pca_norm2$rotation)
# ggplot(pca_norm2, aes(x=PC1, y=PC2, color=group_no))+ geom_point()+ stat_ellipse()+labs(title="PCA: Normalized, No Outliers")




# Annotation
rma_rownames <- rownames(rma2)
ann_data <- select(hgu133plus2.db, keys=rma_rownames, columns="SYMBOL")
# remove duplicate PROBEIDs
ann_data <- ann_data[!duplicated(ann_data$PROBEID),]
rownames(ann_data) <- ann_data$PROBEID
merged_data <- merge(ann_data, rma2, by="row.names")
# remove duplicate SYMBOLS
merged_data <- merged_data[!duplicated(merged_data$SYMBOL),]
# remove duplicate NAs
merged_data <- na.omit(merged_data)
rownames(merged_data) <- merged_data$SYMBOL
gdata <- merged_data[-c(1,2,3)]




# Gene filtering
row_mean <- rowMeans(gdata)
filtered <- gdata[which(row_mean > 0.02),]




# Limma
mod <- model.matrix(~CN, metadata_no)
linear_mod <- lmFit(filtered, mod)
eBayes_opt <- eBayes(fit=linear_mod)
DEG <- topTable(eBayes_opt, p.value = 0.05, adjust.method = "fdr",  sort.by = "P", gene=rownames(filtered), number = 10000)
# Write out the differential expression results to a file sorted by adjusted p-value
write.csv(eBayes_opt$p.value, "/Users/Siya/Desktop/StemAway/Sneha_Raj/Module 4/Differential Expression P-val.csv")
# Report the number of significant genes with an adjusted p-value < 0.05. This will be useful for quickly determining correctness and identifying possible errors.
write.csv(DEG, "/Users/Siya/Desktop/StemAway/Sneha_Raj/Module 4/Significant Genes P-val 5%.csv")




# Data Visualization: Volcano Plot
# source: https://biocorecrg.github.io/CRG_RIntroduction/volcano-plots.html
DEG$diffexpressed <- "NO"
DEG$diffexpressed[DEG$logFC > 0.6 & DEG$P.Value < 0.05] <- "UP"
DEG$diffexpressed[DEG$logFC < -0.6 & DEG$P.Value < 0.05] <- "DOWN"

DEG$delabel <- NA
DEG$delabel[DEG$diffexpressed != "NO"] <- DEG$ID[DEG$diffexpressed != "NO"]

ggplot(data=DEG, aes(x=logFC, y=-log10(P.Value), col=diffexpressed, label=delabel)) + geom_point()+ labs(title="Volcano Plot of DEG") + theme_minimal() + geom_text() + scale_color_manual(values=c("blue", "black", "red")) + geom_vline(xintercept=c(-0.6, 0.6), col="red") + geom_hline(yintercept=-log10(0.05), col="red")

# EnhancedVolcano does not work with this version of R --> cannot update because R 5.1.0 is not compatible with Mac OS w/ M1
# EnhancedVolcano(toptable=DEG, x="logFC", y = "adj.P.Val", lab=DEG$ID, xlab = "Log2 Fold Change", ylab = "-Log10 b", title = "DEG Volcano Plot")




# Data Visualization: Heat Map
DEG_50 <- topTable(eBayes_opt, number=50)
filtered <- data.frame(filtered[rownames(filtered) %in% rownames(DEG_50),])
group_no <- data.frame(Tissue=metadata_no$CN)
rownames(group_no) <- colnames(filtered)
pheatmap(filtered, main="Heatmap of Top 50 DEG", labels_row = rownames(filtered),  labels_col = colnames(filtered), annotation_col=group_no, annotation_colors=list(Tissue=c(Cancer="red", Normal="blue")), cluster_rows=TRUE)




