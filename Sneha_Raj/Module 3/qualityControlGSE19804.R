library(GEOquery)

library(affy)
library(affyPLM)
library(simpleaffy)
library(arrayQualityMetrics)
library(affyQCReport)
library(sva)

library(ggplot2)
library(pheatmap)
library(limma)


metadata <- read.csv(file="/Users/Siya/Desktop/StemAway/MetadataGSE19804.csv", row.names=1)
#Load unzipped data into R environment
gse <- ReadAffy(compress=TRUE, celfile.path="/Users/Siya/Desktop/StemAway/Unit 2/GSE19804_RAW")



#Mod 3 Step 2: Conduct quality control (QC) using Bioconductor packages and data visualization
  #a. QC plot using simpleaffy
qcs <- qc(gse)
plot(qcs)

  #b. Create an HTML report using arrayQualityMetrics --> takes really long to run
arrayQualityMetrics(gse, outdir = "arrayQualityMetrics Report for GSE19804", force = TRUE, do.logtransform = TRUE)

  #c. 6-page report using affyQCReport
QCReport(gse, file="QCReport for GSE19804.pdf")

  #d. Plot boxplots of the RLE (Relative Log Expression) and NUSE (Normalized Unscaled Standard Error) scores using affyPLM
pset <- fitPLM(gse, normalize = TRUE, background = TRUE)
RLE(pset, main="RLE for GSE19804")
NUSE(pset, main="NUSE for GSE19804")



#Mod 3 Step 3: Background correction and normalization
  #b. rma() background correction
#rma <- rma(gse)
#write.csv(exprs(rma), "/Users/Siya/Desktop/StemAway/gsenorm2.csv")
rma <- read.csv("/Users/Siya/Desktop/StemAway/gsenorm2.csv", row.names=1)


#Mod 3 Step 4: Batch Correction --> not needed because only one data set in this case
#model <- model.matrix(~CN, metadata)
#bc <- ComBat(norm, metadata$BATCH, model)



#Mod 3 Step 5: Create data visualizations comparing your data at different steps
  #a. boxplot
boxplot(gse, main="Raw", ylab="Probe Intensities", las=2, col=c("red", "orange", "yellow", "green", "blue", "purple"))
boxplot(rma, main="After Normalization", ylab="Probe Intensities", las=2, col=c("red", "orange", "yellow", "green", "blue", "purple"))

  #b. Principal Component Analysis
group <- as.factor(metadata$CN)

pca_raw <- prcomp(exprs(gse), scale=F, center=F)
pca_raw <- as.data.frame(pca_raw$rotation)
ggplot(pca_raw, aes(x=PC1, y=PC2, color=group))+ geom_point()+ stat_ellipse()+ labs(title="PCA Raw")

pca_norm <- prcomp(rma, scale=F, center=F)
pca_norm <- as.data.frame(pca_norm$rotation)
ggplot(pca_norm, aes(x=PC1, y=PC2, color=group))+ geom_point()+ stat_ellipse()+labs(title="PCA: Normalized")

  #c. Correlation Heatmaps
cor_raw <- 1-cor(exprs(gse))
pheatmap(cor_raw, main="Raw Data Heatmap", labels_col=metadata$Sample_geo_accession)

cor_norm <- 1-cor(rma)
pheatmap(cor_norm, main="Normalized Data Heatmap", labels_col=metadata$Sample_geo_accession)
