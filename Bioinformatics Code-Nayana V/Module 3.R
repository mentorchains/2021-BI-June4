#Loading Libraries of Necessary Packages
library(affy)
library(affyPLM)
library(simpleaffy)
library(arrayQualityMetrics)
library(affyQCReport)
library(sva)
library(ggplot2)
library(pheatmap)
library(GEOquery)




#Quality Control 

#simpelaffay 
#qc analysis report assigned to object qcgse19804 
data19804 <- ReadAffy(celfile.path="data/", compress=TRUE)
qcgse19804 <- qc(data19804)
#visualization of qcgse19804
plot(qcgse19804)

#arrayQualityMetrics 
arrayQualityMetrics(data19804, force=T, do.logtransform=T)


#affyQCReport
QCReport(data19804,"affyQCReportforGEO19804.pdf")

#affyPLM
plmgse19804 <- fitPLM(data19804, normalize=T, background = T)
RLE(plmgse19804)
NUSE(plmgse19804)




#Normalization 
saveRDS(data19804, "Data/data19804.rds")
data19804 <- readRDS ("Data/data19804.rds")
memory.limit(size=1200)
gcrmadata19804 <- gcrma(data19804)
write.csv(exprs(gcrmadata19804),"gcrmadata19804.csv")
gcrmadata19804 <- read.csv("gcrmadata19804.csv", row.names=1)




#Data Visualization 

#boxplot
boxplot(gcrmadata19804, main="Normalized GSE19804 Data", xlab="Samples", ylab="Probe Intensities")




#PCA

#raw
pcadata19804_raw <- prcomp(exprs(data19804), scale=F, center=F)
pcadata19804_raw <- as.data.frame(pcadata19804_raw$rotation)
group <- as.factor(modmeta19804$Tissue)
ggplot(pcadata19804_raw, aes(x=PC1, y=PC2, color=group))+geom_point()+stat_ellipse()+ggtitle("Raw Data PCA Plot")


#normalized 
pcadata19804_norm <- prcomp(gcrmadata19804, scale=F, center=F)
pcadata19804_norm <- as.data.frame(pcadata19804_norm$rotation)
group <- as.factor(modmeta19804$Tissue)
ggplot(pcadata19804_norm, aes(x=PC1, y=PC2, color=group))+geom_point()+stat_ellipse()+ggtitle("Normalized Data PCA Plot")




#Heatmap
corrdata19804 <- 1-cor(gcrmadata19804)
group <- as.factor(modmeta19804$Tissue)
pheatmap(corrdata19804, main="Normalized GSE19804 Data Heatmap", labels_row = modmeta19804$Tissue, labels_col = modmeta19804$Sample)
