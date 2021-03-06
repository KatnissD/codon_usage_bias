#========================================================================================================
# 2019-11-5.Author:Yingying Dong.Correlation analysis of CAI by no reference set (weight from global genome) 
#  and global gene expression in all samples.
#========================================================================================================
library(getopt)
command=matrix(c("species","s",1,"character",
                 "experiment","e",1,"numeric",
                 "help","h",0,"logical"),byrow=T,ncol=4)
args=getopt(command)
if (!is.null(args$help) || is.null(args$species) || is.null(args$experiment)) {
  cat(paste(getopt(command, usage = T), "\n"))
  q()
}
species = args$species
exp = args$experiment

#species = "Drosophila_melanogaster"
#exp = "1"

setwd(paste0("/media/hp/disk1/DYY/reference/annotation/", species))
cai  = read.table(paste("/media/hp/disk1/DYY/reference/annotation/", 
                        species, "/ref/CBI_CAI.txt", sep = ""), sep = "\t", header = T,quote = '')
cai = data.frame(cai$transcription_id,cai$CAI)
dir.create(paste0("picture_byGLOBAL",exp))
dir.create(paste0("correlation_byGLOBAL",exp))
setwd(paste0("/media/hp/Katniss/DYY/aligned/",species,"/experiment",exp,"/"))
gtf_array = list.files(getwd(),pattern = "[SE]RR\\d.+out$") 
gtf_array
#graphics.off()
for (i in gtf_array) {
  if(FALSE) # examination
  { 
    gtf = read.table("SRR6815557_abund.out", sep = "\t", header=T,quote = "",fill = T)
    name = "SRR6815557"
  }
  #write.table(gtf$gene_id,file = "id_wait.txt",quote = F,row.names = F, col.names = F)
  gtf = read.table(i, sep = "\t", header = T,quote = "",fill = T)
  name = sub("^([^.]*).*", "\\1",i) 
  name = sub("_abund","",name)
  
  gtf = gtf[,-c(2,3,4,5,6,7)]
  names(cai) = c("gene_id","CAI")
  cai$gene_id = sub(" ","",cai$gene_id)
  df = merge(cai, gtf, by.x = "gene_id",by.y = "Gene.ID", all = T)
  df[df == 0] <- NA
  df = df[complete.cases(df),] # Or df = na.omit(df)
  #===========================================================================
  # Correlation_CAI_TPM 
  #===========================================================================
  jpeg(file=paste0("/media/hp/disk1/DYY/reference/annotation/", species,
                   "/picture_byGLOBAL",exp,"/",name,"_CAI_TPM.jpg"))
  CAI_cor = cor(df$CAI,df$TPM)
  CAI_cor
  plot(df$CAI,df$TPM,log = "y",main = paste0(name,"_CAI_TPM  ",CAI_cor),
       xlab="CAI",ylab="TPM",pch=19,col=rgb(0,0,100,50,maxColorValue=255))
  dev.off()
  #===============================================================================
  # Write out data,convenient to calculate the average
  #===============================================================================   
  write.table(CAI_cor,file =  paste0
              ("/media/hp/disk1/DYY/reference/annotation/", species,
                "/correlation_byGLOBAL",exp,"/","CAI_cor.txt"),append = T,quote = FALSE,
              row.names = F, col.names = F)
}
setwd(paste0("/media/hp/disk1/DYY/reference/annotation/",species,"/correlation_byGLOBAL",exp,"/" ))
a = read.table("CAI_cor.txt",sep = '\t',header = F)

aveCAI = mean(a$V1)
aveCAI

write.table(aveCAI,file = "mean_CAI.txt",
            quote = FALSE,row.names = "mean_correlation", 
            col.names = "\tCAI_TPM")