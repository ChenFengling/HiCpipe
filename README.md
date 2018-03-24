# HiCpipe
## related links

ChIA-PET2 https://github.com/GuipengLi/ChIA-PET2  
[Hi-Cpro]
[Hi-Cpro sample](https://zerkalo.curie.fr/partage/HiC-Pro/HiCPro_results/HiC_Pro_v2.7.4_test_data/)  
[Hi-Cpro](https://github.com/nservant/HiC-Pro)
Juicer tools pre https://github.com/theaidenlab/juicer/wiki/Pre#4dn-dcic-format  
juicerbox https://github.com/theaidenlab/Juicebox  
[video for Juicebox usage](https://www.youtube.com/watch?feature=player_embedded&v=xjNXyeUSfZM)  
cut -f 7,9,1,2,10,4,5 /home/zliang/3.DataProcess/YY1.Analysis/5-NC-Rep1.rmdup.bedpe >test.pair  
sed /-1/d test.pair >test2.pair  
[bam2pairs](https://github.com/4dn-dcic/pairix/tree/master/util/bam2pairs)  
cnv and transloctaion tools: [HiCtrans](https://github.com/ay-lab/HiCtrans) [HiCnv](https://github.com/ay-lab/HiCnv)  [HiCapp](https://bitbucket.org/mthjwu/hicapp)

related papers
[li cheng lab(CNV)](http://cls.pku.edu.cn:8080/index.php?m=content&c=index&a=show&catid=34&id=95)

## input data  
在/home/data/下面创建一个项目目录，如下BLHiC-HepG2，数据组织形式project/sample/*.fq.gz  
BLHiC-HepG2  
├── 5-NC-Rep1  
│   ├── 5-NC-Rep1_R1.fq.gz  
│   └── 5-NC-Rep1_R2.fq.gz  
└── 7-iRBM25-Rep1     
    ├── 7-iRBM25-Rep1_R1.fq.gz  
    └── 7-iRBM25-Rep1_R2.fq.gz  
