#!/usr/bin/sh

readarray dat < files.out ## file names, one per line


workdir=/your/dir/path

for dat in "${dat[@]}";do
  row_array=(${dat})
  file=${row_array[0]}

# Let's map sRNA data with bowtie

bowtie -q -p 4 -v 0 -k 20 --best --strata /path/to/genome_index \
-f ${file}.filter.final.fa --sam ${file}.sam

#Convert SAM to BAM
samtools view -bS ${file}.sam > ${file}.bam

#Sort BAM file
samtools sort ${file}.bam > ${file}\_sorted.bam

#Index BAM file
samtools index ${file}\_sorted.bam

#Let's remove the SAM file to save diskspace
rm ${file}.sam

## Let's use the RNAseQC tool bam2wig.py to get bigwig files ##


wig=$(samtools view -c -F 260 ${workdir}/${file}.bam)
spike=$(grep -Fwf spike_in_seqs.out ${file}.fa | wc -l)


million=1000000
norm=$(awk 'BEGIN{printf("%0.0f", '$wig' / '$spike')}')

wigsum=$(awk 'BEGIN{printf("%0.0f", '$norm' * '$million')}')

## Let's get the bigwig files

bam2wig.py -i ${file}\_sorted.bam -s chrom.sizes -t ${wigsum} -d ++,-- -q 0 -o ${file}


done
