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
library(magrittr)
library(ggnewscale)




# ---- Data Importation ----

# get raw data
getGEOSuppFiles("GSE66272")
list.files("GSE66272")
untar("GSE66272/GSE66272_RAW.tar", exdir = "GSE66272/CEL")
list.files("GSE66272/CEL")
# use oligo pkg to read in multiple files using a vector
raw_data <- read.celfiles(list.files("GSE66272/CEL", full = TRUE))
# Create data frame & export colnames for metadata
df <- as.data.frame(exprs(raw_data))
write.csv(colnames(df), "/Users/Siya/Desktop/StemAway/Final Project/premeta.csv")




# ---- Quality Control ----

# import metadata
metadata <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/MetadataGSE66272.csv", row.names=1)
# Plot boxplots of the RLE (Relative Log Expression) and NUSE (Normalized Unscaled Standard Error) scores
PLM_data <- fitProbeLevelModel(raw_data, normalize = TRUE, background = TRUE)
RLE(PLM_data, main="RLE - GSE66272")
NUSE(PLM_data, main="NUSE - GSE66272")

# rma background correction & normalization
# use oligo::rma() to specify version of rma
rma_data <- rma(raw_data)
write.csv(exprs(rma_data), "/Users/Siya/Desktop/StemAway/Final Project/norm_data.csv")
rma_data <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/norm_data.csv", row.names=1)

#principal component analysis (PCA)
group <- as.factor(metadata$CN)

pca_raw <- prcomp(exprs(raw_data), scale=F, center=F)
pca_raw <- as.data.frame(pca_raw$rotation)
ggplot(pca_raw, aes(x=PC1, y=PC2, color=group))+ geom_point()+ stat_ellipse()+ labs(title="PCA Raw - GSE98979")

pca_norm <- prcomp(rma_data, scale=F, center=F)
pca_norm <- as.data.frame(pca_norm$rotation)
ggplot(pca_norm, aes(x=PC1, y=PC2, color=group))+ geom_point()+ stat_ellipse()+labs(title="PCA Normalized - GSE98979")




# ---- Statistical/DGE Analysis ----

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
# "GSM1618415_K235_NC.CEL.gz" "GSM1618435_K770_NC.CEL.gz" "GSM1618437_K779_NC.CEL.gz"
# remove outliers (no = no outliers)
no_data=rma_data[,numbersd>sdout]
write.csv(no_data, "/Users/Siya/Desktop/StemAway/Final Project/no_outlier_data.csv")
no_data <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/no_outlier_data.csv", row.names=1)
no_metadata <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/no_outlier MetadataGSE66272.csv", row.names=1)

# Annotation
rma_rownames <- rownames(no_data)
ann_data <- AnnotationDbi::select(hgu133plus2.db, keys=rma_rownames, columns="SYMBOL")
# remove duplicate PROBEIDs
ann_data <- ann_data[!duplicated(ann_data$PROBEID),]
rownames(ann_data) <- ann_data$PROBEID
merged_data <- merge(ann_data, no_data, by="row.names")
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
mod <- model.matrix(~CN, no_metadata)
linear_mod <- lmFit(filtered, mod)
eBayes_opt <- eBayes(fit=linear_mod)
DEG <- topTable(eBayes_opt, p.value = 0.05, adjust.method = "fdr",  sort.by = "P", gene=rownames(filtered), number = 10000)
# Write out the differential expression results to a file sorted by adjusted p-value
write.csv(eBayes_opt$p.value, "/Users/Siya/Desktop/StemAway/Final Project/Differential Expression P-val.csv")
# Report the number of significant genes with an adjusted p-value < 0.05. 
# This will be useful for quickly determining correctness and identifying possible errors.
write.csv(DEG, "/Users/Siya/Desktop/StemAway/Final Project/Significant Genes P-val 5%.csv")

# Data Visualization: Heat Map
DEG_50 <- topTable(eBayes_opt, number=50)
filtered <- data.frame(filtered[rownames(filtered) %in% rownames(DEG_50),])
group_no <- data.frame(Tissue=no_metadata$CN)
rownames(group_no) <- colnames(filtered)
pheatmap(filtered, main="Heatmap of Top 50 DEG", labels_row = rownames(filtered),  labels_col = colnames(filtered), annotation_col=group_no, annotation_colors=list(Tissue=c(Cancer="red", Normal="blue")), cluster_rows=TRUE)

# List of DEGs as a table
write.csv(DEG, "/Users/Siya/Desktop/StemAway/Final Project/topTable.csv")

# Top 50 DEGs sorted by FC
write.csv(DEG_50, "/Users/Siya/Desktop/StemAway/Final Project/top50DEGs.csv")
top50_logFC <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/top50DEGs.csv")[ ,c('logFC')]
names(top50_logFC) <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/top50DEGs.csv")[ ,c('ID')]
top50_logFC <- top50_logFC[top50_logFC>=1.5]
top50_logFC <- sort(top50_logFC, decreasing = TRUE)
write.csv(top50_logFC, "/Users/Siya/Desktop/StemAway/Final Project/sorted_top50_logFC.csv")



# ---- Functional Analysis ----

# Generate DEG vector
top_logFC <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/topTable.csv")[ ,c('logFC')]
names(top_logFC) <- read.csv("/Users/Siya/Desktop/StemAway/Final Project/topTable.csv")[ ,c('ID')]
#upregulated only b/c only positive values
top_logFC <- top_logFC[top_logFC>=1.5]
top_logFC <- sort(top_logFC, decreasing = TRUE)
ann_logFC <- AnnotationDbi::select(org.Hs.eg.db, keys=names(top_logFC), columns=c("ENTREZID"), keytype="SYMBOL")

# Functional enrichment analysis
# Gene Ontology - gene functions related to broader concepts
# CC - cellular components, BP - biological processes, and MF - molecular functions
ego <- enrichGO(ann_logFC$ENTREZID, OrgDb=org.Hs.eg.db, keyType="ENTREZID", ont="BP", readable=TRUE)
barplot(ego)
ego2 <- enrichGO(ann_logFC$ENTREZID, OrgDb=org.Hs.eg.db, keyType="ENTREZID", ont="MF", readable=TRUE)
barplot(ego2)
ego3 <- enrichGO(ann_logFC$ENTREZID, OrgDb=org.Hs.eg.db, keyType="ENTREZID", ont="CC", readable=TRUE)
barplot(ego3)
# KEGG - database high-level pathway functions in a biological system --> in this case at the cellular level
enrich <- enrichKEGG(ann_logFC$ENTREZID)
dotplot(enrich, title="Enriched KEGG Pathways")

# GSEA (gene set enrichment analysis)
# purpose: associate gene exp to diff cellular/molecular processes.
# determine whether the members in a particular gene set are randomly distributed or at top/bottom of the ranked list.
# If they show the latter distribution, the gene set is correlated with the phenotypic class distinction
hgs_etz <- read.gmt("/Users/Siya/Desktop/StemAway/GSEA Hallmark Gene Sets/h.all.v7.4.entrez.gmt")
hgs_sym <- read.gmt("/Users/Siya/Desktop/StemAway/GSEA Hallmark Gene Sets/h.all.v7.4.symbols.gmt")

# generating global DEG vector named by ENTREZID
nodupe_data <- AnnotationDbi::select(org.Hs.eg.db, keys=DEG$ID, columns=c("ENTREZID"), keytype="SYMBOL")
nodupe_data <- nodupe_data[!duplicated(nodupe_data$SYMBOL),]
rownames(DEG) <- nodupe_data$ENTREZID
FC_data <- DEG[ ,c('logFC')]
names(FC_data) <- rownames(DEG)
FC_data <- sort(FC_data, decreasing = TRUE)

# GSEA analysis
gsea_res <- GSEA(FC_data, TERM2GENE=hgs_etz)
# can identify possible gene sets to plot using: gsea_res@result$ID
gseaplot2(gsea_res, geneSetID=1:8)

# Transcription factor analysis - look at factors (microRNAs and lncRNAs) to see how genes are regulated
# Analyze the C3 Gene Set Collection & Convert ENTREZIDs to Gene Symbols
c3_set <- enricher(ann_logFC$ENTREZID, TERM2GENE=hgs_etz)
c3_convert <- setReadable(c3_set, OrgDb=org.Hs.eg.db , keyType="ENTREZID")
# gene-concept network of transcription factors
cnetplot(c3_convert, foldChange=FC_data, categorySize="pvalue", colorEdge=TRUE)

# Prep for external tools: exports a list of the gene symbols of DEGs --> for functional analysis with online tools
write(names(top_logFC), "/Users/Siya/Desktop/StemAway/Final Project/Upreg DEGs.txt")
