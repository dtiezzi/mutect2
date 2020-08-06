#!/bin/bash

GENOME='/mnt/md0/humanGenome/TCGA/GRCh38.d1.vd1.fa'
INDIR='vcfSorted'
name='SRR6677742'
OUTDIR='vcfFilt1'

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
FilterMutectCalls \
-R $GENOME \
-O $name.targeted_sequencing.mutect2.tumor_only.contFiltered.vcf.gz \
-V $name.targeted_sequencing.mutect2.tumor_only.sorted.vcf.gz --contamination-table $name.targeted_sequencing.contamination.table \
-L /mnt/md0/humanGenome/TCGA/intervals.bed

