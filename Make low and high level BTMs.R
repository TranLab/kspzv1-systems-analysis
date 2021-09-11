
library(openxlsx)
library(reshape2)
datadirtemp <- "/Volumes/GoogleDrive/My Drive/Tran Lab Shared/Transcriptional Modules and Genesets/BTM SupplementaryData_TutorialPackage/"

#############################
#Make list of low level BTMs#
#############################

btmxls <- openxlsx::read.xlsx(paste0(datadirtemp,"btm_annotation_table.xlsx"), sheet = 1)
btm <- as.list(as.character(btmxls$Module.member.genes))
names(btm) <- btmxls$ID

for(i in 1:length(btm)){
  btm[[i]] <- gsub(" ///", ",", btm[[i]])
  btm[[i]] <- gsub(" ", "", btm[[i]])
  btm[[i]] <- unlist(strsplit(btm[[i]], "," ))
}


################################
#Make list of higher level BTMs#
################################

hilevel <- read.csv(paste0(datadirtemp, "BTM_high_level_annotations.csv"))[,1:2]
as.list(hilevel)
colnames(hilevel) <- c("BTM", "SUBGROUP")
recast(hilevel, SUBGROUP~BTM, id.var = c("SUBGROUP","BTM"))
hilevel.foo <- recast(hilevel, SUBGROUP~BTM, id.var = c("SUBGROUP","BTM"))
hilevel.foo <- hilevel.foo[-1,]
foo <- c()
for(i in 1:nrow(hilevel.foo)){
  foo[[i]] <- hilevel.foo[i,][!is.na(hilevel.foo[i,])]
  names(foo)[i] <- foo[[i]][1]
  foo[[i]]    <- foo[[i]][-1]
}

hilevel.list <- c()
for(i in 1:length(foo)){
  hilevel.list[[i]] <- unique(gsub(" ", "", unlist(btm[foo[[i]]])))
}
names(hilevel.list) <- names(foo)
#ind.btm <- ids2indices(hilevel.list, as.character(fit$genes$GeneSymbol))
annot.btm <- hilevel[,1:2]

hilevel.list

names(btm) <- btmxls$Composite.name