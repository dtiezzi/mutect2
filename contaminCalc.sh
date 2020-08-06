#!/bin/bash
name='SRR6677742'

/home/dtiezzi/Softwares/gatk-4.1.6.0/gatk --java-options "-XX:+UseSerialGC -Xmx3G" \
CalculateContamination \
-I ${name}.targeted_sequencing.table -O ${name}.targeted_sequencing.contamination.table
