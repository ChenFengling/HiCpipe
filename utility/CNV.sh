Scriptpath=/home/fchen/HiCpipe/pipe/HiCnv
cd ${Scriptpath}/Read_coverage_generation
#perl run_1DReadCoverage.pl $2    $1/$2/bowtie_results/bwt2/$2/$2_1.valid_hg19.bwt2merged.bam $1/$2/bowtie_results/bwt2/$2/$2_2.valid_hg19.bwt2merged.bam 
#sh  1DReadCoverage.$2.sh
cp  $2.F_GC_MAP.bed $2.perREfragStats ../CNV_calling
cd ../CNV_calling
perl run_HiCnv.pl $2
sh HiCnv_$2.sh 

