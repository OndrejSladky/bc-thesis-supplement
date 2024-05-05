#!/usr/bin/env Rscript

library(tidyverse)
library(ggsci)

h <- 12
w <- 16
u <- "cm"

set.seed(42)

theme_set(theme_bw() +
              theme(
                  axis.text.x = element_text(
                      size = 8,
                      angle = 0,
                      hjust = 0.5,
                      vjust = 0.1

                  ),
                  panel.grid.major.x = element_blank()
              ))

scfill <- scale_fill_npg


# Longer format -----------------------------------------------------------

df0 <- read_tsv("all_data.tsv", na = "na")

facet_labeller <-
    labeller(
        k = function(k) {
            paste0("k=", k)
        },
        d = function(label_value) {
            case_when(
                      label_value == -3 ~ "P",
                      label_value == -2 ~ "E",
                      label_value == -1 ~ "M",
                      label_value == 0 ~ "O",
                      label_value == 6 ~ "G",
                      TRUE ~ paste0("L", label_value)
            )
        },
        M_compr_alg = function(M_compr_alg) {
            case_when(
                      M_compr_alg == 0 ~ "RRR (+)",
                      M_compr_alg == 1 ~ "EF (+)",
                      M_compr_alg == 2 ~ "XZ",
                      M_compr_alg == 3 ~ "BZ2"
            )
        }
    )



# Filter  -----------------------------------------------------------

df <- df0 %>%
    #filter( S_alg == "greedytigs" | S_alg == "eulertigs") %>%
    #filter(!is.na(camel_DS) | S_alg == "prophasm" | S_alg == "greedytigs" | S_alg == "eulertigs" | S_alg == "matchtigs") %>%
    mutate(genome = str_replace(genome, "spneumo-pangenome", "spneumoniae-pangenome")) %>%
    filter(!is.na(camel_DS) | S_alg == "greedytigs" | S_alg == "eulertigs") %>%
    filter(M_alg != "runsapprox") %>%
    filter(is.na(d) | d == 5) %>%

    #filter(M_alg == "default") %>%
    #mutate(d = ifelse(is.na(d), 0, d)) %>%
    mutate(d = case_when(
                         S_alg == "prophasm" ~ -3,
                         S_alg == "eulertigs" ~ -2,
                         S_alg == "greedytigs" ~ -1,
                         S_alg == "matchtigs" ~ 0,
                         S_alg == "local" ~ d,
                         S_alg == "global" ~ 6
                         )) %>%
    mutate(M_compr_alg = case_when(
                         M_compr_alg == "rrr" ~ 0,
                         M_compr_alg == "EliasFano" ~ 1,
                         M_compr_alg == "xz" ~ 2,
                         M_compr_alg == "bzip" ~ 3
                         )) %>%
    mutate(
        M_alg = case_when(
            M_alg == "default" ~ "D",
            M_alg == "ones" ~ "O",
            M_alg == "zeros" ~ "Z",
            M_alg == "runs" ~ "R"
            #M_alg == "runsapprox" ~ "A"
        )
    ) %>%
    filter(S_alg != "streaming") %>%
    mutate(desc = paste0(genome, "-", d))

#df.ht <- df %>% filter(camel_DS == "HT")
#df.ac <- df %>% filter(camel_DS == "AC")



# Plot xz bits per k-mer -----------------------------------------------------------


#df %>% filter(camel_DS == "HT") %>% filter(genome == "spneumoniae-pangenome")

for (g in c("spneumoniae",
            "spneumoniae-pangenome",
            "escherichia_coli.k32"
            #"human"
            #"minikraken4GB",
            #"minikraken8GB"
            )) {
    #for (compr in c("xz",
    #        "bzip",
    #        "rrr",
    #        "EliasFano"
    #        )) {
    for (D in c("HT")) { #"AC"
        #
        # Mxz_bits_per_kmer
        #
        dff <- df %>%
            filter(k == 13 | k == 15) %>%
            filter(camel_DS == D | is.na(camel_DS)) %>%
            filter(genome == g) %>%
            #filter(M_compr_alg == compr) %>%
            mutate(bits_per_kmer = 8 * M_compr_bytes / l)
            
        best_result <- dff %>% 
            group_by(d, k) %>%
            slice(which.min(bits_per_kmer))
        
        print(paste(g, D))
        ggplot(dff) +
            aes(x = M_alg,
                y = bits_per_kmer,
                fill = M_alg) +
            geom_bar(stat = "identity") +
            geom_text(data = best_result, aes(label = "*", y = bits_per_kmer), vjust = 0.3, size = 5) +
            scale_x_discrete(name = "") +
            scale_y_continuous(
                name = "",
                breaks = seq(0, 2, 0.5),
                lim = c(0, 1),
                expand = c(0, NA)
            ) +
            facet_grid(d ~ k + M_compr_alg,
                       #, scales = "free") +
                       labeller = facet_labeller) +
            scfill() + 
            theme(legend.title= element_blank(), panel.spacing.y = unit(0.4444, "cm"))

        ggsave(
            paste("M_compr_bits_per_char", g, D, "pdf", sep = "."),
            height = h,
            width = w,
            unit = u
        )

        #
        # M_runs
        #

        #print(paste(g, D, 2))
        #ggplot(dff %>%
        #    filter(camel_DS == D | is.na(camel_DS)) %>%
        #           filter(genome == g)) +
        #    aes(x = M_alg,
        #        y = r / kmer_count,
        #        fill = M_alg) +
        #    geom_bar(stat = "identity") +
        #    scale_x_discrete(name = "") +
        #    scale_y_continuous(
        #        name = "",
        #        breaks = seq(0, 2, 0.04),
        #        lim = c(0, NA),
        #        expand = c(0, NA)
        #    ) +
        #    facet_grid(d ~ k,
        #               #, scales = "free") +
        #               labeller = facet_labeller) +
        #    scfill()

        #ggsave(
        #    paste("M_runs_per_kmer", g , D, "pdf", sep = "."),
        #    height = h,
        #    width = w,
        #    unit = u
        #)

        #}
    }
}
