#!/bin/bash

INFASTQ='fastqFiles'
OUTBAM='outputBam'
REFGENOME='./refGenome/GRCh38_filt.fa'

while read -r line1 && read -r line2;
	do

	name=${line1::-8};
	name1=$line1;
	name2=$line2;


id=$(echo $name | head -n 1 | cut -f 1-4 -d":" | sed 's/@//' | sed 's/:/_/g')
#sm=$(echo $name | head -n 1 | grep -Eo "[ATGCN]+$")
READG="@RG\tID:$id\tSM:$id""\tLB:$id""\tPL:ILLUMINA"

#echo $READG
echo '[INFO] Aligning the ' ${name}' file...'

bwa mem -t 8 -T 0 -R $READG $REFGENOME $INFASTQ/${name1} $INFASTQ/${name2} > ./$OUTBAM/${name}.sam 

echo '[DONE] '${name}' file aligned!'

cd $OUTBAM ;

echo '[INFO] Converting sam 2 bam...'

samtools view -Sb -@ 8 ${name}.sam > ${name}.bam

rm ${name}.sam

echo '[DONE] sam 2 bam '${name}' file converted!'

cd .. ;

done < 'fastq2bwa'
