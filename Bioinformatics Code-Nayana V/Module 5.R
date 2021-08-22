#install necessary packages 
BiocManager::install('org.Hs.eg.db')
BiocManager::install('clusterProfiler')
BiocManager::install('enrichplot')
BiocManager::install('msigdb')
install.packages("magrittr")
install.packages("tidyr")
install.packages("ggnewscale")

#load libraries of necessary packages 
library(org.Hs.eg.db)
library(clusterProfiler)
library(enrichplot)
library(msigdb)
library(magrittr)
library(tidyr)
library(ggnewscale)


#Generating DEG Vector 
DEGtoptable <- read.csv(file="Module 4 Outputs/DEGtopTable.csv")
DEGtoptable <- as.data.frame(DEGtoptable)
DEGlog_FC <- DEGtoptable$logFC
names(DEGlog_FC) <- DEGtoptable$ID
DEGlog_FC <- DEGlog_FC[DEGlog_FC>=1.5]
DEGlog_FC <- sort(DEGlog_FC,decreasing=TRUE)
ENTREZIDVector <- AnnotationDbi::select(org.Hs.eg.db, keys = names(DEGlog_FC), columns = "ENTREZID", keytype = "SYMBOL")


#Functional Enrichment Analysis 

#Gene Ontology 
gene_ontmf <- enrichGO(ENTREZIDVector$ENTREZID, OrgDb = org.Hs.eg.db, ont = "MF",readable = T)
barplot(gene_ontmf)
gene_ontcc <- enrichGO(ENTREZIDVector$ENTREZID, OrgDb = org.Hs.eg.db, ont = "CC",readable = T)
barplot(gene_ontcc)
gene_ontbp <- enrichGO(ENTREZIDVector$ENTREZID, OrgDb = org.Hs.eg.db, ont = "BP",readable = T)
barplot(gene_ontbp)

#KEGG
KEGG <- enrichKEGG(ENTREZIDVector$ENTREZID)
dotplot(KEGG)


#Gene Concept Network 
conversion <- setReadable(KEGG,OrgDb = org.Hs.eg.db, keyType = "ENTREZID")
cnetplot(conversion,foldChange = DEGlog_FC,categorySize="pvalue")

#GSEA
GSEA19804 <- read.gmt("h.all.v7.4.entrez.gmt")

#Generating GLobal DEG Vector
globalvec <- AnnotationDbi::select(org.Hs.eg.db, keys = DEGtoptable$ID, columns = "ENTREZID", keytype = "SYMBOL")
globalvec <- globalvec %>% distinct(SYMBOL, .keep_all=TRUE)
rownames(globalvec) <- globalvec$SYMBOL
rownames(DEGtoptable) <- DEGtoptable$ID
mergeENTREtop<- merge(globalvec,DEGtoptable,by="row.names")
rownames(mergeENTREtop) <- mergeENTREtop$SYMBOL
mergeENTREtop <- mergeENTREtop[-c(1)]
globalvec_logFC <- mergeENTREtop$logFC
names(globalvec_logFC) <- mergeENTREtop$ENTREZID
globalvec_logFC <- sort(globalvec_logFC,decreasing=TRUE)

#GSEA Analysis 
gseaanalysis <- GSEA(globalvec_logFC, TERM2GENE = GSEA19804)

#GSEA Plot 
gseaplot2(gseaanalysis, geneSetID = 1:5)
gseaanalysis@result$ID



#Transcription Factor Analysis
c3_gene_collec <- enricher(ENTREZIDVector$ENTREZID, TERM2GENE = GSEA19804)
c3_gene_ID_to_Symbols <- setReadable(c3_gene_collec, OrgDb = org.Hs.eg.db, keyType = "ENTREZID")
cnetplot(c3_gene_ID_to_Symbols, foldChange = globalvec_logFC, categorySize="pvalue")

#Preparation for External Tools 
write(ENTREZIDVector$SYMBOL, file = "External Tools.txt")
