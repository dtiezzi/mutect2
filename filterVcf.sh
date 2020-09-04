#!/bin/bash

INPUTDIR='vcfFinal'
name='SRR6677754'
REFGENOME='/mnt/md0/humanGenome/TCGA/GRCh38.d1.vd1.fa'
OUTDIR='mutcallFiltered'
FUNCOTATODATA='/home/dtiezzi/Softwares/gatk-4.1.6.0/funcotator_dataSources.v1.6.20190124s/'

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" LearnReadOrientationModel -I fir2/f1r2.tar.gz -O ${name}_read-orientation-model.tar.gz

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \ FilterMutectCalls -V $INPUTDIR/${name}.targeted_sequencing.tumor_only.gatk4_mutect2.raw_somatic_mutation.vcf.gz -R $REFGENOME --ob-priors ${name}_read-orientation-model.tar.gz --min-allele-fraction 0.05 --unique-alt-read-count 10 -O $OUTDIR/${name}_somatic_filtered.vcf

grep -E "#|PASS" $OUTDIR/${name}_somatic_filtered.vcf > $OUTDIR/${name}_somatic_filtered_PASS.vcf

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" Funcotator -R $REFGENOME -V $OUTDIR/${name}_somatic_filtered_PASS.vcf -O $OUTDIR/${name}_somatic_annotated.vcf --output-file-format VCF --data-sources-path $FUNCOTATODATA --ref-version hg38

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" Funcotator -R $REFGENOME -V $OUTDIR/${name}_somatic_filtered_PASS.vcf -O $OUTDIR/${name}_somatic_annotated.maf --output-file-format MAF --data-sources-path $FUNCOTATODATA --ref-version hg38 --annotation-override Tumor_Sample:${name}


