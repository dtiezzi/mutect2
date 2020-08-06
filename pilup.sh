#!/bin/bash
name='SRR6677742'
GENOME='./refGenome/GRCh38_filt.fa'

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
GetPileupSummaries \
-I ./dupBam/${name}_md.bam \
-O ${name}.targeted_sequencing.table \
-V /mnt/md0/somatic-hg38-af-only-gnomad.hg38.vcf.gz --intervals /mnt/md0/humanGenome/TCGA/intervals.bed -R $GENOME
