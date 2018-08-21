# sh  HiCqc2.sh path name
cd $1
for j in */compartment
do 
i=${j%%/*}
cd $1/$i
echo ${i} >$i.stat    
echo  >>$i.stat
cat  rawdata/${i}/${i}.trim.stat >>$i.stat
echo  >>$i.stat
cat  bowtie_results/bwt2/${i}/${i}_*.bwt2pairs.pairstat >>$i.stat
echo >>$i.stat
cat hic_results/data/${i}/${i}_*.bwt2pairs.RSstat >>$i.stat
echo >>$i.stat
cat hic_results/data/${i}/${i}_allValidPairs.mergestat>>$i.stat
sed -i '/Hi-C/d' $i.stat
cut -f2  ${i}.stat >>../${i}.stat
done
cd $1
paste /home/fchen/HiCpipe/pipe/qcheader.txt *.stat >$2_report.txt
rm *.stat
