#!/bin/bash

name='SRR6677742'
GENOME='./refGenome/GRCh38_filt.fa'

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
CollectSequencingArtifactMetrics \
-I ./dupBam/${name}_md.bam \
-O ./OXO/$name \
--FILE_EXTENSION .txt \
-R $GENOME  ## Only chr1-22 + XYM
