#Intro to R lesson
#March 14, 2021

#Interacting with R

#I am adding 3 and 5, R is fun!
3+5
x <- 3 
y <- 5
y
x+y
number <- x+y
x <- 5
number
glengths <- c(4.6, 3000, 50000)
glengths
species <- c("ecoli", "human", "corn")
expression <- c("low", "high", "medium", "high", "low", "medium", "high")
expression <- factor(expression)
df <- data.frame(species, glengths)
list1 <- list(species, df, number)
list1
glengths <- c(glengths, 90) #adding at the end
glengths <- c(30, glengths) #adding at the beginning
sqrt (81)
sqrt (glengths)
round(3.14159)
?round
args(round)
example(round)
round(3.14159,2)
mean(glengths)
sessionInfo()
install.packages('ggplot2')
library(ggplot2)
?read.csv
metadata <- read.csv(file="data/mouse_exp_design.csv")
head(metadata)
str(metadata)
length(metadata)
age <- c(15, 22, 45, 52, 73, 81)
age[5]
age[-5]
idx <- c(3,5,6)
age[idx]
age[1:4]
age[4:1]
age[age>50]
metadata
metadata[1,1]
metadata[1,3]
metadata [3,]
metadata[,3]
metadata[,1:2]
metadata[c(1,3,6),]
metadata[1,3,6]
metadata[1:3, "celltype"]
metadata$genotype
colnames(metadata)
names(metadata)
metadata$genotype[1:5]
metadata[,c("genotype","celltype")]
rownames(metadata)
metadata[c("sample10","sample12"),]
subset(metadata, celltype == "typeA")
subset(metadata, celltype == "typeA" & genotype == "Wt")
sub_meta <- subset(metadata, replicate < 3, select = c("genotype","celltype"))
list1
list1[[2]]
comp2 <- list1[[2]]
class(comp2)
write.csv(sub_meta, file="data/subset_meta.csv")
write(glengths,file="genome_lengths.txt",ncolumns=1)
DOT1L <- read.csv(file="data/DOT1L.csv", row.names = 1)
str(DOT1L)
plot(DOT1L$GSM2495022[1:100], main="GSM2495022",xlab = "position",ylab="value",type="l",col="purple")
lines(DOT1L$GSM2495029[202:300], type = 'p')
legend("topleft",c("GSM2495022","GSM2495029"),fill=c("blue","black"))
barplot(DOT1L$GSM2495022[1:10], main="GSM2495022",xlab="position")
barplot(DOT1L$GSM2495022[1:4], main="GSM2495022",horiz=TRUE, names.arg=c(1,2,3,4))
hist( x = DOT1L$GSM2495022, main = "GSM2495022's Histogram", xlab = "values", breaks = 18)
hist( x = DOT1L$GSM2495022,main = "GSM2495022's Histogram",xlab = "values",density = 10,angle = 40,border = "gray20", col = "gray80", labels = TRUE, ylim = c(0,2900))
summary(DOT1L$GSM2495021)
boxplot(DOT1L$GSM2495021)
suspicious.cases <- DOT1L$GSM2495021 < 1
which(suspicious.cases)
?par
plot(DOT1L$GSM2495021)
jpeg('rplot.jpg')
boxplot(df$GSM2495021)
dev.off()
dev.off()
install.packages("ggplot2")
library(ggplot2)
myplot <- ggplot(data = DOT1L, mapping = aes(x = GSM2495018, y = GSM2495020)) + geom_point(color = "cornflowerblue",alpha = .4,size = 1) +labs(title = "Gene Expression Profiles of B-lineage\nAdult Acute Lymphocytic Leukemia ",subtitle = "A simple plot",caption = "source: https:Whatever_You_Want",x = "GSM2495018",y = "GSM2495020") +theme_minimal()
myplot <- myplot + theme_dark()
myplot
newmetadata <- read.csv(file="data/new_metadata.csv", row.names = 1)
ggplot(new_metadata) + geom_point(aes(x = age_in_days, y= samplemeans, color=genotype, shape=celltype), size=3.0) +  theme_bw()+theme(axis.text = element_text(size=rel(1.5)),axis.title = element_text(size=rel(1.5))) + xlab("Age(days)")+ylab("Mean Expression")
pdf("C:/Users/nayanav/Desktop/Intro-to-R/data//scatterplot.pdf")
ggplot(new_metadata) + geom_point(aes(x = age_in_days, y= samplemeans, color=genotype, shape=celltype), size=3.0) +  theme_bw()+theme(axis.text = element_text(size=rel(1.5)),axis.title = element_text(size=rel(1.5))) + xlab("Age(days)")+ylab("Mean Expression")
dev.off()
dev.off()
png("yaymyownboxplot.png")
ggplot(newmetadata)+geom_boxplot(aes(x=genotype, y=samplemeans, fill=celltype))+labs(title="Genotype vs Sample Means")+xlab("Genotype")+ylab("Mean expression")+theme(axis.text = element_text(size=rel(1.25)), axis.title = element_text(size=rel(1.25)), plot.title=element_text(hjust=0.5))
png("yaymyownboxplotwtheme.png")
ggplot(newmetadata)+geom_boxplot(aes(x=genotype, y=samplemeans, fill=celltype))+labs(title="Genotype vs Sample Means")+xlab("Genotype")+ylab("Mean expression")+theme(axis.text = element_text(size=rel(1.25)), axis.title = element_text(size=rel(1.25)), plot.title=element_text(hjust=0.5))+theme_classic()
dev.off()
dev.list()
#Another way to add a title is: ggtitle("Title here") 
#row.names=the column in which row names are in 
install.packages("BiocManager") 
BiocManager::install('EnhancedVolcano')
library(EnhancedVolcano)
rownames(DOT1L) <- DOT1L$ID
png("myfirstvolcanoplot.png")
volcano_plot <- EnhancedVolcano(DOT1L, lab = rownames(DOT1L),pCutoff = 0.05,FCcutoff = 0.5,x = "logFC",y = "adj.P.Val",pointSize = 1,legendLabSize = 10,xlim = c(-3, 3 ),ylim = c(0, 7),labSize = 3.0)
dev.off()
volcano_plot











                                
