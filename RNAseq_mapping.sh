#!/usr/bin/sh

## Pipeline to map RNAseq data ##


## Let's set the working directory
workdir=/path/to/your/working/directory

## First let's build a genome index for mapping RNA seq data using Hisat2 ##

hisat2-build [genome].fasta [genome]

#Set read type
read1=1
read2=2


#Map RNA-seq data for all samples #

readarray rows < files.out  # file with sample names, one per line


for row in "${rows[@]}";do
  row_array=(${row})
  file=${row_array[0]}


#Map paired end reads with hisat2

hisat2 -x dm6 -1 ${workdir}/${file}\_${read1}.fastq.gz -2 ${workdir}/${file}\_${read2}.fastq.gz -S ${file}.sam


#Convert SAM to BAM
samtools view -bS ${file}.sam > ${file}.bam

#Sort BAM file
samtools sort ${file}.bam > ${file}\_sorted.bam

#Index BAM file
samtools index ${file}\_sorted.bam

#Let's remove the SAM file to save diskspace
rm ${file}.sam

#Get mapping stats using RSeQ package

bam_stat.py -i ${file}\_sorted.bam | sed 's/Non primary hits//g' | \
awk '{sub(/.*:/,""); print}' | awk '{ sub(/^[ \t]+/, ""); print }' | sed 's/=//g' | \
sed 's/#//g' | sed 's/All numbers are READ count//g' | awk 'NF > 0' | tr "\n" " " | \
awk '{print "'"${file}"'",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' | tr ' ' '\t' >> mapping_stats.txt


done


