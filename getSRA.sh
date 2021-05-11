#!/usr/bin/sh

readarray rows < public_testis_RNA_seq.out ## file containing SRA IDs, one per line


for row in "${rows[@]}";do

row_array=(${row})
first=${row_array[0]}

echo Getting SRA entry ${first}....

#echo `/usr/bin/fastq-dump --gzip --split-3 ${first}`

fasterq-dump ${first} -t /your/dir/path --split-3

echo compressing data for ${first}....

gzip ${first}\_1.fastq

gzip ${first}\_2.fastq

done

