import os
import glob

SRALIST = "input/SraAccList.txt"
DATASET = "test_20250212"

with open(SRALIST, "r") as srafile:
    ACCESSION = [x.strip() for x in srafile]

# snakemake --dag | dot -Tpdf > output/dag.pdf

shell.executable("/bin/sh")

localrules: main

rule main:
    input:
        expand("{dataset}/{accession}_{read}.fastq", dataset = DATASET, accession = ACCESSION, read=[1,2])


rule fetch_accession:
    output: temp("{accession}/{accession}.sra")
    threads: 4
    resources:
        time_min = 300,
        mem_mb = 16000
    container: "docker://befh/sra-tools:3.0.0"
    shell:
        """
        export http_proxy=http://172.28.7.1:3128
        export https_proxy=http://172.28.7.1:3128
        export all_proxy=http://172.28.7.1:3128
        export no_proxy=localhost,*.chimera.hpc.mssm.edu,172.28.0.0/16
        prefetch {wildcards.accession} --max-size 30G
        """

rule sra_to_fastq:
    input: "{accession}/{accession}.sra"
    output: expand("{{dataset}}/{{accession}}_{read}.fastq", read=[1,2])
    threads: 2
    resources:
        time_min = 300,
        mem_mb = 16000
    container: "docker://befh/sra-tools:3.0.0"
    shell:
        """
        fasterq-dump {input} -e 20
        """

rule move_files:
    input: "{accession}_{read}.fastq"
    output: "{dataset}/{accession}_{read}.fastq"
    threads: 1
    resources:
        time_min = 30,
        mem_mb = 2000
    shell:
        """
        mv {input} {output}
        """
