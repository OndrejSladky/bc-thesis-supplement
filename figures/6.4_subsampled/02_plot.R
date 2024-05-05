#!/usr/bin/env Rscript

library(tidyverse)
library(ggsci)

h <- 8
w <- 25
u <- "cm"


theme_set(theme_bw() +
              theme(
                  axis.text.x = element_text(
                      size = 8,
                      angle = 0,
                      hjust = 0.5,
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
        } ,
        S_alg = function(S_alg) {
            case_when(
                S_alg == "2" ~ "L5",
                S_alg == "3" ~ "G",
                S_alg == "1" ~ "M",
                S_alg == "0" ~ "E"
            )
        }
        # rate = function(label_value) {
        #     paste0("rate=", label_value)
        # }
    )



# Filter  -----------------------------------------------------------

df2 <- df1 %>%
    filter(genome == "spneumo_pangenome_k32") %>%
    mutate(genome = "subsampled S. pneumoniae pangenome") %>%
    filter(11 <= k & k <= 31 & k != 13 & k != 17 & k != 21) %>%
    filter(M_compr_alg == "xz") %>%
    filter(M_alg == "default") %>%
    #mutate(d = ifelse(is.na(d), 0, d)) %>%
    filter(S_alg != "streaming") %>%
    filter(!is.na(camel_DS) | S_alg == "greedytigs" | S_alg == "eulertigs") %>%
    filter(is.na(d) | d == 5) %>%
    mutate(S_alg = case_when(
                             S_alg == "local" ~ "2",
                             S_alg == "global" ~ "3",
                             S_alg == "greedytigs" ~ "1",
                             S_alg == "eulertigs" ~ "0"
                             )) %>%
    # mutate(alg = case_when(
    #     algorithm == "loc-greedy" ~ "L5",
    #     algorithm == "glob-greedy" ~ G,
    #     algorithm == "greedytigs" ~ M,
    #     algorithm == "eulertigs" ~ E
    # )) %>%
    #filter(rate == 0.1 | rate == 0.3 | rate == 0.5 | rate == 0.7 | rate == 0.9) %>%
    filter(!is.na(S_alg))%>%
    filter(rate > 1e-4) # PV: note: for higher rates, the additive cost of xz pops up (AFAIK)

df.ht <- df2 %>% filter(!grepl('AC', S_alg))
df.ac <- df2 %>% filter(!grepl('HT', S_alg))




# Plot xz bits per k-mer -----------------------------------------------------------

# trick - copies of the same tick disappear <- using the same
# name can be used for tick removal
# ggplot(df.ht) +
#     aes(x = S_alg,
#         y = 8 * bytes / kmer_count,
#         fill = key) +
#     geom_bar(stat = "identity") +
#     #, scales = "free"
#     facet_grid(k ~ rate, labeller = facet_labeller, scales = "free") +
#     scfill(labels = c("mask", "superstring")) +
#     scale_x_discrete(name = "", limits = c("E", "M", "L", "G")) +
#     scale_y_continuous(expand = c(0, 0),
#                        #name = "xz bits per distinct k-mers",
#                        name = "") +
# 	   theme(legend.title= element_blank())


# LINEAR SCALE ON X AXIS

ggplot(df.ht) +
    aes(x = rate,
        y = (8 * enc1_compr_bytes / kmer_count),
        shape=S_alg, color=S_alg) +
    #geom_bar(stat = "identity") +
    geom_point() + geom_line() +
    #, scales = "free"
    facet_grid(genome ~ k, labeller = facet_labeller, scales = "free") +
    #scfill(labels = c("mask", "superstring")) +
    scale_x_continuous(name = "subsampling rate", expand = c(0,0)) +
    scale_color_discrete(labels=c("E", "M", "L5", "G")) + 
    scale_shape_discrete(labels=c("E", "M", "L5", "G")) + 
    scale_y_continuous(expand = c(0, 0),
                       #name = "xz bits per distinct k-mers",
                       name = "") +
	   theme(legend.title= element_blank(),
	        plot.margin = unit(c(0.1, 0.1, 0.2, -0.4), "cm"))


# ggplot(df.ht,
#        aes(x=rate, y=(8 * enc1_xz_bytes / kmer_count), shape=algorithm, color=algorithm))+
#         geom_point() + geom_line() +
#         facet_grid(rows="k",  labeller = facet_labeller, scales = "free") + #genome ~ algorithm +
#         scale_y_continuous(expand = c(0, 0),
#                            #name = "xz bits per distinct k-mers",
#                            name = "") +
#         #guides(color = guide_legend(order = S_alg)) +
#         ylim(c(0, NA))

ggsave(
    "xz_bits_per_kmer_HT.pdf",
    height = h,
    width = w,
    unit = u
)

# LOG SCALE ON X AXIS

ggplot(df.ht) +
    aes(x = rate,
        y = (8 * enc1_compr_bytes / kmer_count),
        shape=S_alg, color=S_alg) +
    #geom_bar(stat = "identity") +
    geom_point() + geom_line() +
    #, scales = "free"
    facet_grid(genome ~ k, labeller = facet_labeller, scales = "free") +
    #scfill(labels = c("mask", "superstring")) +
    scale_fill_discrete(labels=c("E", "M", "L5", "G")) +
    scale_x_continuous(name = "subsampling rate", expand = c(0, 0), trans='log10') + #limits = c("E", "M", "L", "G")) +
    scale_y_continuous(expand = c(0, 0),
                       #name = "xz bits per distinct k-mers",
                       name = "") +
	   theme(legend.title= element_blank(),
	        plot.margin = unit(c(0.1, 0.1, 0.3, -0.4), "cm"))

ggsave(
    "xz_bits_per_kmer_HT_logScaleX.pdf",
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







