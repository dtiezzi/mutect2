#!/bin/bash

INPUTDIR='outputBam'
MIDDIR='sortedBam'
OUTPUTDIR='mkDupGatk'
SAMPLE='SRR6677754_sorted'
REFGENOME='/mnt/md0/humanGenome/TCGA/GRCh38.d1.vd1.fa'


samtools sort -n -o -@ 8 $MIDDIR/${SAMPLE}.bam $INPUTDIR/${SAMPLE}.bam ;
samtools fixmate -m -@ 8 $MIDDIR/${SAMPLE}.bam $MIDDIR/${SAMPLE}_fixmate.bam
samtools sort -o -@ 8 $MIDDIR/${SAMPLE}_sorted.bam $MIDDIR/${SAMPLE}_fixmate.bam

#samtools rmdup $MIDDIR/${SAMPLE}_sorted.bam $INPUTDIR/${SAMPLE}_RD.bam ;
samtools markdup -r -@ 8 $MIDDIR/${SAMPLE}_sorted.bam $INPUTDIR/${SAMPLE}_RD.bam ;

rm $MIDDIR/* ;

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
 MarkDuplicatesSpark --input $INPUTDIR/${SAMPLE}_RD.bam --output $OUTPUTDIR/${SAMPLE}_001.bam --tmp-dir ./ ;

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
 BaseRecalibrator -I $OUTPUTDIR/${SAMPLE}_001.bam -R $REFGENOME \
  --known-sites ./snps/common_all_20180418.vcf.gz -O ${SAMPLE}_recal_data.table ;

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
 ApplyBQSR -R $REFGENOME -I $OUTPUTDIR/${SAMPLE}_001.bam --bqsr-recal-file ${SAMPLE}_recal_data.table -O $OUTPUTDIR/${SAMPLE}_md.bam ;

rm $OUTPUTDIR/${SAMPLE}_RD.bam $OUTPUTDIR/${SAMPLE}_001.bam