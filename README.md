# Plasmid validation workflow with nanopore reads

Here we introduce a script called 'plasmid_assembly_readsmap.sh' which does base calling on ONT raw data and assemble plasmid ONT reads into assembly by using the EPI2ME/wf-clone-validation pipeline. Then the ONT reads are filtered on a specific minimum q-score and are mapped against the reference by minimap2 without secondary mapping, resulting in bam files as output.

## Attention
The script placed on our lab computer is well-written and the environment has been set up. The script on GitHub has no complete path for example run and argument for base calling.
Please change the guppy base calling command line in the script if the kits are changed.
Create a conda environment with the yml file to run the script if using the script at a place other than our lab computer's specific account.

## Manual of using the script:

1. Create a CSV file with the barcode number as the first column, and the sample name as the second column.  No column header is needed. The sample name is the same as the Geneious file name in our plasmid spreadsheet. Please replace the space, brackets, colon or other special characters with underscores in the name.

Example:

barcode01,plasmidA

barcode02,plasmidB

2. Prepare the reference sequences in a directory. The name of reference sequence fasta files should be the same as the plasmid in the csv file. For example, if the plasmid is 'plasmidA' then the reference file is 'plasmidA.fasta'. As for some plasmids with unusual names including special characters such as space, brackets, and colon, please change these special characters into an underscore. Also, when exporting a plamid map into fasta sequence from the Geneious, you will be asked if special characters need to be changed to underscore, please choose yes. Then double-check the name of the reference sequences is consistent in the CSV file, fasta file name, and fasta header.

3. locate the directory called 'fast5' containing raw data obtained from ONT sequencing. The input 'fast5' will be renamed as ‘calledFast5’ after base calling.

4. Activate the env for the script

`conda activate plasmid_assembly_readmap`

5. Run the script without input to read manual 

`bash /PATH/plasmid_assembly_readsmap.sh`

6. Fill in inputs for script
To fill inputs of the script, in the first place, enter the path to the directory which contains fast5 files for base-calling. In the second place, enter the path to the directory of reference sequences. In the third place, enter the path to the CSV file. All the paths should be absolute. In the fourth place, enter the minimal quality score of reads involved in reads mapping. I would suggest a q-score of 11 or slightly larger as the minimum threshold for reads mapping. The mean q-score of reads we got previously was around 10. 

7, The directory containing all the outputs called 'yyyymmdd_plasmid_assembly_map_output' will show up in your current work directory. The output directory will contain three subdirectories called 'yyyymmdd_calledFastq', 'yyyymmdd_assembly_output', and 'yyyymmdd_readmap_output_minQ{num}' and also a log file.


## Here is an example for try (you need to fill in PATH):

```
bash /PATH/plasmid_assembly_readsmap.sh /PATH/fast5 /PATH/reference /PATH/barcode.csv 11
```
