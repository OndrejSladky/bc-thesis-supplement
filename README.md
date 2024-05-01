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

## Figures + supplementary plots

## Contact
