#================================================================================================
# 2019-10-07.Modified date:2019-10-10.DYY.Extract GO three classification most significant set,then get their intersection,
# except the intersection between MF & BP.
# The TPM value of the intersection gene is compared with the TPM value of the gene with high 
# expression & high translation.
#================================================================================================
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) 
s = read.table("CC_only_symbol.txt",header = F,quote = '',sep = '\t')
TPM =  read.table('SRR6930636_riboNum.txt',header = T,quote = '',sep = '\t')
hE_hT = read.table('SRR6930636_hE_ht_gene.txt',header = T,quote = '',sep = '\t')
names(s) = "Gene.Name"
s_TPM = merge(s,TPM,by = "Gene.Name",all.x = T)
s_TPM = s_TPM[complete.cases(s_TPM),]
s_TPM = unique(s_TPM)

svg('all_cc_vs_hE_hT_TPMbox.svg')
p1 <- boxplot(s_TPM$TPM,hE_hT$TPM,TPM$TPM,log = 'y',
              names=c('all_CC','hE_hT','global_gene'),col=c("red","yellow","blue"),ylab = 'TPM')
dev.off()
svg('all_cc_vs_hE_hT_riboTPMbox.svg')
p2 <- boxplot(s_TPM$ribo_TPM,hE_hT$ribo_TPM,TPM$TPM,log = 'y',
              names=c('all_CC','hE_hT','global_gene'),col=c("red","yellow","blue"),ylab = 'ribo_TPM')
dev.off()
hE_hT_only_name = hE_hT[,-c(2,3)]
write.table(hE_hT_only_name,file = "SRR6930636_hE_hT_only_name.txt",sep = '\t',quote = F,row.names = F,col.names = F)
#=======================================================================================================
# Extract GO three classification most significant set,then get their intersection.
# The TPM value of the intersection gene is compared with the TPM value of the gene with high 
# expression & high translation.
#=======================================================================================================
ss = read.table("CCinter.txt",header = F,quote = '',sep = '\t')
h_e_s = read.table('hE_hT_except_CCinter.txt',header = F,quote = '',sep = '\t')
s_e_s = read.table('CC_except_CCinter.txt',header = F,quote = '',sep = '\t')
names(ss) = "Gene.Name"
ss_TPM = merge(ss,TPM,by = "Gene.Name",all.x = T)
ss_TPM = ss_TPM[complete.cases(ss_TPM),]
names(h_e_s) = "Gene.Name"
h_e_s_TPM = merge(h_e_s,TPM,by = "Gene.Name",all.x = T)
h_e_s_TPM = h_e_s_TPM[complete.cases(h_e_s_TPM),]
names(s_e_s) = "Gene.Name"
s_e_s_TPM = merge(s_e_s,TPM,by = "Gene.Name",all.x = T)
s_e_s_TPM = s_e_s_TPM[complete.cases(s_e_s_TPM),]

svg('CC_except_inter_TPMbox.svg')
p3 <- boxplot(ss_TPM$TPM,h_e_s_TPM$TPM,s_e_s_TPM$TPM,TPM$TPM,log = 'y',
              names=c('inter_inter','hEhT_exc_inter','inter_exc_inter','global_gene'),
              col=c("red","yellow",'blue','green'),ylab = 'TPM')
dev.off()
svg('CC_except_inter_riboTPMbox.svg')
p4 <- boxplot(ss_TPM$ribo_TPM,h_e_s_TPM$ribo_TPM,s_e_s_TPM$ribo_TPM,TPM$ribo_TPM,log = 'y',
              names=c('inter_inter','hEhT_exc_inter','inter_exc_inter','global_gene'),
              col=c("red","yellow",'blue','green'),ylab = 'riboTPM')
dev.off()
