#===========================================================================================================
# 2019-9-19.Modified date:2020-1-9.Author:Dong Yingying.Differences in codon frequency and RSCU value 
#  between DNA sequence codon frequencies of genes that high express high translation and DNA sequences 
#  of genes with low expression and low translation.
#===========================================================================================================
library(pheatmap)

species = 'C_elegans_Ensl_WBcel235'
exp = '2'

setwd(paste0("~/Desktop/other_riboseq/",species,"/experiment",exp,"/aligned/ribo_num"))
hE_hT = read.table("hE_hT_codon_fre_RSCU.txt",header = T,sep = '\t',quote = "")
lE_lT = read.table("lE_lT_codon_fre_RSCU.txt",header = T,sep = '\t',quote = "")
hE_hT10 = read.table("hE_hT10_codon_fre_RSCU.txt",header = T,sep = '\t',quote = "")
mE_mT10 = read.table("mE_mT10_codon_fre_RSCU.txt",header = T,sep = '\t',quote = "")
rp = read.table("rp_codon_fre_RSCU.txt",header = T,sep = '\t',quote = "")
Mrp = read.table("Mrp_codon_fre_RSCU.txt",header = T,sep = '\t',quote = "")
all_rp = read.table("all_rp_codon_fre_RSCU.txt",header = T,sep = '\t',quote = "")
global_gene = read.table(paste0("/media/hp/disk1/DYY/reference/annotation/",species,"/ref/CDS_codon_fre_RSCU.txt")
                           ,header = T,sep = '\t',quote = "",stringsAsFactors = F)

hE_hT_RSCU = data.frame(hE_hT$AA,hE_hT$codon,hE_hT$RSCU)
names(hE_hT_RSCU) = c("AA","codon","hE_hT_RSCU")
hE_hT10_RSCU = data.frame(hE_hT10$codon,hE_hT10$RSCU)
names(hE_hT10_RSCU) = c("codon","hE_hT10_RSCU")
mE_mT10_RSCU = data.frame(mE_mT10$codon,mE_mT10$RSCU)
names(mE_mT10_RSCU) = c("codon","mE_mT10_RSCU")
lE_lT_RSCU = data.frame(lE_lT$codon,lE_lT$RSCU)
names(lE_lT_RSCU) = c("codon","lE_lT10_RSCU")

global_RSCU = data.frame(global_gene$codon,global_gene$RSCU)
names(global_RSCU) = c("codon","genome_RSCU")
all_rp_RSCU = data.frame(all_rp$codon,all_rp$RSCU)
names(all_rp_RSCU) = c("codon","all_RP_RSCU")
Mrp_RSCU = data.frame(Mrp$codon,Mrp$RSCU)
names(Mrp_RSCU) = c("codon","Mitochondria_RP_RSCU")
rp_RSCU = data.frame(rp$codon,rp$RSCU)
names(rp_RSCU) = c("codon","RP_RSCU")

codon_RSCU = merge(hE_hT_RSCU,hE_hT10_RSCU,by = "codon")
codon_RSCU = merge(codon_RSCU,mE_mT10_RSCU,by = "codon")
codon_RSCU = merge(codon_RSCU,lE_lT_RSCU,by = "codon")
codon_RSCU = merge(codon_RSCU,global_RSCU,by = "codon",all=T)
codon_RSCU = merge(codon_RSCU,all_rp_RSCU,by = "codon")
codon_RSCU = merge(codon_RSCU,Mrp_RSCU,by = "codon")
codon_RSCU = merge(codon_RSCU,rp_RSCU,by = "codon")

#codon_RSCU = codon_RSCU[order(codon_RSCU$AA,decreasing = F),] # order by AA.
codon_RSCU$codon = gsub(" ", "",codon_RSCU$codon)
codon_RSCU$AA = gsub(" ", "",codon_RSCU$AA)
codon_RSCU = codon_RSCU[-grep('M',codon_RSCU$AA),]
codon_RSCU = codon_RSCU[-grep('W',codon_RSCU$AA),]
codon_RSCU = codon_RSCU[-grep('STOP',codon_RSCU$AA),]
codon_RSCU$AA_codon = paste(codon_RSCU$codon,codon_RSCU$AA,sep = " (") # codon (aa)
codon_RSCU$AA_codon = paste0(codon_RSCU$AA_codon,")")
rownames(codon_RSCU) = codon_RSCU[,11] # AA_codon as row name
codon_RSCU = codon_RSCU[,-c(1,2,11)]

pheatmap(codon_RSCU,cluster_cols = FALSE,color = colorRampPalette(c("red", "black", "green"))(50),         
         cellwidth = 37, cellheight = 12, fontsize = 7,
         filename = "heatmap_40_codon_RSCU_all.pdf")





