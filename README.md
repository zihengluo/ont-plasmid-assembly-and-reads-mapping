# Plasmid validation workflow with nanopore reads

Here we introduce a script called 'plasmid_assembly_readsmap.sh' which dose basecalling on ONT raw data and assemble plasmid ONT reads into assembly by using EPI2ME/wf-clone-validation pipeline. Then the ONT reads are filtered on specific minimum q-score and are mapped against the reference by minimap2 without secondary mapping, resulting in bam files as output. The script is placed at nanopore account of Schwessinger's team lab computer (nanopore@130.56.32.234:/home/nanopore/plasmid_assembly_readmap). The downstream analysis of plasmid validation is described below the script mannual.

## Manual of using the script:

1. Create a CSV file with barcode number as the first column, sample name as the second column,  No column header needed. The sample name is the same as the genious file name in our plasmid spreadsheet. Please replace the space with underscroes if there is any in the name.

Example:

barcode01,PER101

barcode02,PER101

2. Prepare the reference sequences in a directory. The name of reference sequence fasta files should be the same as the plasmidID in the csv file. For example, the plasmidID is 'PER101' then the reference file is 'PER101.fasta'. As for some plasmids with unusual name including special characters such as space, brackets and colon, please change these special characters into underscore. Also, when export plamid map into fasta sequence from geneious, you will be asked if special characters need to be change to underscore, please choose yes. Then double check the name of referecen sequences are consistent in csv file, fast file name, and fasta header.

3. locate the directory called fast5 containing fast5 data obtained from ONT sequencing.

4. Activate the env for script

`conda activate plasmid_assembly_readmap`

5. Run the script without input to read manual 

`bash /home/nanopore/plasmid_assembly_readmap/plasmid_assembly_readsmap.sh`

6. Fill in inputs for script
To fill inputs of the script, in the first place, enter the path to the directory which contain fast5 files for basecalling. In the second place, enter the path to the directory of reference sequences. In the third place, enter the path to the CSV file. All the path should be absolute. In the fourth place, enter the minimal quality score of reads involved in reads mapping. I would suggest q-score of 11 or slightly larger as a minimum threhodld for reads mapping. The mean q-score of reads we got previously were around 10. 

Here is an example of using test data in the script directory for try:

```
bash /home/nanopore/plasmid_assembly_readmap/plasmid_assembly_readsmap.sh /home/nanopore/plasmid_assembly_readmap/test_data/fastq /home/nanopore/plasmid_assembly_readmap/test_data/referencefa /home/nanopore/plasmid_assembly_readmap/test_data/barcode.csv 11
```

5, The directory containing all the outputs called 'yyyymmdd_plasmid_assembly_map_output' will show up in your current work directory. The output directory will contain three subdirectories called 'yyyymmdd_calledFastq', 'yyyymmdd_assembly_output', and 'yyyymmdd_readmap_output_minQ{num}' and also a log file.


## Analysis of plasmid validation from ONT reads

1. Inspect the files in output directories
Open the output 'yyyymmdd_assembly_output' directory, there will be many subdirectories named after time_plasmidID_barcode{num}. These are the outputs of each plasmid assembled by EPI2ME. Each plasmid's subdirectory will contain a report showing the length and quality of reads, assembly map and other information. If the assembly process is succesful, there will be a plasmid assembly in Fasta format and an annotation file in bed format. Open the output 'yyyymmdd_readmap_output_minQ{num}' directories, there will be bam files and index bai files for each plasmid which are named after plasmidID.barcode{num}.ontreas.map.bam.(bai). The output 'yyyymmdd_calledFastq' directory contains standard guppy output with reads of each barcode and log file.

2. Open the report of plasmid assembly and record the mean quality of reads which could be used as the minimal q-score for reads mapping. Inspect the length distribution to see if the longest reads are in a similar length as the reference sequence if the dimers or multimers appear. 

3.

