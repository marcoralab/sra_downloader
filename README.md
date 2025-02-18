## SRA DOWNLOADER
Date: 2022-05-16    
Author: Tulsi Patel   

**PURPOSE:**
Download files from GEO Sequence Read Archive (SRA) using list of accession numbers and extract to fastq/other depending on format.   

### CONFIG PARAMS
Edit these at the top of the Snakefile to specific file containing accession numbers and an output folder with dataset name and date (can move files after).

SRALIST = "SraAccList.txt"
DATASET = "dataset_20250212"

SRALIST should be in the format downloaded exactly from GEO/SRA, as shown below:
SRR8270313    
SRR8270314    
SRR8270315

## Pipeline
### FETCH_ACCESSION
Get .sra file from SRA archive using file containing a list of accession numbers in the format below. Uses NCBI docker container for sra-tools.

### SRA_TO_FASTQ
Converts .sra files from previous rule to extract paired-end fastq files to output individual files for read_1 and read_2. Uses NCBI docker container for sra-tools.

### NOTES
- NEED TO ADD OPTION FOR EXTRACTION DEPENDING ON EXPECTED OUTPUT!
- Issue with docker container requiring bash instead of sh but currently using a workaround which applies to all rules rather than only a specific rule. 
- Some datasets will not have paired-end reads so the READ parameter for read 1/2 has been removed in the alternate Snakefile to run these (not common).
- File structure of the outputs is not standardized so can get error saying 'job finished successfully but waiting for missing output file', for this would need to reformat Snakefile outputs to change `{dataset}/{accession}/{accession}` to `{dataset}/{accession}` depending on where files are output as necessary.
