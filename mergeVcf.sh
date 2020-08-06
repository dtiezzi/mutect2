#!/bin/bash

VCFFILES='tmpVcfFiles'
OUTPREF='SRR6677742'
OUTVCFS='vcfDir'

java -jar /home/dtiezzi/Softwares/picard/build/libs/picard.jar MergeVcfs \
I=input_variant_files.list O=$OUTVCFS/$OUTPREF.vcf.gz
