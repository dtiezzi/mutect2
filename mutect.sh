#!/bin/bash

name='SRR6677742'

while read -r line1;

	do

	chrL=$line1
	chr=$( echo "$chrL" |cut -d\: -f1 )


GENOME='/mnt/md0/humanGenome/TCGA/GRCh38.d1.vd1.fa'
VCFFILES='tmpVcfFiles'

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-Djava.io.tmpdir=/tmp -XX:+UseSerialGC -Xmx3G" Mutect2 \
-R $GENOME \
-L $chrL -I ./dupBam/${name}_md.bam \
-O $VCFFILES/$chr.mt2.vcf \
-tumor ${name} --af-of-alleles-not-in-resource 2.5e-06 \
--germline-resource /mnt/md0/somatic-hg38-af-only-gnomad.hg38.vcf.gz \
-pon /home/dtiezzi/ncbi/dbGaP-19480/mutect/gatk4_mutect2_4136_pon.vcf.gz

done < 'chrLengths'
