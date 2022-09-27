# ont-plasmid-assembly-and-reads-mapping

This script called 'auto_plasmid_assembly_readmap.sh' can assemble plasmid ONT reads into assembly by using EPI2ME/wf-clone-validation pipeline. The ONT reads are mapped against the reference by minimap2 without secondary mapping and have bam files as output. 

Manual of using the script:

1, Copy the script to a work directory.

2, Create a CSV file with barcode number as the first column, sample name as the second column,  No column header needed.

Example:

barcode01,sample1

barcode02,sample2

2, Prepare the reference sequences in a directory. The name of reference sequence fasta files should be the same as the sample name in the csv file. For example, the sample name is 'PlasmidA' then the reference file is 'PlasmidA.fasta'. Prepare a directory whose subdirectories (barcodeXX) contain fastq files. 

4, Run the script. In the first place, enter the path to the directory whose subdirectories contain fastq files. In the second place, enter the path to the directory of reference sequences. In the third place, enter the path to the CSV file.

Example:

bash auto_assembly_readsmap.sh /home/fungi/plasmid_reads /home/fungi/reference /home/fungi/sample.csv /home/fungi

5, The directory containing all the outputs called 'plasmid_assembly_map_output' will show up in your current work directory. The output directory will contain two subdirectories called 'assembly_output' and 'readmap_output' and also a log file.
