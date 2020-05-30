# # ## total
# args=c("/data02/fchen/TALL/all_results/compartment/","TALL_0527")
# sample = list.files(path = args[1])
# sample=c("093-N","124-N","076-N","077-N","097-N","098-N","107-N","117-N","108-N","115-N","102-N","103-N","MXYL-N","116-N","118-N","121-N","122-N","123-N","WYL","YL","ZHC","ZK2")
# #sample=c("093-N","124-N","076-N","077-N","097-N","098-N","107-N","117-N","108-N","115-N","102-N","103-N","MXYL-N","116-N","118-N","121-N","122-N","123-N","WYL","YL","ZHC","ZK2",
# #"CEM","CUTLL1","Jurkat","KE-37","LOUCY","MOLT-16","MOLT-4")
# dir = paste(args[1],"/",sample,"_pc1_ori.bdg",sep = "")
# n <- length(sample)
# datamatrix <- read.table(file =dir[1],stringsAsFactors=FALSE)
# for (jj in 2:n) {
#   data <- read.table(file = dir[jj],stringsAsFactors=FALSE)
#   datamatrix <- cbind(datamatrix, data[,4])
# }
# datamatrix=as.data.frame(datamatrix)
# names(datamatrix)=c("chr","start","end",sample)
# datamatrix_ori=datamatrix
# datamatrix_ori2=datamatrix
# write.table(datamatrix_ori,"compartment_score.txt",sep="\t",quote=F,row.names=F)

setwd("E:/PC_0628/TALL/figures_final_0718/manu+figure/figure1/compartment")
datamatrix_ori=read.table("compartment_score.txt",header = TRUE,stringsAsFactors = FALSE)
datamatrix_ori2=read.table("compartment_score.txt",header =FALSE,stringsAsFactors = FALSE)
names(datamatrix_ori)=datamatrix_ori2[1,]

datamatrix=datamatrix_ori[,4:ncol(datamatrix_ori)]
dim(datamatrix)
# general view
# varipc1=function(x){
# n=length(which(x<0))
# if(n>4 && n<(length(sample)-4+1)){
# return(1)}else{return(0)}
# }
# datamatrix2=datamatrix[which(apply(datamatrix,1,varipc1)==1),]

# general view
varipc1=function(x){
if(length(which(x<0))>14|length(which(x>0))>14){
   return(0)
}else{return(1)}
}
datamatrix2=datamatrix[which(apply(datamatrix,1,varipc1)==1),]
dim(datamatrix2)


#datamatrix2=datamatrix
datamatrix2=na.omit(datamatrix2)
dim(datamatrix)
dim(datamatrix2)



###
# df=abs(datamatrix2)
# library(matrixStats)
# datamatrix2=datamatrix2/matrix(rep(colMedians(as.matrix(df)),nrow(df)),nrow(df),byrow=TRUE)


gene=datamatrix2
info=read.table("E:/PC_0628/TALL/TALL_new/sample_info/sampleinfo2.txt",header=TRUE)
#info=read.table("/data02/fchen/TALL/all_results/compartment/sampleinfo2.txt",header=TRUE)

head(info)
names(gene)[which(is.na(match(names(gene),info$sample)))]
annotation=info$condition[match(names(gene),info$sample)]
annotation=data.frame(class=factor(annotation,levels=c("ETP","non-ETP","normal")),type=info$type[match(names(gene),info$sample)])
row.names(annotation)=names(gene)

sub=read.table("E:/PC_0628/TALL/figures_final_0718/manu+figure/sampleinfo2.txt",sep="\t",header = TRUE,stringsAsFactors = TRUE)
#sub=read.table("/data02/fchen/TALL/all_results/compartment/sampleinfo2.txt",header=TRUE)
names(datamatrix2)=sub$sample2[match(names(datamatrix2),sub$sample)]
row.names(annotation)=sub$sample2[match(row.names(annotation),sub$sample)]

# pos=which(annotation$type!="cell_line")
# annotation=annotation[pos,]
# datamatrix2=gene[,pos]
# gene=gene[,pos]

library("pheatmap")
## PCA
datamatrix2 <- t(datamatrix2)
PCA_result <- prcomp(datamatrix2,scale = T)
PCA_layout <- as.data.frame(PCA_result$x)
PCA_layout$type=annotation[match(row.names(PCA_layout),row.names(annotation)),1]
PCA_layout$sample=row.names(PCA_layout)
#PCA_layout=PCA_layout[PCA_layout$type!="normal",]
library(ggplot2)
library("ggrepel")
pdf("PCA_compartment2.pdf",width=5,height=4)
qplot(x=PC1, y=PC2, data = PCA_layout, color=type,
      xlab = "PC1 (20.31% variance)", ylab = "PC2 (16.41% variance)")+scale_colour_manual(values =c("#F8766D","#7CAE00","#E29D13"))+theme(plot.title=element_text(hjust=0.5,size = 25),
                                                                                                                                          axis.title = element_text(size=20),
                                                                                                                                          axis.text = element_text(size = 20),legend.text = element_text(size = 15),
                                                                                                                                          legend.title= element_text(size = 15))+geom_point(size=3.5)+
   theme_set(theme_bw())+
   theme(panel.grid.major=element_line(colour=NA))+geom_point(size=3)+geom_text(aes(label=sample),vjust = -1,size = 3.5) #,
dev.off()










ann_colors=c("#F8766D","#7CAE00","#00BFC4",	"#C0C0C0")
names(ann_colors)=c("ETP","non-ETP","normal","unknown")
ann_colors = list(class=ann_colors)
bk <- c(seq(-2.5,-0.001,by=0.001),seq(0,2.5,by=0.001))
pdf("compartment_heatmap.pdf",height=6,width=6)
pheatmap(gene,scale="row",show_rownames=F,clustering_distance_cols='correlation',annotation = annotation,annotation_colors =ann_colors,#cluster_rows=F,
         color = c(colorRampPalette(colors = c("blue","white"))(length(bk)/2),colorRampPalette(colors = c("white","red"))(length(bk)/2)),
         legend_breaks=seq(-2.5,2.5,0.5),
         breaks=bk)
dev.off()

# pdf(paste(args[2],"heatmap.pdf",sep="_"),height=7,width=5)
# pheatmap(datamatrix2,show_rownames=FALSE)
# dev.off()
library("pheatmap")
library("ellipse")
cor_matrix <- cor(datamatrix2, use = "everything",method="spearman")
#cor_matrix <- cor(datamatrix2, use = "everything",method="spearman")

ann_colors=c("#F8766D","#7CAE00","#00BFC4")
names(ann_colors)=c("ETP","non-ETP","normal")
ann_colors = list(class=ann_colors)
pdf("compartment_correlation_spearman2.pdf",height=5.5,width=6.7)
pheatmap(cor_matrix,annotation = annotation,annotation_colors =ann_colors ) #, display_numbers = T
dev.off()



