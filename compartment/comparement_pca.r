setwd("E:/PC_0628/TALL/figures_final_0718/manu+figure/figure1/compartment")
datamatrix=read.table("compartment_score.txt",header = TRUE,stringsAsFactors = FALSE)
datamatrix2=read.table("compartment_score.txt",header =FALSE,stringsAsFactors = FALSE)
names(datamatrix)=datamatrix2[1,]
datamatrix=datamatrix[,4:ncol(datamatrix)]
dim(datamatrix)
datamatrix=na.omit(datamatrix)
dim(datamatrix)

info=read.table("E:/PC_0628/TALL/figures_final_0718/manu+figure/sampleinfo2.txt",sep="\t",header = TRUE,stringsAsFactors = TRUE)
annotation=info$condition[match(names(datamatrix),info$sample)]
annotation=data.frame(class=factor(annotation,levels=c("ETP","non-ETP","normal")),type=info$type[match(names(datamatrix),info$sample)])
names(datamatrix)=info$sample2[match(names(datamatrix),info$sample)]
row.names(annotation)=names(datamatrix)
# pos=which(row.names(annotation)!="97" &row.names(annotation)!="93")
 pos=which(row.names(annotation)!="93")

annotation=annotation[pos,]
datamatrix=datamatrix[,pos]
library("pheatmap")
## PCA
datamatrix2 <- t(datamatrix)
PCA_result <- prcomp(datamatrix2,scale = T)
summary(PCA_result)
PCA_layout <- as.data.frame(PCA_result$x)
PCA_layout$type=annotation[match(row.names(PCA_layout),row.names(annotation)),1]
PCA_layout$sample=row.names(PCA_layout)
#PCA_layout=PCA_layout[PCA_layout$type!="normal",]
library(ggplot2)
library("ggrepel")
# pdf("PCA_compartment_ori.pdf",width=5,height=4)
# qplot(x=PC1, y=PC2, data = PCA_layout, color=type,
#       xlab = "PC1 (20.31% variance)", ylab = "PC2 (16.41% variance)")+scale_colour_manual(values =c("#F8766D","#7CAE00","#E29D13"))+theme(plot.title=element_text(hjust=0.5,size = 25),
#                                                                                                                                           axis.title = element_text(size=20),                                                                                                                                     axis.text = element_text(size = 20),legend.text = element_text(size = 15),                                                                                                                                          legend.title= element_text(size = 15))+geom_point(size=3.5)+
#   theme_set(theme_bw())+
#   theme(panel.grid.major=element_line(colour=NA))+geom_point(size=3)+geom_text(aes(label=sample),vjust = -1,size = 3.5) #,
# dev.off()

# pdf("PCA_compartment_omoit097_093.pdf",width=5,height=4)
# qplot(x=PC1, y=PC2, data = PCA_layout, color=type,
#       xlab = "PC1 (19.92% variance)", ylab = "PC2 (17.26% variance)")+scale_colour_manual(values =c("#F8766D","#7CAE00","#E29D13"))+theme(plot.title=element_text(hjust=0.5,size = 25),
#                                                                                                                                           axis.title = element_text(size=20),                                                                                                                                     axis.text = element_text(size = 20),legend.text = element_text(size = 15),                                                                                                                                          legend.title= element_text(size = 15))+geom_point(size=3.5)+
#   theme_set(theme_bw())+
#   theme(panel.grid.major=element_line(colour=NA))+geom_point(size=3)+geom_text(aes(label=sample),vjust = -1,size = 3.5) #,
# dev.off()


pdf("PCA_compartment_omoit093.pdf",width=5,height=4)
qplot(x=PC1, y=-PC2, data = PCA_layout, color=type,
      xlab = "PC1 (20.83% variance)", ylab = "PC2 (16.90% variance)")+scale_colour_manual(values =c("#F8766D","#7CAE00","#E29D13"))+theme(plot.title=element_text(hjust=0.5,size = 25),
                                                                                                                                          axis.title = element_text(size=20),                                                                                                                                     axis.text = element_text(size = 20),legend.text = element_text(size = 15),                                                                                                                                          legend.title= element_text(size = 15))+geom_point(size=3.5)+
  theme_set(theme_bw())+
  theme(panel.grid.major=element_line(colour=NA))+geom_point(size=3)+geom_text(aes(label=sample),vjust = -1,size = 3.5) #,
dev.off()

