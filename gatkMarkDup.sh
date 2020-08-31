#!/bin/bash

INPUTDIR='sortedBam'
OUTPUTDIR='mkDupGatk'
SAMPLE='SRR6677754'
REFGENOME='/mnt/md0/humanGenome/TCGA/GRCh38.d1.vd1.fa'

samtools rmdup $INPUTDIR/${SAMPLE}.bam $INPUTDIR/${SAMPLE}_RD.bam ;

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
 MarkDuplicatesSpark --input $INPUTDIR/${SAMPLE}_RD.bam --output $OUTPUTDIR/${SAMPLE}_001.bam --tmp-dir ./ ;

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
 BaseRecalibrator -I $OUTPUTDIR/${SAMPLE}_001.bam -R $REFGENOME \
  --known-sites ./snps/common_all_20180418.vcf.gz -O ${SAMPLE}_recal_data.table ;

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
 ApplyBQSR -R $REFGENOME -I $OUTPUTDIR/${SAMPLE}_001.bam --bqsr-recal-file ${SAMPLE}_recal_data.table -O $OUTPUTDIR/${SAMPLE}_md.bam ;

rm $OUTPUTDIR/${SAMPLE}_RD.bam $OUTPUTDIR/${SAMPLE}_001.bam