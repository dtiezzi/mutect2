#!/bin/bash

INPUTDIR='vcfDir'
name='SRR6677742'
OUTDIR='vcfSorted'

java -jar /home/dtiezzi/Softwares/picard/build/libs/picard.jar SortVcf \
SEQUENCE_DICTIONARY=./refGenome/GRCh38_filt.dict \
OUTPUT=$OUTDIR/$name.targeted_sequencing.mutect2.tumor_only.sorted.vcf.gz I=$INPUTDIR/$name.vcf.gz
#CREATE_INDEX=true
