# Supplementary repository of Ondřej Sladký's bachelor's thesis

This repository contains links to all the supplementary material for my bachelor's thesis, i.e., experimental pipelines and results and individual plots.

The thesis is based on two arcitles, consider also visiting their respective supplementary repositories.

- [Masked superstrings as a unified framework for textual *k*-mer set representations](https://doi.org/10.1101/2023.02.01.526717) - [supplementary repository](https://github.com/karel-brinda/masked-superstrings-supplement)
- [Function-Assigned Masked Superstrings as a Versatile and Compact Data Type for *k*-Mer Sets](https://doi.org/10.1101/2024.03.06.583483) - [supplementary repository](https://github.com/OndrejSladky/f-masked-superstrings-supplement)

## Citation

Coming soon!

## Methods

### Masked superstrings computation - KmerCamel🐫

Superstrings were computed using the [KmerCamel🐫](https://github.com/OndrejSladky/kmercamel) program, which local and global greedy heuristics for masked superstring computation using hash tables and also experimental implementations using Aho-Corasick automaton.

By default, the superstrings computed by KmerCamel🐫 come with default masks; these contain the minimal possible number of 1's (i.e., every k-mer masked on only once) and the patterns of 1's and 0's reflect the orders in which individual k-mers were added to the superstrings.
Additionally, these masks can be optimized by KmerCamel🐫 to either contain the maximum/minimum number of ones or the minimum number of runs of ones.

Importantly, changes in the underlying data structures (hash-table vs. AC automaton), as well as changing machines or compilers, results/may result in different superstrings and their mask, and the specific choices can affect mask compressibility. For instance, hash-table-based approaches tend to produce more regular masks that are better compressible (e.g., for nearly complete de Bruijn graphs).

### Indexing masked superstrings with FMSI

Indexing, membership queries, and set operations on k-mer sets represented via f-masked superstrings was performed and benchmarked on [FMSI](https://github.com/OndrejSladky/fmsi), which experimentaly implements membership queries as well as several basic operations on indexed masked superstrings such as normalization, export and merging, which can be used to perform set operations.

## Experimental evaluation

### Benchmark datasets
* *S. pneumoniae* genome (ATCC 700669, NC_011900.1, [fna
  online](https://www.ncbi.nlm.nih.gov/nuccore/NC_011900.1?report=fasta&log$=seqview&format=text))
  - The resulting file: [data/spneumoniae.fa.xz](data/spneumoniae.fa.xz)
* *S. pneumoniae* pan-genome - 616 genomes, as provided in [RASE DB *S.
  pneumoniae*](https://github.com/c2-d2/rase-db-spneumoniae-sparc/)
  - *k*-mers were collected and stored in the form of simplitigs (ProphAsm
    v0.1.1, k=32, NS: 158,567, CL: 14,710,895 bp, #kmers: 9,795,318 32-mers)
  - The resulting file:
    [data/spneumo_pangenome_k32.fa.xz](data/spneumo_pangenome_k32.fa.xz)
* *S. cerevisiae* genome (S288C, [fna.gz
  online](ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz))
  - [data/yeast.fa.xz](data/yeast.fa.xz)
* *E. coli* pan-genome, obtained as the union of the genomes from the [661k collection](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3001421), downloaded from [Phylogenetically compressed 661k collection](https://zenodo.org/records/4602622)
  - *k*-mers were collected and stored in the form of unitigs with $k = 32$ (BCALM 2, version v2.2.3, git commit e57cc46)
  - not provided in this repository due to file size (ask [@PavelVesely](https://github.com/PavelVesely) if you wish to get this dataset)
    [data/spneumo_pangenome_k32.fa.xz](data/spneumo_pangenome_k32.fa.xz)
* *SARS-CoV-2* pan-genome - downloaded from [GISAID](https://gisaid.org/)
  (access upon registration) on Jan 25, 2023 (GISAID version 2023_01_23,
  14,682,066 genomes, 430 Gbp)
  - *k*-mers were collected using JellyFish 2 (v2.2.10, 11,701,570 32-mers) and
    stored in the form of simplitigs (ProphAsm v0.1.1, k=32, NS: 345,866, CL:
    22,423,416 bp, #kmers: 11,701,570 32-mers)
  - The resulting file:
    [data/sars-cov-2_pangenome_k32.fa.xz](data/sars-cov-2_pangenome_k32.fa.xz)
* *C. elegans* (`NC_003279.8`) - downloaded from [NCBI](https://www.ncbi.nlm.nih.gov)
  - [data/C.elegans.fna.xz](data/C.elegans.fna.xz)
* *C. briggsae* (`NC_013489.2`) - downloaded from [NCBI](https://www.ncbi.nlm.nih.gov)
  - [data/C.briggsae.fna.xz](data/C.briggsae.fna.xz)

For generating negative membership queries to these datasets, we used a 2MB prefix of the FASTA file for chromosome 1 of *H. sapiens* genome (`GRCh38.p14 Primary Assembly`, `NC_000001.11`), downloaded from [NCBI](https://www.ncbi.nlm.nih.gov); see  [data/GRCh38.p14.chromosome1.prefix2M.fasta.xz](data/GRCh38.p14.chromosome1.prefix2M.fasta.xz)


## Figures + supplementary plots

## Contact

Ondřej Sladký (ondra.sladky@gmail.com)
