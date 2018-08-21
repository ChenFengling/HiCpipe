args=commandArgs(T)
options(scipen = 20)
library("hicrep")

corhic=function(dir1,dir2,downsam){
sample1=list.files(path=dir1[2],dir1[1])
sample2=list.files(path=dir2[2],dir2[1])
n=length(sample1)

sumcor=0
for(m in 1:n){
HiCR1=read.table(paste(dir1[2],sample1[m],sep=""),stringsAsFactors=FALSE)
DS_HiCR1 <- depth.adj(HiCR1, downsam[m]) 
smd_mat1 = fast.mean.filter(DS_HiCR1, 4)
#DS_HiCR1=cbind("chr3",(0:(nrow(DS_HiCR1)-1))*50000,(1:(nrow(DS_HiCR1)))*50000,DS_HiCR1,stringsAsFactors=FALSE,deparse.level = 0)
#names(DS_HiCR1)=paste("V",1:(nrow(DS_HiCR1)+3),sep="")
HiCR2=read.table(paste(dir2[2],sample2[m],sep=""),stringsAsFactors=FALSE)
DS_HiCR2 <- depth.adj(HiCR2, downsam[m]) 
smd_mat2 = fast.mean.filter(DS_HiCR2, 4)
#DS_HiCR2=cbind("chr3",(0:(nrow(DS_HiCR2)-1))*50000,(1:(nrow(DS_HiCR2)))*50000,DS_HiCR2,stringsAsFactors=FALSE,deparse.level = 0)
#names(DS_HiCR2)=paste("V",1:(nrow(DS_HiCR2)+3),sep="")
SCC.out = get.scc(smd_mat1, smd_mat2, 50000, 4, 0, 5000000)
sumcor=sumcor+SCC.out[[3]]
}
return(sumcor/n)
}

downsam=read.table(paste(args[2],".count",sep=""),stringsAsFactors=FALSE)
downsam=apply(downsam,1,min)

sample=list.files(path=args[1])
dir = paste(args[1],"/", sample, "/maps/",sep = "")
dir=cbind(sample,dir)
n <- length(sample)
cor_matrix=matrix(1,n,n)
for(i in 1:(n-1)){
	for(j in (i+1):n){
	tmp=corhic(dir[i,],dir[j,],downsam)
	cor_matrix[i,j]=tmp
	cor_matrix[j,i]=tmp
	} 
}
colnames(cor_matrix)=sample
row.names(cor_matrix)=sample
write.table(cor_matrix,paste(args[2],"_cor.matrix",sep=""),quote=F,sep="\t")
library("pheatmap")
library("ellipse")
pdf(paste(args[2],"_correlation.pdf",sep=""))
pheatmap(cor_matrix, display_numbers = T)
dev.off()
