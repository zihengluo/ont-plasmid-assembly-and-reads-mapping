eval "$(/opt/conda/bin/conda shell.bash hook)"
Help()
{
echo Here is an automatic script for plasmid assembly and reference vs. reads mapping, please follow the instruction to enter inputs:
echo In the first place, enter the path to the directory containing fast5 raw data obtained from ONT sequencing
echo In the second plcae, enter the path to the directory containing reference seuqences name after sample names and are in fasta format
echo In the third place, enter the path to the headless csv file containing barcode number and sample name
echo In the fourth place, enter the minimal quality score for filitering
echo Outputs will be in the directory running the script
echo
echo Here is an example of csv file:
echo
echo barcode01,PER101
echo barcode02,PER101
echo
echo Here is an example usage:
echo bash /home/nanopore/plasmid_assembly_readmap/plasmid_assembly_readsmap.sh /media/nvme/MinKNOW/Plasmids/20220825_plasmid1/no_sample/20220825_1335_MN21513_FAR25955_fa2a0187/fast5_subset /home/nanopore/plasmid_assembly_readmap/test_data/referencefa>
}


if [[ $# -eq 0 ]] ; then
    Help
    exit 0
fi

DB_PATH=/home/nanopore/plasmid_assembly_readmap/wf-clone-validation-db

current_path=$(pwd)
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_readmap_output_minQ$4

{
/home/groups/schwessinger/guppy/6.2.1/ont-guppy/bin/guppy_basecaller \
-i $1 \
-s $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq \
-c dna_r9.4.1_450bps_sup.cfg -r -x auto --disable_qscore_filtering --barcode_kits "SQK-RBK110-96"

cd $1 && cd .. && mv fast5 calledFast5 && cd $current_path


while read LS;
do BC=$(echo ${LS} | cut -d ',' -f 1);
SAMPLE=$(echo ${LS} | cut -d ',' -f 2);
echo "Working on ${BC} which is sample ${SAMPLE}";
nextflow run epi2me-labs/wf-clone-validation -r 944a6f9bf6 -profile conda --fastq $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC} --db_directory ${DB_PATH} --out_dir $current_path/$(date +%Y%m%d)>
cd $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output/$(date +%Y%m%d)_${SAMPLE}_${BC};
mv ${BC}.final.fasta ${SAMPLE}.${BC}.assembly.fasta;
mv ${BC}.annotations.bed ${SAMPLE}.${BC}.annotation.bed;
mv wf-clone-validation-report.html ${SAMPLE}_${BC}_assembly_report.html;
cd $current_path
cat $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/*.fastq >$current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/merged.fastq;
conda activate /home/groups/schwessinger/condaEnvs/NanoplotEtAl;
NanoFilt -q $4 $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/merged.fastq | gzip > $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/highQuality-reads.fastq.gz;
conda activate plasmid_assembly_readmap;
minimap2 -ax map-ont -t 10 --secondary=no $2/${SAMPLE}.fasta $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/highQuality-reads.fastq.gz | samtools sort -@8 -O BAM -o $current_path/$(date +%Y%m%d)>
samtools index $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_readmap_output_minQ$4/${BC}.${SAMPLE}.minQ$4.bam;
rm $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/merged.fastq;
rm $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/highQuality-reads.fastq.gz;
done<$3
} | tee $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%T).log
