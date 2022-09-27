Help()
{
echo Here is an automatic script for plasmid assembly and reference vs. reads mapping, please follow the instruction to enter inputs:
echo At first place, enter the path to the directory containing subdirectories name after barcode number and have ONT reads in fastq format
echo At second plcae, enter the path to the directory containing reference seuqences name after sample names and are in fasta format
echo At third place, enter the path to the headless csv file containing barcode number and sample name
echo Outputs will be in the directory running the script
echo
echo Here is an example of csv file:
echo
echo barcode01,sample1
echo barcode02,sample2
echo
echo Here is an example usage:
echo bash makeflag.sh /home/fungi/plasmid_reads /home/fungi/reference /home/fungi/sample.csv /home/fungi
}


if [[ $# -eq 0 ]] ; then
    Help
    exit 0
fi

DB_PATH=/home/ziheng/plasmid/wf-clone-validation-db

current_path=$(pwd)
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_readmap_output


{
while read LS;
do BC=$(echo ${LS} | cut -d ',' -f 1);
SAMPLE=$(echo ${LS} | cut -d ',' -f 2);
echo "Working on ${BC} which is sample ${SAMPLE}";
nextflow run epi2me-labs/wf-clone-validation -profile conda --fastq $1/${BC} --db_directory ${DB_PATH} --out_dir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output/$(date +%Y%m%d)_${SAMPLE}_${BC};
cd $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output/$(date +%Y%m%d)_${SAMPLE}_${BC};
mv ${BC}.final.fasta ${SAMPLE}.${BC}.assembly.fasta;
mv ${BC}.annotations.bed ${SAMPLE}.${BC}.annotation.bed;
mv wf-clone-validation-report.html ${SAMPLE}_${BC}_assembly_report.html;
cd $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_readmap_output
minimap2 -ax map-ont -t 1 --secondary=no $2/${SAMPLE}.fasta $1/${BC}/*.fastq | samtools sort -@16 -O BAM -o ${SAMPLE}.${BC}.ontreads.map.bam;
samtools index ${SAMPLE}.${BC}.ontreads.map.bam;
cd $current_path
done<$3
} | tee $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%T).log
