#!/usr/bin/sh

### Script to remove adapter sequences and convert filter reads >=17 and <=35 ###

readarray rows < files.out # file names to process
#for query in "${header[@]}"; do

for row in "${rows[@]}";do
  row_array=(${row})
  file=${row_array[0]}

## install dnapi.py in the PATH. dnapi is a de novo adapter prediction alogrithm (https://github.com/jnktsj/DNApi)
  
adapt=$(dnapi.py ${file}.fastq)

echo $adapt

cutadapt -a ${adapt} -o ${file}.trim.fastq ${file}.fastq


awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 17 && length(seq) <= 35) \
{print header, seq, qheader, qseq}}' < ${file}.trim.fastq > ${file}.trim.filter.fastq


## install FASTX toolkit in the PATH to run fastq_to_fasta

fastq_to_fasta -i ${file}.trim.filter.fastq -o ${file}.trim.filter.fa

done
