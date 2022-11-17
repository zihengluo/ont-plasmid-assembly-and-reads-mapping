Help()
{
echo Here is an automatic script for high quality plasmid reads mapping
echo In the first place, enter the path to the directory containing subdirectories name after barcode number and have ONT reads in fastq format
echo In the second plcae, enter the path to the directory containing reference seuqences name after sample names and are in fasta format
echo In the third place, enter the path to the headless csv file containing barcode number and sample name
echo Outputs will be in the directory running the script
echo
echo Here is an example of csv file:
echo
echo barcode01,PER101
echo barcode02,PER101
echo
echo Here is an example usage:
echo bash auto_assembly_readmap.sh /home/nanopore/plasmid_assembly_readmap/test_data/fastq /home/nanopore/plasmid_assembly_readmap/test_data/referencefa /home/nanopore/plasmid_assembly_readmap/test_data/barcode.csv
}


if [[ $# -eq 0 ]] ; then
    Help
    exit 0
fi


current_path=$(pwd)
mkdir $current_path/$(date +%Y%m%d)_highQ_map

{
while read LS;
do BC=$(echo ${LS} | cut -d ',' -f 1);
SAMPLE=$(echo ${LS} | cut -d ',' -f 2);
cat $1/${BC}/*.fastq > merged.fastq;
conda activate nanofilt;
NanoFilt -q $4 $1/${BC}/merged.fastq | gzip > $1/${BC}/highQuality-reads.fastq.gz;
conda activate minimap2;
minimap2 -ax map-ont -t 10 --secondary=no $2/${SAMPLE}.fasta $1/${BC}/highQuality-reads.fastq.gz | samtools sort -@8 -O BAM -o $current_path/$(date +%Y%m%d)_highQ_map/${BC}.${SAMPLE}.highQreads.bam;
samtools index $current_path/$(date +%Y%m%d)_highQ_map/${BC}.${SAMPLE}.highQreads.bam;
rm $1/${BC}/*.fastq > merged.fastq;
rm $1/${BC}/highQuality-reads.fastq.gz;
done<$3
} 
