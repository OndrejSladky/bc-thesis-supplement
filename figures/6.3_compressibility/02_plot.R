#!/usr/bin/env Rscript

library(tidyverse)
library(ggsci)

h <- 8
w <- 18
u <- "cm"


theme_set(theme_bw() +
              theme(
                  axis.text.x = element_text(
                      size = 8,
                      angle = 0,
                      hjust = 0.8,
                      vjust = 0.2

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
        genome = label_value
    )



# Filter  -----------------------------------------------------------

df2 <- df1 %>%
    filter(08 <= k & k <= 18) %>%
    mutate(genome = str_replace(genome, "spneumo-pangenome", "spneumoniae-pangenome")) %>%
    #mutate(d = ifelse(is.na(d), 0, d)) %>%
    filter(S_alg != "streaming") %>%
    filter(!is.na(camel_DS) | S_alg == "greedytigs" | S_alg == "eulertigs") %>%
    filter((is.na(camel_DS) & M_alg == "default") | (!is.na(camel_DS) & M_alg == "runs")) %>%
    filter(is.na(d) | d == 5) %>%
    filter(
        genome == "spneumoniae-pangenome" |
            genome == "spneumoniae"
            #genome == "E. coli pangenome" #| genome == "sars-cov-2-pangenome"
    ) %>%
    filter(M_compr_alg == "xz") %>%
    mutate(genome = str_replace(genome, "spneumoniae-pangenome", "pan-genome")) %>%
    mutate(genome = str_replace(genome, "spneumoniae", "genome")) %>%
    mutate(S_alg = case_when(
                             S_alg == "local" ~ 3,
                             S_alg == "global" ~ 4,
                             S_alg == "greedytigs" ~ 2,
                             S_alg == "eulertigs" ~ 1
                             )) %>%
    filter(!is.na(S_alg))

df.ht <- df2 %>% filter(!grepl('AC', S_alg))
df.ac <- df2 %>% filter(!grepl('HT', S_alg))




# Plot xz bits per k-mer -----------------------------------------------------------

# trick - copies of the same tick disappear <- using the same
# name can be used for tick removal
ggplot(df.ht) +
    aes(x = S_alg,
        y = 8 * bytes / kmer_count,
        fill = key) +
    geom_bar(stat = "identity") +
    #, scales = "free"
    facet_grid(genome ~ k, labeller = facet_labeller, scales = "free") +
    #scfill(labels = c("mask", "superstring")) +
    scfill(labels = "") +
    scale_x_discrete(name = "", limits = c(" E ", " M ", " L5", "  G")) +
    scale_y_continuous(expand = c(0, 0),
                       #name = "xz bits per distinct k-mers",
                       name = "") +
	   theme(
	        legend.title= element_blank(),
	        legend.position = "none",
	        plot.margin = unit(c(0.1, 0.1, -0.3, -0.4), "cm"),
	        axis.text.x = element_text(hjust = 0.5, margin = margin(r = 0.5, unit = "cm")))


ggsave(
    "xz_bits_per_kmer_HT.pdf",
    height = h,
    width = w,
    unit = u
)




#   ggplot(df.ac) +
#       aes(x = d,
#           y = 8 * bytes / kmer_count,
#           fill = key) +
#       geom_bar(stat = "identity") +
#       #, scales = "free"
#       facet_grid(genome ~ k, labeller = facet_labeller) +
#       scfill() +
#       scale_x_discrete(name = "",
#                        limits = c("L1 ", " .", " . ", ". ", "5", " . ", "G")) +
#       scale_y_continuous(expand = c(0, 0),
#                          #name = "xz bits per distinct k-mers",
#                          name = "") +
#        theme(legend.title= element_blank())


#   ggsave(
#       "xz_bits_per_kmer_AC.pdf",
#       height = h,
#       width = w,
#       unit = u
#   )







