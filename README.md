# Supplementary repository of Ondřej Sladký's bachelor's thesis


* [Introduction](#introduction)
  * [Citation](#citation)
* [Methods](#methods)
  * [Masked superstring computation - KmerCamel🐫](#masked-superstrings-computation---kmercamel)
  * [Indexing masked superstrings - FMSI](#indexing-masked-superstrings---fmsi)
* [Experimental evaluation](#experimental-evaluation)
  * [Benchmark datasets](#benchmark-datasets)
  * [Reproducing experimental results](#reproducing-experimental-results)
* [Figures + supplementary plots](#figures--supplementary-plots)
* [Contact](#contact)

## Introduction

This repository contains links to all the supplementary material for my bachelor's thesis, i.e., experimental pipelines and results and individual plots.

The thesis is based on two arcitles, consider also visiting their respective supplementary repositories.

- Paper I: [Masked superstrings as a unified framework for textual *k*-mer set representations](https://doi.org/10.1101/2023.02.01.526717) - [supplementary repository](https://github.com/karel-brinda/masked-superstrings-supplement)
- Paper II: [Function-Assigned Masked Superstrings as a Versatile and Compact Data Type for *k*-Mer Sets](https://doi.org/10.1101/2024.03.06.583483) - [supplementary repository](https://github.com/OndrejSladky/f-masked-superstrings-supplement)

### Citation

Coming soon!

## Methods

### Masked superstrings computation - KmerCamel🐫

Superstrings were computed using the [KmerCamel🐫](https://github.com/OndrejSladky/kmercamel) program, which local and global greedy heuristics for masked superstring computation using hash tables and also experimental implementations using Aho-Corasick automaton.

By default, the superstrings computed by KmerCamel🐫 come with default masks; these contain the minimal possible number of 1's (i.e., every k-mer masked on only once) and the patterns of 1's and 0's reflect the orders in which individual k-mers were added to the superstrings.
Additionally, these masks can be optimized by KmerCamel🐫 to either contain the maximum/minimum number of ones or the minimum number of runs of ones.

Importantly, changes in the underlying data structures (hash-table vs. AC automaton), as well as changing machines or compilers, results/may result in different superstrings and their mask, and the specific choices can affect mask compressibility. For instance, hash-table-based approaches tend to produce more regular masks that are better compressible (e.g., for nearly complete de Bruijn graphs).

### Indexing masked superstrings - FMSI

Indexing, membership queries, and set operations on k-mer sets represented via f-masked superstrings was performed and benchmarked on [FMSI](https://github.com/OndrejSladky/fmsi), which experimentaly implements membership queries as well as several basic operations on indexed masked superstrings such as normalization, export and merging, which can be used to perform set operations.

## Experimental evaluation

### Benchmark datasets
* *S. pneumoniae* genome (ATCC 700669, NC_011900.1, [fna
  online](https://www.ncbi.nlm.nih.gov/nuccore/NC_011900.1?report=fasta&log$=seqview&format=text))
  - The resulting file: [data/spneumoniae.fa.xz](data/spneumoniae.fa.xz)
* *S. pneumoniae* pan-genome - 616 genomes, as provided in [RASE DB *S.
  pneumoniae*](https://github.com/c2-d2/rase-db-spneumoniae-sparc/)
  - *k*-mers were collected and stored in the form of simplitigs (ProphAsm
    v0.1.1, k=63)
  - The resulting file:
    [data/spneumo_pangenome-616.simplitigs.k63.fa.xz](data/spneumo_pangenome-616.simplitigs.k63.fa.xz)
* *S. cerevisiae* genome (S288C, [fna.gz
  online](ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz))
  - [data/yeast.fa.xz](data/yeast.fa.xz)
* *E. coli* pan-genome, obtained as the union of the genomes from the [661k collection](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3001421), downloaded from [Phylogenetically compressed 661k collection](https://zenodo.org/records/4602622)
  - *k*-mers were collected and stored in the form of unitigs with $k = 32$ and $k=61$ (BCALM 2, version v2.2.3, git commit e57cc46)
  - not provided in this repository due to file size (ask if you wish to get these datasets)
* *SARS-CoV-2* pan-genome - downloaded from [GISAID](https://gisaid.org/)
  (access upon registration) 
  - 590k genomes for experiments on compressibility
    - *k*-mers were collected using JellyFish 2 (v2.2.10, k=63) and
        stored in the form of simplitigs (ProphAsm v0.1.1, k=63)
    - The resulting file:
        [data/sars-cov-2_pangenome_k32.fa.xz](data/sars-cov-2.590k.simplitigs.k63.fa.xz)
  - 14.7M genomes for experiments on indexing
    - *k*-mers were collected using JellyFish 2 (v2.2.10, k=32) and
        stored in the form of simplitigs (ProphAsm v0.1.1, k=32)
    - The resulting file:
        [data/sars-cov-2_pangenome_k32.fa.xz](data/sars-cov-2.14M.simplitigs.k32.fa.xz)
* Human genome (`GRCh38.p14`, genome length 3.1 Gbp) 
  - Downloaded from [https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/)
  - not provided in this repository due to file size
* *C. elegans* (`NC_003279.8`) - downloaded from [NCBI](https://www.ncbi.nlm.nih.gov)
  - [data/C.elegans.fna.xz](data/C.elegans.fna.xz)
* *C. briggsae* (`NC_013489.2`) - downloaded from [NCBI](https://www.ncbi.nlm.nih.gov)
  - [data/C.briggsae.fna.xz](data/C.briggsae.fna.xz)

For generating negative membership queries to these datasets, we used a 2MB prefix of the FASTA file for chromosome 1 of *H. sapiens* genome (`GRCh38.p14 Primary Assembly`, `NC_000001.11`), downloaded from [NCBI](https://www.ncbi.nlm.nih.gov); see  [data/GRCh38.p14.chromosome1.prefix2M.fasta.xz](data/GRCh38.p14.chromosome1.prefix2M.fasta.xz)

### Reproducing experimental results

To download the used tools, run the following:

```bash
git submodule update --init

```

Besides standard Linux programs the experimental pipeline requires [Snakemake](https://snakemake.readthedocs.io/en/stable/) and [seqtk](https://github.com/lh3/seqtk)).

All the experimental pipelines are located in the `experiments` directory.
There are several subdirectories with individual experimental pipelines. The folders prefixed with `1*` correspond to experiments regarding storing masked superstrings (Chapters 2 and 3 of the thesis) and these prefixed with `2*` correspond to experiments on indexing (Chapters 4 and 5).
The individual pipelines are the following:
- `11_compute_tigs`/`14_subsampled_compute_tigs` - computation of unitigs (required by matchtigs), simplitigs, eulertigs and greedy/optimal matchtigs; for not subsampled / subsampled data
- `12_optimize_tigs`/`15_subsampled_optimize_tigs` - mask optimization of previously computed *tigs and compression with different algorithms; for not subsampled / subsampled data
- `13_compute_camel`/`16_subsampled_compute_camel` - computation and optimization of masked superstrings with KmerCamel🐫 and compression with different algorithms; for not subsampled / subsampled data
- `07_collect_results` - aggregation of data from previous pipelines
- `21_build_and_query_memtime` - contains additional sub-pipelines for build and query time vs. memory experiments on indexes
- `22` - experiment on set operations using FMSI

Each pipeline can be run by command `make` in the corresponding directory. For some `make test` can be used to check if everything is set up correctly. Pipelines should be run from smaller numbers to larger.



## Figures + supplementary plots

## Contact

Ondřej Sladký (ondra.sladky@gmail.com)
