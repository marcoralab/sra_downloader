import os
import glob

SRALIST = "SraAccList.txt"
DATASET = "dataset_20250212"

with open(SRALIST, "r") as srafile:
    ACCESSION = [x.strip() for x in srafile]

# snakemake --dag | dot -Tpdf > output/dag.pdf

shell.executable("/bin/sh")

localrules: main

rule main:
    input:
        expand("{dataset}/{accession}_{read}.fastq", dataset = DATASET, accession = ACCESSION, read=[1,2])


rule fetch_accession:
    output: temp("{dataset}/{accession}/{accession}.sra")
    params:
        output_folder = "{dataset}",
        max_limit = "40G"
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
        prefetch {wildcards.accession} --max-size {params.max_limit} -O {params.output_folder}

rule sra_to_fastq:
    input: "{dataset}/{accession}/{accession}.sra"
    output: expand("{{dataset}}/{{accession}}_{read}.fastq", read=[1,2])
    params:
        output_folder = "{dataset}"
    threads: 2
    resources:
        time_min = 300,
        mem_mb = 16000
    container: "docker://befh/sra-tools:3.0.0"
    shell:
        """
        fasterq-dump {input} -e 8 -O {params.output_folder}
        """

