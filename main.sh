## usage 
## sh main.sh $RawData_Dir $Resolution $genome $core $Scriptpath
RawData_Dir=$1
Resolution=$2
genome=$3
core=$4
################software path ##############################
Scriptpath=$5  

#######################################################
hg19=hg19
mm10=mm10
mm9=mm9

if [ "$genome" == "$hg19" ]
then
	echo "genome assembly hg19"
	BWA_File="/home/reference/fchen/bwa/hg19.fa"
	Chromosome_File="/home/reference/fchen/hg19.chrom.sizes.txt"

elif [ "$genome" == "$mm10" ]
then
	echo "genome assembly mm10"
	BWA_File="/home/reference/mouse/mm10/Sequence/BWAIndex/genome.fa"
	Chromosome_File="/home/reference/mouse/mm10/Sequence/WholeGenomeFasta/mm10.chrom.sizes"

elif [ "$genome" == "$mm9" ]
then
        echo "genome assembly mm9"
        BWA_File="/home/reference/mouse/mm9/Sequence/BWAIndex/genome.fa"
        Chromosome_File="/home/reference/mouse/mm9/Sequence/WholeGenomeFasta/mm9.chrom.sizes"

else
        echo "genome assembly $genome "
        BWA_File="/home/reference/elegans/bwa/elegans"
        Chromosome_File="/home/reference/elegans/elegans.chrom.size" 
fi 

############main script ###############################
cd ${RawData_Dir}
for var in */*_R1.fq.gz  
do 
i=${var%%/*}
cd ${RawData_Dir}/${i}
mkdir rawdata
mkdir rawdata/${i}
mkdir tmp 
mkdir logs 
mkdir bowtie_results
mkdir bowtie_results/bwt2
mkdir bowtie_results/bwt2/${i}
##### step.1 trim linker   #####
Input1=${i}_R1.fq.gz
Input2=${i}_R2.fq.gz
time trimLinker -A ACGCGATATCTTATC -B AGTCAGATAAGATAT -k 2 -m 1 -t $core  -e 1 -n ${i} -o rawdata/${i} ${Input1}  ${Input2}
##### step.2 map Hi-C data #####
time bwa mem -t $core ${BWA_File}  rawdata/${i}/${i}_1.valid.fastq |samtools view  -b -@ $core -h -F 2048 > bowtie_results/bwt2/${i}/${i}_1.valid_${genome}.bwt2merged.bam
time bwa mem -t $core ${BWA_File}  rawdata/${i}/${i}_2.valid.fastq |samtools view  -b -@ $core -h -F 2048 > bowtie_results/bwt2/${i}/${i}_2.valid_${genome}.bwt2merged.bam
done 
cd  ${RawData_Dir}
for var in */*_R1.fq.gz
####  step.3 generate features for each sample 
do 
i=${var%%/*}
nohup sh $Scriptpath/subjob.sh ${RawData_Dir} ${i} ${Resolution} ${genome} $Scriptpath  &> ${i}/${i}_sub.log &
done

mkdir ${RawData_Dir}/all_results
