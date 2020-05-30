
JUICER=/data01/software/juicer/CPU
cd $1/$2
for j in {1..22}
do
java -jar ${JUICER}/juicer_tools.jar  dump observed KR hicfile/$2.hic  ${j} ${j}  BP 10000  maps/observed_KR_10000.chr${j}_$2
done
java -jar ${JUICER}/juicer_tools.jar  dump observed KR  hicfile/$2.hic X X  BP 10000  maps/observed_KR_10000.chr23_$2
