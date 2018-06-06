JUICER=/home/software/juicer/CPU
cd $1/$2
for j in {1..22}
do
java -jar ${JUICER}/juicer_tools.jar  dump observed KR hicfile/$2.hic  ${j} ${j}   BP $3  /home/fchen/HiCpipe/pipe/maps/$2_KR_$3.chr${j}
done
java -jar ${JUICER}/juicer_tools.jar  dump observed KR hicfile/$2.hic X  X  BP $3  /home/fchen/HiCpipe/pipe/maps/$2_KR_$3.chr23
