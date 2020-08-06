#!/bin/bash

name='SRR6677742'
OUTDIR='vcfSorted'

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" MergeMutectStats --stats input_stats_files.list -O $OUTDIR/$name.targeted_sequencing.mutect2.tumor_only.sorted.vcf.gz.stats
