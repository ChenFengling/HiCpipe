JUICER=/data01/software/juicer/CPU
Resolution=$7
mkdir -p ${11}_${10}/transtmp
cd ${11}_${10}
:<<BLOCK
java -jar ${JUICER}/juicer_tools.jar  dump observed NONE /data02/fchen/TALL/${10}/hicfile/${10}.hic  $1 $4  BP $Resolution  transtmp/${10}.chr$1_$4
java -jar ${JUICER}/juicer_tools.jar  dump observed NONE /data02/fchen/TALL/${10}/hicfile/${10}.hic  $1 $1  BP $Resolution  transtmp/${10}.chr$1
java -jar ${JUICER}/juicer_tools.jar  dump observed NONE /data02/fchen/TALL/${10}/hicfile/${10}.hic  $4 $4  BP $Resolution  transtmp/${10}.chr$4

for i in 097-N 076-N 077-N 108-N 098-N 115-N 107-N 124-N 103-N 102-N 122-N 123-N 118-N 116-N 121-N MXYL-N
do 
java -jar ${JUICER}/juicer_tools.jar  dump observed KR /data02/fchen/TALL/$i/hicfile/$i.hic  $1 $4  BP $Resolution  transtmp/$i.chr$1_$4
java -jar ${JUICER}/juicer_tools.jar  dump observed KR /data02/fchen/TALL/$i/hicfile/$i.hic  $1 $1  BP $Resolution  transtmp/$i.chr$1
java -jar ${JUICER}/juicer_tools.jar  dump observed KR /data02/fchen/TALL/$i/hicfile/$i.hic  $4 $4  BP $Resolution  transtmp/$i.chr$4
done
BLOCK
sample=\'${10}\'
matlab -r "addpath(genpath('/data01/fchen/HiCpipe/pipe/0.trans/vistrans'));figure3_TLX($sample,$1,$2,$3,$4,$5,$6,$7,$8,$9);quit;"
