# ont-plasmid-assembly-and-reads-mapping

This script called 'auto_plasmid_assembly_readmap.sh' can assemble plasmid ONT reads into assembly by using EPI2ME/wf-clone-validation pipeline. The ONT reads are mapped against the reference by minimap2 without secondary mapping and have bam files as output. The script is placed at nanopore account on labcomputer (/home/nanopore/plasmid_assembly_readmap).

Manual of using the script:


1, Create a CSV file with barcode number as the first column, sample name as the second column,  No column header needed. The sample name is the same as the genious file name in our plasmid spreadsheet. Please replace the space with underscroes if there is any in the name.

Example:

barcode01,PER101

barcode02,PER101

2, Prepare the reference sequences in a directory. The name of reference sequence fasta files should be the same as the sample name in the csv file. For example, the sample name is 'PER101' then the reference file is 'PER101.fasta'. 

3, Prepare a directory whose subdirectories (barcodeXX) contain fastq files. Usually, the basecalling ouput directory can be directly used for it.

4, Go into the directory of script 

`cd /home/nanopore/plasmid_assembly_readmap`

Activate the env for it 

`conda activate plasmid_assembly_readmap.sh`

Run the script without input to read manual 

`bash plasmid_assembly_readmap.sh`

To fill inputs of the script, in the first place, enter the path to the directory whose subdirectories contain fastq files. In the second place, enter the path to the directory of reference sequences. In the third place, enter the path to the CSV file. All the path should be absolute.

Here is an example of using test data in the script directory for try:

```
bash auto_assembly_readsmap.sh /home/nanopore/plasmid_assembly_readmap/test_data/fastq /home/nanopore/plasmid_assembly_readmap/test_data/referencefa /home/nanopore/plasmid_assembly_readmap/test_data/barcode.csv
```

5, The directory containing all the outputs called 'yyyymmdd_plasmid_assembly_map_output' will show up in your current work directory. The output directory will contain two subdirectories called 'yyyymmdd_assembly_output' and 'yyyymmdd_readmap_output' and also a log file.
