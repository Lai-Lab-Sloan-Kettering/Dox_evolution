#!/usr/bin/sh

readarray rows < files.out
#for query in "${header[@]}"; do

## script to remove additional 4 bp flanking linkers after adapeter removal ##

for row in "${rows[@]}";do
  row_array=(${row})
  file=${row_array[0]}


cutadapt -a AGATCGGAAGAGCACACGTCT -o ${file}.trim.fastq ${file}.fastq

#gunzip ${file}.trim.fastq.gz

awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 17 && length(seq) <= 44) \
{print header, seq, qheader, qseq}}' < ${file}.trim.fastq > ${file}.trim.filter.fastq

fastq_to_fasta -i ${file}.trim.filter.fastq -o ${file}.trim.filter.fa

sed -i 's/^[A-Z]\{4\}//' ${file}.trim.filter.fa

seqkit subseq -r 1:-5 ${file}.trim.filter.fa > ${file}.filter.final.fa

#readlength.sh bin=1 in=${file}.filter.final.fa out=histogram.${file}.txt

### Now let's remove unwanted processed files to save disk space ###

rm ${file}.trim.filter.fastq

rm ${file}.trim.filter.fa


done





