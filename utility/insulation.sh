cd TAD
for j in {1..23}
do
file=\'$2_KR_50000.chr${j}\'
matlab -nodisplay -nojvm -nosplash -r "RESOL=50000;file=${file};CHROM=${j};" </home/fchen/HiCpipe/pipe/sparse2dense.m
sed -i 's/^[[:space:]]*//' KRchr${j}
sed -i 's/ /\t/g' KRchr${j}
nrow=$(head -n 1 KRchr${j} |awk '{print NF}')
Rscript ${Scriptpath}/insu_header1.r  ${j} ${nrow}  $Resolution
cat header KRchr${j} >KRchr${j}.tmp
paste header2 KRchr${j}.tmp > KRchr${j}.tmp2
time perl $Insulation -i KRchr${j}.tmp2  -is 1000000 -ids 200000 -im mean  -nt 0.1 -v
done
cd ..

