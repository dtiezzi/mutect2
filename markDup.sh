#!/bin/bash

#INBAM='mergedBam'
OUTBAMDUP='dupBam'
#name='merged.bam'
INPUTDIR='sortedBam'

while read -r line
	do

	name=${line};

java -jar /home/dtiezzi/Softwares/picard/build/libs/picard.jar MarkDuplicates \
CREATE_INDEX=true \
INPUT=$INPUTDIR/${name%????}_sorted.bam \
OUTPUT=$OUTBAMDUP/${name%????}_md.bam \
METRICS_FILE=$OUTBAMDUP/${name%????}_marked_dup_metrics.txt \
VALIDATION_STRINGENCY=STRICT

done < 'bamFiles'
