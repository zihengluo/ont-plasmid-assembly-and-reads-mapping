#! /bin/bash



# specify the path to input data

FA_PATH=

FQ_PATH=

DB_PATH=





# create the output directories

mkdir $(date +%Y%m%d)_plasmid_assembly_readmap_output

mkdir $(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output

mkdir $(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_readmap_output



# read in csv file for information, run assembly pipeline, and map reads

while read LS;

do BC=$(echo ${LS} | cut -d ',' -f 1);

SAMPLE=$(echo ${LS} | cut -d ',' -f 2);

SIZE=$(echo ${LS} | cut -d ',' -f 3);

echo "Working on ${BC} which is sample ${SAMPLE}";

nextflow run epi2me-labs/wf-clone-validation -profile conda --approx_size ${SIZE} --fastq ${FQ_PATH}/${BC} --db_directory ${DB_PATH} --out_dir $(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output/$(date +%Y%m%d)_${SAMPLE}_${BC};

cd $(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output/$(date +%Y%m%d)_${SAMPLE}_${BC};

mv ${BC}.final.fasta ${SAMPLE}.${BC}.assembly.fasta;

mv ${BC}.annotations.bed ${SAMPLE}.${BC}.annotation.bed;

mv wf-clone-validation-report.html ${SAMPLE}_${BC}_assembly_report.html;

cd ../../$(date +%Y%m%d)_readmap_output

minimap2 -ax map-ont -t 1 --secondary=no ${FA_PATH}/${SAMPLE}.fasta ${FQ_PATH}/${BC}/*.fastq | samtools sort -@16 -O BAM -o ${SAMPLE}.${BC}.ontreads.map.bam;

samtools index ${SAMPLE}.${BC}.ontreads.map.bam;

cd ../..

done<barcode.csv
