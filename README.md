# Plasmid validation workflow with nanopore reads

Here we introduce a script called 'plasmid_assembly_readsmap.sh' which can assemble plasmid ONT reads into assembly by using EPI2ME/wf-clone-validation pipeline. Then the ONT reads are filtered on specific minimum q-score and are mapped against the reference by minimap2 without secondary mapping resulting in bam files as output. The script is placed at nanopore account of Schwessinger's team lab computer (nanopore@130.56.32.234:/home/nanopore/plasmid_assembly_readmap). The downstream analysis of plasmid validation is described after the script mannual.

## Manual of using the script:

1, Create a CSV file with barcode number as the first column, sample name as the second column,  No column header needed. The sample name is the same as the genious file name in our plasmid spreadsheet. Please replace the space with underscroes if there is any in the name.

Example:

barcode01,PER101

barcode02,PER101

2, Prepare the reference sequences in a directory. The name of reference sequence fasta files should be the same as the sample name in the csv file. For example, the sample name is 'PER101' then the reference file is 'PER101.fasta'. 

3, Prepare a directory whose subdirectories (barcodeXX) contain fastq files. Usually, the basecalling ouput directory can be directly used for it.

4, Activate the env for script

`conda activate plasmid_assembly_readmap`

Run the script without input to read manual 

`bash /home/nanopore/plasmid_assembly_readmap/plasmid_assembly_readsmap.sh`

To fill inputs of the script, in the first place, enter the path to the directory whose subdirectories contain fastq files. In the second place, enter the path to the directory of reference sequences. In the third place, enter the path to the CSV file. All the path should be absolute. In the fourth place, enter the minimal quality score for filitering.

Here is an example of using test data in the script directory for try:

```
bash /home/nanopore/plasmid_assembly_readmap/plasmid_assembly_readsmap.sh /home/nanopore/plasmid_assembly_readmap/test_data/fastq /home/nanopore/plasmid_assembly_readmap/test_data/referencefa /home/nanopore/plasmid_assembly_readmap/test_data/barcode.csv 11
```

5, The directory containing all the outputs called 'yyyymmdd_plasmid_assembly_map_output' will show up in your current work directory. The output directory will contain two subdirectories called 'yyyymmdd_assembly_output' and 'yyyymmdd_readmap_output_minQ{num}' and also a log file.


## Analysis of plasmid validation from ONT reads


