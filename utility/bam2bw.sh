bamCoverage --bam $1/thout/acndsort.bam -o $2.bdg  --binSize 10 --outFileFormat bedgraph
sort -k1,1 -k2,2n $2.bdg >$2.bdg.sort
bedGraphToBigWig $2.bdg.sort /mnt/reference/fchen/hg19.chrom.sizes.txt  $2.bw

