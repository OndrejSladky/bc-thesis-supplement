#!/usr/bin/env Rscript

library(tidyverse)
library(ggsci)

h <- 30
w <- 30
u <- "cm"
mink <- 9
maxk <- 17


theme_set(theme_bw() +
              theme(
                  axis.text.x = element_text(
                      size = 10,
                      angle = 0,
                      hjust = 0.5,
                      vjust = 0.1

                  ),
                  panel.grid.major.x = element_blank()
              ))

scfill <- scale_fill_npg


# Longer format -----------------------------------------------------------

df0 <- read_tsv("all_data.tsv", na = "na")

df1 <- df0 %>%
    pivot_longer(c("S_xz_bytes",
                   "M_compr_bytes"),
                 names_to = "key",
                 values_to = "bytes") %>%
    mutate(key = str_replace(key, "_xz_bytes", "")) %>%
    mutate(mb = bytes / 1e6)

facet_labeller <-
    labeller(
        k = function(k) {
            paste0("k=", k)
        },
        genome = function(label_value) {
            case_when(
                label_value == "4" ~ "S.pneu. pan-gen.",
                label_value == "1" ~ "S.pneu. gen.",
                label_value == "5" ~ "E.coli pan-gen.",
                label_value == "6" ~ "SARS-CoV-2 pan-gen.",
                label_value == "2" ~ "S.cere. gen.",
                label_value == "3" ~ "Human gen."
            )
        }
    )



# Filter  -----------------------------------------------------------

df2 <- df1 %>%
    #filter(mink <= k & k <= maxk) %>%
    mutate(genome = str_replace(genome, "spneumo-pangenome", "spneumoniae-pangenome")) %>%
    mutate(genome = str_replace(genome, "spneumo_pangenome-616.k63", "spneumoniae-pangenome")) %>%
    mutate(genome = str_replace(genome, "escherichia_coli.k61", "escherichia_coli.k32")) %>%
    filter(k %% 2 == 1) %>%
    filter(9 <= k) %>%
    filter(k <= 23 | k == 31 | k == 61) %>%
    filter(k != 21) %>%
    filter(M_alg == "default") %>%
    #mutate(d = ifelse(is.na(d), 0, d)) %>%
    mutate (d = case_when(
                S_alg == "prophasm" ~ 1,
                S_alg == "eulertigs" ~ 2,
                S_alg == "greedytigs" ~ 3,
                S_alg == "matchtigs" ~ 4,
                S_alg == "local" ~ d + 5,
                S_alg == "global" ~ 11
                          )) %>%
    #mutate(d = ifelse(S_alg == "greedytigs", -1, ifelse(is.na(d), 7, d))) %>%
    filter(S_alg == "global" | S_alg == "local" | S_alg == "prophasm" | S_alg == "greedytigs" | S_alg == "matchtigs" | S_alg == "eulertigs") %>%
    filter(d != 0) %>%
    filter(S_alg != "streaming") %>%
    filter(M_compr_alg == "xz") %>%
    #filter(
    #    genome == "spneumoniae-pangenome" |
    #        genome == "spneumoniae" | 
    #        genome == "E. coli pangenome" #| genome == "sars-cov-2-pangenome"
    #) %>%
    filter(genome == "spneumoniae-pangenome" |
               genome == "spneumoniae" |
               genome == "escherichia_coli.k32" |
               genome == "sars-cov-2.590k.k63" |
               genome == "yeast" |
               genome == "human") %>%
    mutate(genome = str_replace(genome, "spneumoniae-pangenome", "4")) %>%
    mutate(genome = str_replace(genome, "spneumoniae", "1")) %>%
    mutate(genome = str_replace(genome, "escherichia_coli.k32", "5")) %>%
    mutate(genome = str_replace(genome, "sars-cov-2.590k.k63", "6")) %>%
    mutate(genome = str_replace(genome, "yeast", "2")) %>%
    mutate(genome = str_replace(genome, "human", "3")) 

df.ht <- df2 %>% filter(!grepl('AC', S_alg))




# Plot xz bits per k-mer -----------------------------------------------------------

# trick - copies of the same tick disappear <- using the same
# name can be used for tick removal
#   ggplot(df.ht) +
#       aes(x = d,
#           y = 8 * bytes / kmer_count,
#           fill = key) +
#       geom_bar(stat = "identity") +
#       #, scales = "free"
#       facet_grid(genome ~ k, labeller = facet_labeller, scales = "free") +
#       scfill(labels = c("mask", "superstring")) +
#       scale_x_discrete(name = "",
#                        limits = c("L1 ", " .", " . ", ". ", "5", " . ", "G")) +
#       scale_y_continuous(expand = c(0, 0),
#                          #name = "xz bits per distinct k-mers",
#                          name = "") +
#        theme(legend.title= element_blank())


#   ggsave(
#       "xz_bits_per_kmer_HT.pdf",
#       height = h,
#       width = w,
#       unit = u
#   )




#ggplot(df.ac) +
#    aes(x = d,
#        y = 8 * bytes / kmer_count,
#        fill = key) +
#    geom_bar(stat = "identity") +
#    #, scales = "free"
#    facet_grid(genome ~ k, labeller = facet_labeller) +
#    scfill() +
#    scale_x_discrete(name = "",
#                     limits = c("L1 ", " .", " . ", ". ", "5", " . ", "G")) +
#    scale_y_continuous(expand = c(0, 0),
#                       #name = "xz bits per distinct k-mers",
#                       name = "") +
#	   theme(legend.title= element_blank())
#
#
#ggsave(
#    "xz_bits_per_kmer_AC.pdf",
#    height = h,
#    width = w,
#    unit = u
#)







# Plot superstring chars per k-mer -----------------------------------------------------------


ggplot(df.ht %>% filter(key == "S")) +
    #filter(key == "S")) +
    aes(x = d,
        y = l / kmer_count,
        shape = S_alg) +
    scfill() +
    geom_point() +
    geom_line(aes(group = S_alg)) +
    facet_grid(genome ~ k, labeller = facet_labeller) +
    scale_x_discrete(name = "",
                     limits = c("P", "E", "M", "O", "O" ,"L1", " .", " . ", ". ", "5", "G")) +
    scale_y_continuous(
        #name = "characters per distinct k-mer",
        name = "",
        breaks = seq(1, 2.4, 0.2),
        lim = c(1.0, 2.45),
        expand = c(0, 0)
    ) +
    theme(plot.margin = margin(0, 0, 0, 0, "cm")) +
    guides(shape = "none")

ggsave(
    paste("chars_per_kmer_HT.pdf"),
    height = h,
    width = w,
    unit = u
)



#ggplot(df.ac %>% filter(key == "S")) +
#    aes(x = d,
#        y = l / kmer_count,
#        shape = algorithm) +
#    scfill() +
#    geom_point() +
#    geom_line(aes(group = algorithm)) +
#    facet_grid(genome ~ k, labeller = facet_labeller) +
#    scale_x_discrete(#name = "d",
#        name = "",
#        limits = c("L1 ", " .", " . ", ". ", "5", " . ", "G")) +
#    scale_y_continuous(
#        #name = "characters per distinct k-mer",
#        name = "",
#        breaks = seq(1, 2, 0.2),
#        lim = c(1.0, 2.05),
#        expand = c(0, 0)
#    ) +
#    theme(plot.margin = margin(0, 3.3, 0, 0, "cm")) +
#    guides(shape = "none")
#
#ggsave(
#    "chars_per_kmer_AC.pdf",
#    height = h,
#    width = w,
#    unit = u
#)
