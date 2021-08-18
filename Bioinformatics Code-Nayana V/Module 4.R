#Downloading Necessary Packages 
BiocManager::install("hgu133plus2.db")
BiocManager::install("limma")
BiocManager::install("WGCNA")
install.packages("magrittr")
install.packages("dplyr")

#Loading Libraries of Necessary Packages
library(ggplot2)
library(pheatmap)
library(EnhancedVolcano)
library(hgu133plus2.db)
library(limma)
library(WGCNA)
library(magrittr)
library(dplyr)

#Outlier Removal 

#Mean IAC being calculated 
IAC=cor(gcrmadata19804, use="p")
hist(IAC,sub=paste("Mean=",format(mean(IAC[upper.tri(IAC
)]),digits=3))) 
#Mean = 0.935

#Visualizing Data Through Hierarchical Clustering 
library(cluster)
cluster1=hclust(as.dist(1-IAC),method="average")
plot(cluster1,cex=0.7,labels=dimnames(gcrmadata19804)[[2]]) 

#Visualizing Data by Plotting Mean IAC
meanIAC=apply(IAC,2,mean)
sdCorr=sd(meanIAC)
numbersd=(meanIAC-mean(meanIAC))/sdCorr
plot(numbersd)
abline(h=-2) 
#7 outliers detected 

#Identifying which samples are the outliers 
sdout=-2
outliers=dimnames(gcrmadata19804)[[2]][numbersd<sdout]
outliers
#The outlier samples are "GSM494571.CEL.gz", "GSM494572.CEL.gz", "GSM494582.CEL.gz" "GSM494591.CEL.gz", "GSM494596.CEL.gz" "GSM494654.CEL.gz", "GSM494657.CEL.gz"

#Removing the 7 sample outliers 
gcrmadata19804_no_out=gcrmadata19804[,numbersd>sdout]
dim(gcrmadata19804_no_out)

#Recalculating mean IAC 
IAC=cor(gcrmadata19804_no_out,use="p")
hist(IAC,sub=paste("Mean=",format(mean(IAC[upper.tri(IAC
)]),digits=3))) 
#Mean = 0.942


#Annotation 
hgu133plus2.db

#Vector of column information I can extract
columns(hgu133plus2.db)
#We are focusing on gene symbols, so that should be selected for columns 

#Keys = field/fields, criteria, which on the basis of rows are organized and retrieved; keys that select records
#Set the keys to be the probe IDs, which are the row names
probeIDs<- rownames(gcrmadata19804_no_out)

#Annotation of probe ID with gene symbol; data frame is returned
annotated19804 <- select(hgu133plus2.db, keys=probeIDs, columns = "SYMBOL")

#Remove duplicated probe IDs (rows) 
annotated19804 <-annotated19804 %>% distinct(PROBEID, .keep_all=TRUE)


#Remove NA Values
annotated19804 <- na.omit(annotated19804)

#Remove duplicated Symbols (rows)
annotated19804 <- annotated19804 %>% distinct(SYMBOL, .keep_all=TRUE)

#Set row names of the table to be the probe ID (as they are in columns right now,  helps w merging later on)
row.names(annotated19804)=annotated19804$PROBEID

#merge  
merge19804<- merge(annotated19804,gcrmadata19804_no_out,by="row.names")
row.names(merge19804)=merge19804$SYMBOL
merge19804 <- merge19804[-c(1,2,3)]



#Gene Filtering
rowmeans19804 <- rowMeans(merge19804)
filtered190804 <- merge19804[which(rowmeans19804>0.02),]


#Limma

modmeta19804 <- modmeta19804[-c(16,17,27,36,41,99,102),]
model19804 <- model.matrix(~Tissue, modmeta19804)
rownames(model19804) <- modmeta19804$Sample
linmodel19804 <- lmFit(filtered190804,model19804)
eBayes_out <- eBayes(fit=linmodel19804)
write.csv(eBayes_out$p.value,"Module 4 Outputs/eBayes_out.csv")
#adjuster p-value for significant genes 

#Generating topTable of DEG
DEGtoptable <- topTable(eBayes_out,p.value=0.05, adjust.method="fdr", sort.by="P", gene=rownames(filtered190804), number=20962)
write.csv(DEGtoptable,"Module 4 Outputs/DEGtopTable.csv")
#significant genes 

#Volcano Plot 
EnhancedVolcano(DEGtoptable,lab = rownames(DEGtoptable),pCutoff = 0.05,FCcutoff = 0.5,x = "logFC",y = "adj.P.Val",pointSize = 1,legendLabSize = 10,labSize = 3.0,title="Top DEG for GEO19804")

#Heat Map
DEG50_19804 <- topTable(eBayes_out,number=50)
filtered190804 <- data.frame(filtered190804[rownames(filtered190804) %in% rownames(DEG50_19804),])
pheatmap(filtered190804, main="Top 50 DEG Anylisis for GEO19804 DATA", labels_row = rownames(filtered190804), labels_col = colnames(filtered190804))