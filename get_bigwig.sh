#!/usr/bin/sh

readarray dat < files.out ## file names, one per line

#for query in "${header[@]}"; do


workdir=/your/dir/path

for dat in "${dat[@]}";do
  row_array=(${dat})
  file=${row_array[0]}


## have spike-in sequences in a file with one sequence per line ## (spike_in_seqs.out)
  
wig=$(samtools view -c -F 260 ${workdir}/${file}.bam)
spike=$(grep -Fwf spike_in_seqs.out ${file}.fa | wc -l)


million=1000000
norm=$(awk 'BEGIN{printf("%0.0f", '$wig' / '$spike')}')

wigsum=$(awk 'BEGIN{printf("%0.0f", '$norm' * '$million')}')

## Let's get the bigwig files

## Install RSeqC package in PATH to run bam2wig.py

bam2wig.py -i ${file}\_sorted.bam -s chrom.sizes -t ${wigsum} -d ++,-- -q 0 -o ${file}


done

