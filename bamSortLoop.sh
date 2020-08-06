#!/bin/bash

OUTBAM='outputBam'
OUTBAMSORT='sortedBam'

while read -r line
	do

	name=${line};

java -jar /home/dtiezzi/Softwares/picard/build/libs/picard.jar SortSam \
CREATE_INDEX=true \
INPUT=$OUTBAM/${name} \
OUTPUT=$OUTBAMSORT/${name%????}_sorted.bam \
SORT_ORDER=coordinate \
VALIDATION_STRINGENCY=STRICT


done < 'bamFiles'
