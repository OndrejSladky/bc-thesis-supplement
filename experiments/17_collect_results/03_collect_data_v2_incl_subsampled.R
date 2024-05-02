#!/usr/bin/env Rscript

library(tidyverse)


# merge masked superstring stats ---------------------------------------------------------------

df.camel.ms <- read_tsv("input_v2/21-camel-masked_superstrings_properties.kamenik.tsv")
df.camelSubsampled.ms <- read_tsv("input_v2/18-camel-subsampled-masked_superstrings_properties.kamenik.tsv")
df.tigs.ms <- read_tsv("input_v2/20-tigs-masked_superstrings_properties.kamenik.tsv")
df.camel.large.ms <- read_tsv("input_v2/23-camel-masked_superstrings_properties-large_pangenomes.kamenik.tsv")
df.tigs.large.ms <- read_tsv("input_v2/24-masked_superstrings_properties.kamenik.tsv")

df.ms0 <- df.camel.ms %>%
    bind_rows(df.camel.large.ms) %>%
    bind_rows(df.tigs.large.ms) %>%
    mutate(rate = 1.0) %>%
    bind_rows(df.tigs.ms) %>%
    bind_rows(df.camelSubsampled.ms) %>%
    mutate(genome = str_replace(genome, "spneumo-pangenome", "spneumoniae-pangenome")) %>%
    mutate(genome = str_replace(genome, "spneumo-pangenome_subsampled", "spneumoniae-pangenome_subsampled")) %>%
    mutate(genome = str_replace(genome, "escherichia_coli.k32", "E. coli pangenome"))


# camel stats ---------------------------------------------------------------

df.ms <- df.ms0 %>%
    mutate(pref0 = str_replace(pref, '(.+)\\..+', '\\1')) %>%
    mutate(
        algorithm = case_when(
            grepl(regex("^pseudosimplitigs(|AC)$"), S_alg) ~ "loc-greedy",
            grepl(regex("^greedy(|AC)$"), S_alg) ~ "glob-greedy",
            grepl("streaming", S_alg) ~ "streaming",
            TRUE ~ S_alg
        )
    ) %>%
    mutate(`camel_DS` = case_when(grepl(
        regex("^(greedy|pseudosimplitigs)AC$"), S_alg
    ) ~ "AC",
    grepl(
        regex("^(greedy|pseudosimplitigs)$"), S_alg
    ) ~ "HT",
    TRUE ~ "na")) %>%
    relocate("genome", "rate", "k", "S_alg", "algorithm", "camel_DS")

df.memCamel <- read_tsv("input_v2/21-camel_memtime.kamenik.tsv") %>%
    mutate(rate = 1.0)
df.memCamelSubsampled <- read_tsv("input_v2/18-camel-subsampled-camel_memtime.kamenik.tsv")
df.memCamel.large <- read_tsv("input_v2/23-camel_memtime.kamenik.tsv") %>%
    mutate(rate = 1.0)
df.mem <- df.memCamel %>%
    bind_rows(df.memCamelSubsampled) %>%
    bind_rows(df.memCamel.large) %>%
    transmute(
        pref0 = pref,
        camel_mem_bytes = `max_RAM(kb)` * 1000,
        camel_real_s = `real(s)`,
        camel_usr_s = `user(s)`,
        camel_sys_s = `sys(s)`,
    )


df <- df.ms %>%
    full_join(df.mem) %>%
    relocate(pref0, pref, .after = last_col()) %>%
    arrange(genome, rate, k, algorithm)

df %>%
    filter(rate == 1.0) %>%
    subset(select = -c(rate)) %>%
    write_tsv("all_data_notSubsampled_v2.tsv",  na = "na")

df %>%
    filter(rate < 1.0) %>%
    write_tsv("all_data_subsampled_v2.tsv",  na = "na")
