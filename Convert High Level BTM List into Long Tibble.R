## Objective: Converts High Level BTM List into Tibble Long Format for Convenient Merging with Feature Data

library(tidyverse)
source("/Volumes/GoogleDrive/My Drive/R scripts/Make low and high level BTMs.R")

#enframe(hilevel.list)
hiBTM.geneid.long <- do.call(rbind, hilevel.list) %>%
  t() %>%
  as_tibble() %>%
  pivot_longer(., cols = 1:ncol(.), names_to = "hiBTM", values_to = "GeneSymbol") %>%
  group_by(hiBTM) %>%
  distinct(GeneSymbol, .keep_all=TRUE) %>%
  ungroup() %>%
  arrange(.,GeneSymbol)
#check
# intersect(foo[foo$`high-level BTM`=="B CELLS",]$GENEID, foo[foo$`high-level BTM`=="T CELLS",]$GENEID)
# setdiff(foo[foo$`high-level BTM`=="B CELLS",]$GENEID, foo[foo$`high-level BTM`=="T CELLS",]$GENEID)
# setdiff(foo[foo$`high-level BTM`=="T CELLS",]$GENEID, foo[foo$`high-level BTM`=="B CELLS",]$GENEID)
# summary(factor(foo[foo$`high-level BTM`=="B CELLS",]$GENEID))
hiBTM.geneid.wide <- hiBTM.geneid.long %>%
  mutate(present = 1) %>%
  pivot_wider(., names_from = hiBTM, values_from = present) %>%
  replace(is.na(.), 0)

#Monaco
monaco.list <- readRDS("/Volumes/GoogleDrive/My Drive/Tran Lab Shared/Projects/Doris Duke PfSPZ Kenya/Tuan PfSPZ/KenyaPfSPZ/MonacoModules.rds")
monaco.geneid.long <- do.call(rbind, monaco.list) %>%
  t() %>%
  as_tibble() %>%
  pivot_longer(., cols = 1:ncol(.), names_to = "MonacoMods", values_to = "GeneSymbol") %>%
  group_by(MonacoMods) %>%
  distinct(GeneSymbol, .keep_all=TRUE) %>%
  ungroup() %>%
  arrange(.,GeneSymbol)
monaco.geneid.wide <- monaco.geneid.long %>%
  mutate(present = 1) %>%
  pivot_wider(., names_from = MonacoMods, values_from = present) %>%
  replace(is.na(.), 0)
