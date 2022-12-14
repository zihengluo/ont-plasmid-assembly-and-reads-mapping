# activate conda, otherwise error will appeaar sometimes. The PATH needs to be filled depending on conda location at your machine.
eval "$(/PATH/conda/bin/conda shell.bash hook)"

# short mannual of using the script
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
echo barcode01,plasmidA
echo barcode02,plasmidB
echo
echo Here is an example usage:
echo bash /PATH/plasmid_assembly_readsmap.sh /PATH/fast5 /PATH/referencefa /PATH/barcode.csv 11
}

# If no input is given, return manual
if [[ $# -eq 0 ]] ; then
    Help
    exit 0
fi

# specify the database path for EPI2ME workflow
DB_PATH=/PATH/wf-clone-validation-db

# make output directories
current_path=$(pwd)
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output
mkdir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_readmap_output_minQ$4

{

# do basecalling on fast5 input
/PATH/guppy_basecaller \
-i $1 \
-s $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq \
-c ***********.cfg -r -x auto --disable_qscore_filtering --barcode_kits "*************"

# change input fast5 dirctory name to calledFast5
cd $1 && cd .. && mv fast5 calledFast5 && cd $current_path

# read in CSV file and extract barcode number and plasmid names
while read LS;
do BC=$(echo ${LS} | cut -d ',' -f 1);
SAMPLE=$(echo ${LS} | cut -d ',' -f 2);
echo "Working on ${BC} which is sample ${SAMPLE}";

# run plasmid assembly pipeline
nextflow run epi2me-labs/wf-clone-validation -r 944a6f9bf6 -profile conda --db_directory ${DB_PATH} \
	--fastq $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC} \
	--out_dir $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output/$(date +%Y%m%d)_${SAMPLE}_${BC};

# go into the assembly output directory and change file names
cd $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_assembly_output/$(date +%Y%m%d)_${SAMPLE}_${BC};
mv ${BC}.final.fasta ${SAMPLE}.${BC}.assembly.fasta;
mv ${BC}.annotations.bed ${SAMPLE}.${BC}.annotation.bed;
mv wf-clone-validation-report.html ${SAMPLE}_${BC}_assembly_report.html;
sed -i "s/${BC}/${SAMPLE}_${BC}/g" ${SAMPLE}.${BC}.assembly.fasta;
cd $current_path;

# merge the fastq files of each barcode and do filterring on each merged reads with the given minimum q-score
cat $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/*.fastq > $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/merged.fastq;
conda activate /home/groups/schwessinger/condaEnvs/NanoplotEtAl;
NanoFilt -q $4 $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/merged.fastq | gzip > $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/highQuality-reads.fastq.gz;

# do reads mapping against the plasmid reference sequence
conda activate plasmid_assembly_readmap;
minimap2 -ax map-ont -t 10 --secondary=no $2/${SAMPLE}.fasta $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/highQuality-reads.fastq.gz | samtools sort -@8 -O BAM -o $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_readmap_output_minQ$4/${BC}.${SAMPLE}.minQ$4.bam;
samtools index $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_readmap_output_minQ$4/${BC}.${SAMPLE}.minQ$4.bam;

# remove the merged and filtered fastq reads to save disk usage, then the script ends up and records all the log
rm $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/merged.fastq;
rm $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%Y%m%d)_calledFastq/${BC}/highQuality-reads.fastq.gz;
done<$3
} | tee $current_path/$(date +%Y%m%d)_plasmid_assembly_readmap_output/$(date +%T).log

