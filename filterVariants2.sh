#!/bin/bash

GENOME='/mnt/md0/humanGenome/TCGA/GRCh38.d1.vd1.fa'
name='SRR6677742'
OUTDIR='vcfFinal'
/home/dtiezzi/Softwares/gatk-4.0.2.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" FilterByOrientationBias  \
-O ../$OUTDIR/$name.targeted_sequencing.tumor_only.gatk4_mutect2.raw_somatic_mutation.vcf.gz \
-P ../OXO/$name.pre_adapter_detail_metrics.txt -V $name.targeted_sequencing.mutect2.tumor_only.contFiltered.vcf.gz -L /mnt/md0/humanGenome/TCGA/intervals.bed \
-R $GENOME \
-AM G/T \
-AM C/T

