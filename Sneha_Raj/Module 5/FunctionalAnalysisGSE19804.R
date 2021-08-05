#R version 4.0.5 (03/31/2021)
#Functional Analysis
#GitHub ID: sneha-mr

library(org.Hs.eg.db)
library(clusterProfiler)
library(enrichplot)
library(msigdb) #does not work w R version

library(magrittr)
library(tinyr) #does not work w R version
library(ggnewscale)




# Generate DEG vector
  # logFC column from top table created in module 4
top_logFC <- read.csv("/Users/Siya/Desktop/StemAway/topTable.csv")[ ,c('logFC')]
names(top_logFC) <- read.csv("/Users/Siya/Desktop/StemAway/topTable.csv")[ ,c('ID')]
  #upregulated only b/c only positive values
top_logFC <- top_logFC[top_logFC>=1.5]
top_logFC <- sort(top_logFC, decreasing = TRUE)
ann_logFC <- AnnotationDbi::select(org.Hs.eg.db, keys=names(top_logFC), columns=c("ENTREZID"), keytype="SYMBOL")




# Functional enrichment analysis
  # Gene Ontology
ego <- enrichGO(ann_logFC$ENTREZID, OrgDb=org.Hs.eg.db, keyType="ENTREZID", ont="BP", readable=TRUE)
barplot(ego)
ego2 <- enrichGO(ann_logFC$ENTREZID, OrgDb=org.Hs.eg.db, keyType="ENTREZID", ont="MF", readable=TRUE)
barplot(ego2)
ego3 <- enrichGO(ann_logFC$ENTREZID, OrgDb=org.Hs.eg.db, keyType="ENTREZID", ont="CC", readable=TRUE)
barplot(ego3)
  # KEGG
enrich <- enrichKEGG(ann_logFC$ENTREZID)
dotplot(enrich, title="Enriched KEGG Pathways")




# Gene-concept network: depict linkage of genes in top 5 KEGG pathways
gsym <- setReadable(enrich, OrgDb=org.Hs.eg.db, keyType="ENTREZID")
cnetplot(gsym, foldChange=top_logFC, categorySize="pvalue", colorEdge=TRUE)




# GSEA
# purpose: associate gene exp to diff cellular/molecular processes. determine whether the members in a particular gene set are randomly distributed or at top/bottom of the ranked list.
# If they show the latter distribution, the gene set is correlated with the phenotypic class distinction
hgs_etz <- read.gmt("/Users/Siya/Desktop/StemAway/GSEA Hallmark Gene Sets/h.all.v7.4.entrez.gmt")
hgs_sym <- read.gmt("/Users/Siya/Desktop/StemAway/GSEA Hallmark Gene Sets/h.all.v7.4.symbols.gmt")
  # generating global DEG vector named by ENTREZID
top_data <- read.csv("/Users/Siya/Desktop/StemAway/topTable.csv")
nodupe_data <- AnnotationDbi::select(org.Hs.eg.db, keys=top_data$ID, columns=c("ENTREZID"), keytype="SYMBOL")
nodupe_data <- nodupe_data[!duplicated(nodupe_data$SYMBOL),]
rownames(top_data) <- nodupe_data$ENTREZID
FC_data <- top_data[ ,c('logFC')]
names(FC_data) <- rownames(top_data)
FC_data <- sort(FC_data, decreasing = TRUE)
  # GSEA analysis
gsea_res <- GSEA(FC_data, TERM2GENE=hgs_etz)
  # can identify possible gene sets to plot using: gsea_res@result$ID
gseaplot2(gsea_res, geneSetID=1:27)




# Transcription factor analysis
  #C3: Regulatory target gene sets
c3_set <- enricher(ann_logFC$ENTREZID, TERM2GENE=hgs_etz)
c3_convert <- setReadable(c3_set, OrgDb=org.Hs.eg.db , keyType="ENTREZID")
cnetplot(c3_convert, foldChange=FC_data, categorySize="pvalue", colorEdge=TRUE)




# Prep for external tools
write(top_logFC, "/Users/Siya/Desktop/StemAway/Sorted logFC.txt")
write(names(top_logFC), "/Users/Siya/Desktop/StemAway/Upreg DEGs.txt")

