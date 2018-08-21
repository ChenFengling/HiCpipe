##Rscipt insu_header chr number sample resol
args <-commandArgs(T)
chr=as.numeric(args[1])
nrow=as.numeric(args[2])-1
resol=as.numeric(args[3])
bin=seq(0,nrow)
start=bin*resol+1
end=start+resol
bins=paste("bin",bin,"|hg19|chr",chr,":",start,"-",end,sep="")
bins2=c(bins[1],bins)
bins=t(as.data.frame(bins))
write.table(bins,'header',sep="\t",quote=F,col.names=FALSE,row.names=FALSE)
write.table(bins2,'header2',sep="\t",quote=F,col.names=FALSE,row.names=FALSE)
