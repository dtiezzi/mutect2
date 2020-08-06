#!/bin/bash

INPUTDIR='./dupBam'
name='SRR6677742'

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
GetSampleName \
-I $INPUTDIR/${name}_md.bam \
-O tumour.targeted_sequencing.${name}
