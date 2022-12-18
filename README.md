# Plasmid validation workflow with nanopore reads

Here we introduce a script called 'plasmid_assembly_readsmap.sh' which dose basecalling on ONT raw data and assemble plasmid ONT reads into assembly by using EPI2ME/wf-clone-validation pipeline. Then the ONT reads are filtered on specific minimum q-score and are mapped against the reference by minimap2 without secondary mapping, resulting in bam files as output. The script is placed and only availble at nanopore account of Schwessinger's team lab computer. The downstream analysis of plasmid validation is described below the script mannual.

## Attention
If the sequencing kit or barcode kit is changed, please change the commandline of guppy basecalling in the script.

## Manual of using the script:

1. Create a CSV file with barcode number as the first column, sample name as the second column,  No column header needed. The sample name is the same as the genious file name in our plasmid spreadsheet. Please replace the space with underscroes if there is any in the name.

Example:

barcode01,PER101

barcode02,PER101

2. Prepare the reference sequences in a directory. The name of reference sequence fasta files should be the same as the plasmidID in the csv file. For example, the plasmidID is 'PER101' then the reference file is 'PER101.fasta'. As for some plasmids with unusual name including special characters such as space, brackets and colon, please change these special characters into underscore. Also, when export plamid map into fasta sequence from geneious, you will be asked if special characters need to be change to underscore, please choose yes. Then double check the name of referecen sequences are consistent in csv file, fast file name, and fasta header.

3. locate the directory called 'fast5' containing raw data obtained from ONT sequencing. The input 'fast5' will be renamed as calledFast5 after basecalling.

4. Activate the env for script

`conda activate plasmid_assembly_readmap`

5. Run the script without input to read manual 

`bash plasmid_assembly_readsmap.sh`

6. Fill in inputs for script
To fill inputs of the script, in the first place, enter the path to the directory which contain fast5 files for basecalling. In the second place, enter the path to the directory of reference sequences. In the third place, enter the path to the CSV file. All the path should be absolute. In the fourth place, enter the minimal quality score of reads involved in reads mapping. I would suggest a q-score of 11 or slightly larger as the minimum threhodld for reads mapping. The mean q-score of reads we got previously were around 10. 

7, The directory containing all the outputs called 'yyyymmdd_plasmid_assembly_map_output' will show up in your current work directory. The output directory will contain three subdirectories called 'yyyymmdd_calledFastq', 'yyyymmdd_assembly_output', and 'yyyymmdd_readmap_output_minQ{num}' and also a log file.


## Here is an example of using test data in the script directory for try:

```
bash plasmid_assembly_readsmap.sh fast5 reference barcode.csv 11
```



## Analysis of plasmid validation from ONT reads

The downstream analysis is demonstrated in the following doc placed at team onedrive.

