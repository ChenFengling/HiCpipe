<h1><img src="https://github.com/ChenFengling/HiCpipe/blob/master/HiCpipe.png" alt="HiCpipe Logo" style="float:left; margin-right:20px;" width="40" height="40"/>HiCpipe – user guide</h1>

#### general description of the pipeline
This pipeline is for BL-Hi-C.It is based on Juicer and HiC-pro which combines the advatages of these two processing pipelines. HiCpipe is much faster than Juicer and HiC-pro and can output multile features of Hi-C maps. The main.sh will trim the Linker of BL-Hi-C and map the data to certein genome. Then it will use the subjob.sh script to do the other steps in parallel in shell background. You could use top or htop to check your running program. 

The outputs is listed as following:  


| name | software | output content   |
| ------------ |--------------- | -----|
| mapping | bwa   | merged mapped reads(.bam) |
| filter | HiC-pro | contact pairs (.txt) |
| pair2hic | juicer (pre) | compressed Hi-C maps(.hic) |
| hic2map | juicer(dump) | sparse and dense matrix (.mat) |
| compartmet | R eigen | PC1 values(.txt, .bw) |
| TAD | Insulation score | TAD boundaries(.bed); insulation score(.bw) |
| CDB | HiCDB | CDBs(.bed); relative insulation score(.bw) |
| loop | HiCloop | loops(.bedpe) |
| qc | shell | Hi-C quality report |

&emsp;&emsp;Here is the general features of HiCpipe software.(in developing)  
<div align=center><img width="500" height="300" src="https://github.com/ChenFengling/HiCpipe/blob/master/HiCpipe.png"/></div>

Other utility:  
Easy clustering based on compartment and insulation.  
Statistics of Hi-C features.

## pipeline install 
All software metioned before should be installed first.
To install this pipeline, simply download this pipeline and use the shell script.
```shell
git clone https://github.com/ChenFengling/HiCpipe.git
```



## input data  
Organize your data as PROJECT_PATH/sample/sample.fq.gz, for example    

BLHiC-project1  
├── sample1         
│ &ensp;&ensp;  ├── sample1_R1.fq.gz  
│ &ensp;&ensp;  └── sample1_R2.fq.gz  
└── sample2  
&ensp;&ensp;&ensp;&ensp;├── sample2_R1.fq.gz                         
&ensp;&ensp;&ensp;&ensp;└── sample2_R2.fq.gz     

## output data
You will get the summarized data in PROJECT_PATH/all_results/

## quick start 
use the following code to analyse your BL-HiC data
```shell
sh main.sh $PROJECT_PATH $Resolution $genome $core $HiCpipe_PATH
```
**Configurations should be changed in config-hicpro_*.txt: BOWTIE2_IDX_PATH GENOME_SIZE  GENOME_FRAGMENT.**


#### how to use other genomes rather than mm9/mm10/hg19
1.change tss annotation in compartment.r
```R
tss=read.table("YOUR_TSS_FOLDER/tss.bed")
```
2.change BOWTIE2_IDX_PATH GENOME_SIZE  GENOME_FRAGMENT in config-hicpro.txt
follow the instrcution in https://github.com/nservant/HiC-Pro/tree/master/annotation to generate the sites of restriction enzyme.
```shell
/home/software/HiC-Pro/bin/utils/digest_genome.py -r GG^CC -o mm9_ggcc.bed /home/reference/mouse/mm9/Sequence/BWAIndex/genome.fa
```

## generate QC report
Use HiCqc.sh to generate Hi-C qc report
```shell 
sh HiCqc.sh $PROJECT_PATH $REPORT_NAME $HiCpipe_PATH
``` 
You will find the qc report **REPORT_NAME_report.txt** under PROJECT_PATH.

### QC output
#### QC suggestion
**Valid_interaction_pairs/Total_PETsTotal_PETs (>50%)**  
**valid_interaction_rmdup/Valid_interaction_pairs (>85%)**  
**cis_interaction/trans_interaction (>1.5)**  

## citation
[HiCDB paper](https://academic.oup.com/nar/article/46/21/11239/5090284)  
Chen, F., Li, G., Zhang, M. Q., & Chen, Y. (2018). HiCDB: a sensitive and robust method for detecting contact domain boundaries. Nucleic acids research, 46(21), 11239-11250.  
[T-ALL paper using HiCpipe](https://www.biorxiv.org/content/10.1101/2020.03.11.988279v1)  
Yang, L., Chen, F., Zhu, H., Chen, Y., Dong, B., Shi, M., ... & Zhang, M. Q. (2020). 3D Genome Analysis Identifies Enhancer Hijacking Mechanism for High-Risk Factors in Human T-Lineage Acute Lymphoblastic Leukemia. bioRxiv.  

## related links
ChIA-PET2 https://github.com/GuipengLi/ChIA-PET2  
[Hi-Cpro sample](https://zerkalo.curie.fr/partage/HiC-Pro/HiCPro_results/HiC_Pro_v2.7.4_test_data/)  
[Hi-Cpro](https://github.com/nservant/HiC-Pro)  
Juicer tools pre https://github.com/theaidenlab/juicer/wiki/Pre#4dn-dcic-format  
juicerbox https://github.com/theaidenlab/Juicebox  
[video for Juicebox usage](https://www.youtube.com/watch?feature=player_embedded&v=xjNXyeUSfZM)  
cnv and transloctaion tools: [HiCtrans](https://github.com/ay-lab/HiCtrans) [HiCnv](https://github.com/ay-lab/HiCnv)  [HiCapp](https://bitbucket.org/mthjwu/hicapp)  
