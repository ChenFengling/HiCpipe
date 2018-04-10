# HiCpipe
## cluster
cluster: 166.111.130.43  user:fchen  pw:boyuchenxi  

## input data  
在/home/fchen/data/下面创建一个项目目录，如下BLHiC-HepG2，数据组织形式project/sample/*.fq.gz  
BLHiC-HepG2   
├── 5-NC-Rep1  
│ &ensp;&ensp;  ├── 5-NC-Rep1_R1.fq.gz  
│ &ensp;&ensp;  └── 5-NC-Rep1_R2.fq.gz  
└── 7-iRBM25-Rep1  
&ensp;&ensp;&ensp;&ensp;├── 7-iRBM25-Rep1_R1.fq.gz                         
&ensp;&ensp;&ensp;&ensp;└── 7-iRBM25-Rep1_R2.fq.gz     

## related links

ChIA-PET2 https://github.com/GuipengLi/ChIA-PET2  
[Hi-Cpro sample](https://zerkalo.curie.fr/partage/HiC-Pro/HiCPro_results/HiC_Pro_v2.7.4_test_data/)  
[Hi-Cpro](https://github.com/nservant/HiC-Pro)  
Juicer tools pre https://github.com/theaidenlab/juicer/wiki/Pre#4dn-dcic-format  
juicerbox https://github.com/theaidenlab/Juicebox    
[video for Juicebox usage](https://www.youtube.com/watch?feature=player_embedded&v=xjNXyeUSfZM)  
cnv and transloctaion tools: [HiCtrans](https://github.com/ay-lab/HiCtrans) [HiCnv](https://github.com/ay-lab/HiCnv)  [HiCapp](https://bitbucket.org/mthjwu/hicapp)

related papers
[li cheng lab(CNV)](http://cls.pku.edu.cn:8080/index.php?m=content&c=index&a=show&catid=34&id=95)



### QC output
#### trimming step  
**trim the BL-linker and discard the reads with  less than 15 bases.**     
Total_PETs  
Expect_PETs  
Expect_both_PETs  
Chim_PETs  
1Empty_PETs  
2Empty_PETs  
Valid_PETs  
#### mapping step  
Total_pairs_processed  
Unmapped_pairs  
Low_qual_pairs  
Unique_paired_alignments  
Multiple_pairs_alignments  
Pairs_with_singleton  
Low_qual_singleton  
Unique_singleton_alignments  
Multiple_singleton_alignments  
Reported_pairs  
#### filter invalid pairs  
**filter the data according to restriction sites**  
Valid_interaction_pairs  
Valid_interaction_pairs_FF  
Valid_interaction_pairs_RR  
Valid_interaction_pairs_RF  
Valid_interaction_pairs_FR  
Dangling_end_pairs  
Religation_pairs  
Self_Cycle_pairs  
Single-end_pairs  
Dumped_pairs  
#### filter duplictes   
valid_interaction  
valid_interaction_rmdup  
trans_interaction  
cis_interaction  
cis_shortRange  
cis_longRange  
#### general report  
valid/total  
rmdump/valid  
intra/inter  


