import os
import glob

sralist = "/sc/arion/projects/load/users/patelt16/data/scripts/sra_download/SraAccList.txt"

with open(sralist, "r") as srafile:
    ACCESSION = [x.strip() for x in srafile]

# snakemake --dag | dot -Tpdf > output/dag.pdf

shell.executable("/bin/sh")

localrules: main

rule main:
    input:
        expand("output/{accession}_{read}.fastq", accession=ACCESSION, read=[1,2])


rule fetch_accession:
    output: temp("output/{accession}/{accession}.sra")
    threads: 4
    resources:
        time_min = 180,
        mem_mb = 16000
    container: "docker://ncbi/sra-tools:3.0.0"
    shell:
        """
        export http_proxy=http://172.28.7.1:3128
        export https_proxy=http://172.28.7.1:3128
        export all_proxy=http://172.28.7.1:3128
        export no_proxy=localhost,*.chimera.hpc.mssm.edu,172.28.0.0/16
        prefetch {wildcards.accession} --max-size 30G
        """

rule sra_to_fastq:
    input: "output/{accession}/{accession}.sra"
    output: expand("output/{{accession}}_{read}.fastq", read=[1,2])
    threads: 2
    resources:
        time_min = 180,
        mem_mb = 16000
    container: "docker://ncbi/sra-tools:3.0.0"
    shell:
        """
        fasterq-dump {input} -e 20
        """
