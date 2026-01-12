#Cleaning and visualising gene expression data
  #Grace November 2025

#I have annotated by gene data using PFAM domains and combined my 2 species datasets using a reciprocal BLAST. 
  #Now I have a list of several thousand genes, which I need to filter down to just the differentially expressed genes and visualise. 

#packages
pacman::p_load(ggplot2, 
               tidyverse,
               wesanderson)


# significant DEGs --------------------------------------------------------


dat <- read.csv("degs.csv", header = TRUE, stringsAsFactors = FALSE)
#This is my catalogue of orthologous genes and their RPKM across my two species, already filtered by fold change >2. 

#Assign tissue and species (four groups):
QG <- c("Q1G", "Q2G", "Q3G")
RG <- c("R1G", "R2G", "R3G")
QH <- c("Q1H", "Q2H", "Q3H")
RH <- c("R1H", "R2H", "R3H")

head(dat)

# Test significance with multiple P-value correction. 
gill_fdr  <- p.adjust(dat$gill_p, method = "fdr")
gill_holm <- p.adjust(dat$gill_p, method = "holm")

hepato_fdr  <- p.adjust(dat$hepato_p, method = "fdr")
hepato_holm <- p.adjust(dat$hepato_p, method = "holm")

# Results table
results <- data.frame(
  Quadri_name = dat$Quadri_name,
  
  p_gill = dat$gill_p,
  fdr_gill = gill_fdr,
  holm_gill = gill_holm,
  
  p_hepato = dat$hepato_p,
  fdr_hepato = hepato_fdr,
  holm_hepato = hepato_holm)

# Inspect significant genes
subset(results, fdr_hepato < 0.05)
subset(results, fdr_gill < 0.05)

subset(results, holm_hepato < 0.05)
subset(results, holm_gill < 0.05)

#Total 44 across both species/tissues. 

#manageable number of degs! Excellent

# Export
library(openxlsx)
write.xlsx(results, "sig_degs.xlsx", rowNames = FALSE)


# Heatmap of DEGs ---------------------------------------------------------

#I have annotated and re-ordered the DEGs based on NCBI BLAST alignments. 
#This is the same list as just exported, but ordered into functional groups to make the heatmap more useful. 

#data
dat <- read.csv("ordered_degs.txt", header = TRUE) #overwrite
head(dat)

#long data for ggplot
dat_long <- dat %>%
  pivot_longer(
    cols = -Name,
    names_to = "Sample",
    values_to = "Expression")

#log correction
dat_long <- dat_long %>%
  mutate(log_expr = log10(Expression + 1))

#z score correction
dat_long <- dat_long %>%
  group_by(Name) %>%
  mutate(z_expr = as.numeric(scale(log_expr))) %>%
  ungroup()

#Plot heatmap
ggplot(dat_long, aes(x = Sample, y = Name, fill = z_expr)) +
  geom_tile() +
  scale_fill_gradient2(
    low = "#3A9AB2",
    mid = "white",
    high = "#DCCB4E",
    midpoint = 0,
    name = "Z-score"  ) 

#Heatmap done 
  #also going to make stacked bar chart of degs per tissue/species for the manuscript

df <- tribble(
  ~Regulation, ~gill, ~hepato,
  "upregulated",     5,      33,
  "downregulated",   3,       3)

df_long <- df %>%
  pivot_longer(
    cols = c(gill, hepato),
    names_to = "Tissue",
    values_to = "Count")

ggplot(df_long, aes(x = Tissue, y = Count, fill = Regulation)) +
  geom_col(width = 0.7) +
  scale_fill_manual(
    values = c("upregulated" = "#DCCB4E", "downregulated" = "#3A9AB2"),
    name = "Expression") +
  labs(
    x = "Tissue",
    y = "Number of Transcripts") +
  theme_classic() 

#done!

