## SRA DOWNLOADER
Date: 2022-05-16    
Author: Tulsi Patel   

**PURPOSE:**
Download files from Sequence Read Archive (SRA) using list of accession numbers and extract to fastq/other depending on format.   

## RULES
### FETCH_ACCESSION
Get .sra file from SRA archive using file containing a list of accession numbers in the format below. Uses NCBI docker container for sra-tools.

SRR8270313    
SRR8270314    
SRR8270315    

### SRA_TO_FASTQ
Converts .sra files from previous rule to extract paired-end fastq files to output individual files for read_1 and read_2. Uses NCBI docker container for sra-tools.

### NOTES
- NEED TO ADD OPTION FOR EXTRACTION DEPENDING ON EXPECTED OUTPUT!
- Issue with docker container requiring bash instead of sh but currently using a workaround which applies to all rules rather than only a specific rule. 
