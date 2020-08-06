#!/bin/bash

OUTBAM='mergedBam'

java -jar /home/dtiezzi/Softwares/picard/build/libs/picard.jar MergeSamFiles \
ASSUME_SORTED=false \
CREATE_INDEX=true \
INPUT=sortedBam/SRR6677746_sorted.bam \
INPUT=sortedBam/SRR6677744_sorted.bam \
INPUT=sortedBam/SRR6677747_sorted.bam \
INPUT=sortedBam/SRR6677752_sorted.bam \
INPUT=sortedBam/SRR6677745_sorted.bam \
INPUT=sortedBam/SRR6677749_sorted.bam \
INPUT=sortedBam/SRR6677748_sorted.bam \
INPUT=sortedBam/SRR6677743_sorted.bam \
INPUT=sortedBam/SRR6677750_sorted.bam \
INPUT=sortedBam/SRR6677742_sorted.bam \
INPUT=sortedBam/SRR6677751_sorted.bam \
INPUT=sortedBam/SRR6677753_sorted.bam \
MERGE_SEQUENCE_DICTIONARIES=false \
OUTPUT= $OUTBAM/merged.bam \
SORT_ORDER=coordinate \
USE_THREADING=true \
VALIDATION_STRINGENCY=STRICT
