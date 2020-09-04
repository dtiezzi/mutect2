#!/bin/bash
while read -r line
	do
	name=${line%????};

    ## GLOBAL VARIABLES

    GENOME='./refGenome/GRCh38_filt.fa'
    REFDICT='./refGenome/GRCh38_filt.dict'
    INPUTBAM='dupBam'
    GNOMAD='/mnt/md0/somatic-hg38-af-only-gnomad.hg38.vcf.gz'
    BEDINTERVALS='/mnt/md0/humanGenome/TCGA/intervals.bed'
    REFGENOME='/mnt/md0/humanGenome/TCGA/GRCh38.d1.vd1.fa'
    VCFFILES='tmpVcfFiles'
    PONFILE='/home/dtiezzi/ncbi/dbGaP-19480/mutect/gatk4_mutect2_4136_pon.vcf.gz'
    OUTVCFS='vcfDir'
    VCFSORTED='vcfSorted'

    echo '[INFO] starting analysis on' $name

    ## 1. Generate OXOG metrics:

    echo '[INFO] Step 1: ' $name

    /home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
    CollectSequencingArtifactMetrics \
    -I ./$INPUTBAM/${name}_md.bam \
    -O ./OXO/$name \
    --FILE_EXTENSION .txt \
    -R $GENOME ;

    cp ./OXO/$name.pre_adapter_detail_metrics.txt ./vcfSorted ;

    ## 2. Generate pileup summaries on tumor sample:

    echo '[INFO] Step 2: ' $name

    /home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
    GetPileupSummaries \
    -I ./dupBam/${name}_md.bam \
    -O ${name}.targeted_sequencing.table \
    -V $GNOMAD --intervals $BEDINTERVALS -R $GENOME ;

    ## 3. Calculate contamination on tumor sample

    echo '[INFO] Step 3: ' $name

    /home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
    CalculateContamination \
    -I ${name}.targeted_sequencing.table -O ./$VCFSORTED/${name}.targeted_sequencing.contamination.table ;

    ## 4. Find tumor sample name from BAM

    echo '[INFO] Step 4: ' $name

    /home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
    GetSampleName \
    -I $INPUTBAM/${name}_md.bam \
    -O tumour.targeted_sequencing.${name} ;

    ## 5. Run MuTect2 using only tumor sample on chromosome level (25 commands with different intervals)

    echo '[INFO] Step 5 (MUTECT2 loop): ' $name

    while read -r line1;

        do

        chrL=$line1
        chr=$( echo "$chrL" |cut -d\: -f1 )



        /home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-Djava.io.tmpdir=/tmp -XX:+UseSerialGC -Xmx3G" Mutect2 \
        -R $REFGENOME \
        -L $chrL -I ./$INPUTBAM/${name}_md.bam \
        -O $VCFFILES/$chr.mt2.vcf \
        -tumor ${name} --af-of-alleles-not-in-resource 2.5e-06 \
        --germline-resource $GNOMAD \
        --f1r2-tar-gz f1r2.tar.gz \
        -pon $PONFILE

    done < 'chrLengths' ;

    ## After this step, all chromosome level VCFs are merged into one.

    java -jar /home/dtiezzi/Softwares/picard/build/libs/picard.jar MergeVcfs \
    I=input_variant_files.list O=$OUTVCFS/$name.vcf.gz ;

    /home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" MergeMutectStats --stats input_stats_files.list -O $VCFSORTED/$name.targeted_sequencing.mutect2.tumor_only.sorted.vcf.gz.stats ;

    ## 6. Sort VCF with Picard

    echo '[INFO] Step 6: ' $name

    java -jar /home/dtiezzi/Softwares/picard/build/libs/picard.jar SortVcf \
    SEQUENCE_DICTIONARY=$REFDICT \
    OUTPUT=$VCFSORTED/$name.targeted_sequencing.mutect2.tumor_only.sorted.vcf.gz I=$OUTVCFS/$name.vcf.gz

    cd $VCFSORTED ;

    ## 7. Filter variant calls from MuTect

    echo '[INFO] Step 7: ' $name

    /home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
    FilterMutectCalls \
    -R $REFGENOME \
    -O $name.targeted_sequencing.mutect2.tumor_only.contFiltered.vcf.gz \
    -V $name.targeted_sequencing.mutect2.tumor_only.sorted.vcf.gz --contamination-table $name.targeted_sequencing.contamination.table \
    -L $BEDINTERVALS ;

    ## 8. Filter variants by orientation bias

    echo '[INFO] Step 8: ' $name

    VCFFINALDIR='vcfFinal'
    /home/dtiezzi/Softwares/gatk-4.0.2.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" FilterByOrientationBias  \
    -O ../$VCFFINALDIR/$name.targeted_sequencing.tumor_only.gatk4_mutect2.raw_somatic_mutation.vcf.gz \
    -P $name.pre_adapter_detail_metrics.txt -V $name.targeted_sequencing.mutect2.tumor_only.contFiltered.vcf.gz -L $BEDINTERVALS \
    -R $REFGENOME \
    -AM G/T \
    -AM C/T ;

    cd ..

    echo '[INFO] Analysis DONE in ' $name

done < 'bamFiles'