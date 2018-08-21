Resolution=$3
genome=$4
Scriptpath=$5
Insulation=/home/software/crane-nature-2015/scripts/matrix2insulation.pl
JUICER=/home/software/juicer/CPU


hg19=hg19
mm10=mm10
mm9=mm9

if [ "$genome" == "$hg19" ]
then
        Chromosome_File="/home/reference/fchen/hg19.chrom.sizes.txt"

elif [ "$genome" == "$mm10" ]
then
        Chromosome_File="/home/reference/mouse/mm10/Sequence/WholeGenomeFasta/mm10.chrom.sizes"

elif [ "$genome" == "$mm9" ]
then
        Chromosome_File="/home/reference/mouse/mm9/Sequence/WholeGenomeFasta/mm9.chrom.sizes"I

else
        Chromosome_File="/home/reference/elegans/elegans.chrom.size"
fi


nchrom=$(cat $Chromosome_File|sed  '/_/d'|sed '/chrM/d'|sed '/chrY/d'|sort -k1,1 -V -s|cut -f2|wc -l )

cd $1/$2
echo  $1/$2
mkdir hicfile
mkdir TAD
mkdir CDB
mkdir compartment
mkdir maps
mkdir Loops
time HiC-Pro -i bowtie_results/bwt2/ -o $1/$2 -c $Scriptpath/config-hicpro_${genome}.txt -s proc_hic -s  merge_persample 
time awk '{chr1=substr($2,4);chr2=substr($5,4);if(chr1>chr2){print $1,$7,chr2,$6,1,$4,chr1,$3,0,$12,$11}else{print $1,$4,chr1,$3,0,$7,chr2,$6,1,$11,$12}}' hic_results/data/$2/$2_allValidPairs >hic_results/data/$2/$2_tmp
sort -k3,3d -k7,7d --parallel=8 hic_results/data/$2/$2_tmp > hicfile/$2.txt 
sed -i 's/+/0/g'  hicfile/$2.txt
sed -i 's/-/16/g'  hicfile/$2.txt
time java -jar ${JUICER}/juicer_tools.jar pre -r 500000,250000,100000,50000,40000,25000,20000,10000,5000,1000 hicfile/$2.txt  hicfile/$2.hic $Chromosome_File

#### step.3 extract data  #####
for j in $(eval echo "{1..$[nchrom-1]}")
do
java -jar ${JUICER}/juicer_tools.jar  dump observed NONE hicfile/$2.hic  ${j} ${j}  BP $Resolution  maps/chr${j}.matrix
done
java -jar ${JUICER}/juicer_tools.jar  dump observed NONE hicfile/$2.hic X  X  BP $Resolution  maps/chr${nchrom}.matrix

##### step.4 compartment  #####
for j in $(eval echo "{1..$[nchrom-1]}")
do
java -jar ${JUICER}/juicer_tools.jar  pearsons -p KR  hicfile/$2.hic $j BP 100000  compartment/KRchr$j
done
java -jar ${JUICER}/juicer_tools.jar  pearsons -p KR  hicfile/$2.hic X BP 100000  compartment/KRchr${nchrom}
cd compartment
#Rscript  ${Scriptpath}/calcuchrX_comp.r $2
Rscript ${Scriptpath}/compartment.r $2_ ${genome}
cp $2_pc1.bdg $2_pc1_ori.bdg
sed -i '/NA/d' $2_pc1.bdg
sort -k1,1 -k2,2n $2_pc1.bdg >$2_pc1.bdg.sort
bedGraphToBigWig $2_pc1.bdg.sort   ${Chromosome_File}  $2_pc1.bw
rm $2_pc1.bdg.sort $2_pc1.bdg
cd ../

##### step.5 insulation #####
cd $1/$2
for j in $(eval echo "{1..$nchrom}")
do
java -jar ${JUICER}/juicer_tools.jar  dump -d observed KR hicfile/$2.hic  ${j} ${j}   BP 40000  TAD/KRchr${j}
done
java -jar ${JUICER}/juicer_tools.jar  dump -d observed KR hicfile/$2.hic X  X BP 40000  TAD/KRchr${nchrom}

cd TAD
for j in $(eval echo "{1..$nchrom}")
do
nrow=$(head -n 1 KRchr${j} |awk '{print NF}')
Rscript ${Scriptpath}/insu_header1.r  ${j} ${nrow} 40000 
cat header KRchr${j} >KRchr${j}.tmp
paste header2 KRchr${j}.tmp > KRchr${j}.tmp2
time perl $Insulation -i KRchr${j}.tmp2  -is 1000000 -ids 200000 -im mean  -nt 0.1 -v
rm KRchr${j} KRchr${j}.tmp
done

for i in $(eval echo "{1..$nchrom}")
do 
awk '{printf("%s\t%d\t%d\t%0.8f\n",$1,$2,$3,$5)}'  KRchr${i}.is1000001.ids240001.insulation.boundaries.bed >>$2_TAD.bed
done
sed -i "s/${nchrom}/chrX/g" $2_TAD.bed
sort -k1,1 -k2,2n -u $2_TAD.bed>$2_TAD.sort.bed
cd ..
cp TAD/$2_TAD.sort.bed   $1/all_results/

##### step.6 HiCDB #####
HiCdir={\'$1/$2/maps/\'}
matlab -r "addpath(genpath('/home/fchen/HiCDB/'));HiCDB($HiCdir,$Resolution,$genome,'ref',$genome);exit;"
awk -v OFS="\t" '{ print "chr"$1,$2,$3,$4,$5}' maps/CDB.txt >maps/$2_CDB.bed
sed -i  "s/${nchrom}/chrX/g" maps/$2_CDB.bed
cp maps/$2_CDB.bed $1/all_results/

##### step.7 HiCloop #####
mkdir Loops
for j in $(eval echo "{1..$nchrom}")
do
file=[\'maps/chr${j}.matrix\']
echo ${file}
matlab -nodisplay -nojvm -nosplash -r "CHROM=${j};file=${file};RESOL=${Resolution};" </home/software/HiCloop/main.m 
done
cat Loops/*.bedpe >$2_ori_loop.bedpe
cat Loops/dataY-10kb-chr* >dataY-10kb-all.txt

python /home/software/HiCloop/hicloop_cnn.py
sort -k8,8g cnn_predict_prob.txt |awk -v OFS="\t" '{if($9>0.5) print "chr"$1,$2,$3,"chr"$4,$5,$6,$7,$9}' > $2_cnn_loop.bedpe
sed -i "s/${nchrom}/chrX/g" $2_cnn_loop.bedpe 
rm cnn_predict_prob.txt
cp $2_cnn_loop.bedpe $1/all_results/
