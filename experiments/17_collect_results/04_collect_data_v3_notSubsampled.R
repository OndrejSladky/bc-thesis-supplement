#!/usr/bin/env Rscript

library(tidyverse)


# merge masked superstring stats ---------------------------------------------------------------

df.camel.ms <- read_tsv("../25_kmer_camel_comparison_v5_all/99_results/masked_superstrings_properties.kamenik.tsv")
df.tigs.ms <- read_tsv("../24_tigs_stats_v3_all/99_results/masked_superstrings_properties.kamenik.tsv")

df.ms0 <- df.camel.ms %>%
    bind_rows(df.tigs.ms) %>%
    mutate(genome = str_replace(genome, "spneumoniae-pangenome", "spneumo-pangenome"))
    #mutate(genome = str_replace(genome, "escherichia_coli.k32", "E.coli pangenome"))


# camel stats ---------------------------------------------------------------

df.ms <- df.ms0 %>%
    mutate(pref0 = str_replace(pref, '(.+)\\..+', '\\1')) %>%
    mutate(
        algorithm = case_when(
            grepl(regex("^local(|AC)$"), S_alg) ~ "loc-greedy",
            grepl(regex("^global(|AC)$"), S_alg) ~ "glob-greedy",
            grepl("streaming", S_alg) ~ "streaming",
            TRUE ~ S_alg
        )
    ) %>%
    mutate(`camel_DS` = case_when(grepl(
        regex("^(global|local)AC$"), S_alg
    ) ~ "AC",
    grepl(
        regex("^(global|local)$"), S_alg
    ) ~ "HT",
    TRUE ~ "na")) %>%
    relocate("genome", "k", "S_alg", "algorithm", "camel_DS")

df.memCamel0 <- read_tsv("../25_kmer_camel_comparison_v5_all/99_results/camel_memtime.kamenik.tsv")

df.memCamel <- df.memCamel0 %>%
    mutate(genome = str_replace(genome, "spneumoniae-pangenome", "spneumo-pangenome")) %>%
    transmute(
        #prefS = pref,
        genome = genome,
        S_alg = S_alg,
        k = k,
        d = d,
        S_mem_bytes = `max_RAM(kb)` * 1000,
        S_real_s = `real(s)`,
        S_usr_s = `user(s)`,
        S_sys_s = `sys(s)`,
    )

df.memTigs0 <- read_tsv("../09_spneumo_matchtigs_eurlertigs/tigs_computation_memtime.kamenac.tsv")
df.memTigs1 <- read_tsv("../09_spneumo_matchtigs_eurlertigs/tigs_computation_memtime.kamenik.tsv")

df.memTigs <- df.memTigs0 %>%
    bind_rows(df.memTigs1) %>%
    transmute(
        #prefS = pref, # not provided
        genome = genome,
        S_alg = S_alg,
        k = k,
        d = "na",
        S_mem_bytes = `max_RAM(kb)` * 1000,
        S_real_s = `real(s)`,
        S_usr_s = `user(s)`,
        S_sys_s = `sys(s)`,
    )

df.mem <- df.memCamel %>%
    bind_rows(df.memTigs)

df.memMaskCamel0 <- read_tsv("../25_kmer_camel_comparison_v5_all/99_results/maskopt_memtime.kamenik.tsv")

df.memMaskCamel <- df.memMaskCamel0 %>%
    mutate(genome = str_replace(genome, "spneumoniae-pangenome", "spneumo-pangenome")) %>%
    transmute(
        #prefM = pref,
        genome = genome,
        S_alg = S_alg,
        k = k,
        d = d,
        M_alg = M_alg,
        M_mem_bytes = `max_RAM(kb)` * 1000,
        M_real_s = `real(s)`,
        M_usr_s = `user(s)`,
        M_sys_s = `sys(s)`,
    )

df.memMaskTigs0 <- read_tsv("../24_tigs_stats_v3_all/99_results/maskopt_memtime.kamenik.tsv")

df.memMaskTigs <- df.memMaskTigs0 %>%
    filter(`max_RAM(kb)` != "na") %>%
    transmute(
        prefM = pref,
        genome = genome,
        S_alg = S_alg,
        k = k,
        d = d,
        M_alg = M_alg,
        M_mem_bytes = as.double(`max_RAM(kb)`) * 1000,
        M_real_s = as.double(`real(s)`),
        M_usr_s = as.double(`user(s)`),
        M_sys_s = as.double(`sys(s)`),
    )
    
df.memMask <- df.memMaskCamel %>%
    bind_rows(df.memMaskTigs)

options(tibble.width = Inf, width = 300) # for printing
#show(df.ms)
#show(df.mem)

df <- df.ms %>%
    full_join(df.mem) %>%
    full_join(df.memMask) %>%
    relocate(pref0, pref, .after = last_col()) %>%
    arrange(genome, k, algorithm, d, M_alg)

df %>%
    write_tsv("all_data_notSubsampled_v3.tsv",  na = "na")
