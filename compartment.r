dir=getwd()
sedwd=(dir)
options(scipen = 20)
Args <- commandArgs(T)

if(Args[2]=="hg19"){
tss=read.table("/home/reference/fchen/tss.bed")
tss=data.frame(chr=tss[,1],bin=floor((tss[,2]+tss[,3])/2/100000))
table=read.table("/home/reference/fchen/hg19.chrom.sizes.24.txt")
chr=paste("chr",c(as.character(1:22),"X","Y"),sep="")
compart=data.frame(chr=character(),start=numeric(),end=numeric(),pc=numeric(),stringsAsFactors=FALSE)
for(i in 1:23){
        length=table[table[,1]==chr[i],2]
        start=seq(0,length,100000)
        n=length(start)
        col=data.frame(chr[i],start,c(start[2:n],length))
    chrpc=read.table(paste(Args[1],chr[i],"_pc1_100k.txt",sep=""))
    chrtss=unique(tss[tss[,1]==chr[i],2])
    flag=length(which(chrpc[chrtss,1]>0))/length(which(chrpc[chrtss,1]<0))
    print(flag)
    if(flag<1){
    chrpc=-chrpc 
    }
    col=cbind(col,chrpc)
    names(col)=c("chr","start","end","pc")
    compart=rbind(compart,col)
        }
}else{
if(Args[2]=="mm10"){
tss=read.table("/home/reference/fchen/mouse/tss.bed")
table=read.table("/home/reference/mouse/mm10/Sequence/WholeGenomeFasta/mm10.chrom.sizes")
}else{
tss=read.table("/home/reference/mouse/mm9/tss.bed")
table=read.table("/home/reference/mouse/mm9/Sequence/WholeGenomeFasta/mm9.chrom.sizes")
}
tss=data.frame(chr=tss[,1],bin=floor((tss[,2]+tss[,3])/2/100000))
chr=paste("chr",c(as.character(1:19),"X","Y"),sep="")
compart=data.frame(chr=character(),start=numeric(),end=numeric(),pc=numeric(),stringsAsFactors=FALSE)
for(i in 1:20){
        length=table[table[,1]==chr[i],2]
        start=seq(0,length,100000)
        n=length(start)
        col=data.frame(chr[i],start,c(start[2:n],length))
    chrpc=read.table(paste(Args[1],chr[i],"_pc1_100k.txt",sep=""))
    chrtss=unique(tss[tss[,1]==chr[i],2])
    flag=length(which(chrpc[chrtss,1]>0))/length(which(chrpc[chrtss,1]<0))
    print(flag)
    if(flag<1){
    chrpc=-chrpc
    }
    col=cbind(col,chrpc)
    names(col)=c("chr","start","end","pc")
    compart=rbind(compart,col)
        }


}

write.table(compart,paste(Args[1],"pc1.bdg",sep=""),quote=F,col.names=FALSE,row.names=FALSE,sep="\t")
