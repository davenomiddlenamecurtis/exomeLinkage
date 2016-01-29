library(data.table)

# my.ped <- read.csv('pedigree_details.csv')

fileName <- "el.arg"
conn <- file(fileName,open="r")
# params <- readLines(conn)
params <- readLines(conn,n=3,ok=FALSE)
close(conn)
# testName
# vcfFile
# pedFile

testName <- params[1]
vcfFile <- params[2]
pedFile <- params[3]

params
testName
pedFile
q()


rownames(my.ped) <- my.ped$ID

#geno <- read.csv('tony-variants_imputed.csv',check.names=FALSE)
#geno <- read.csv('tony-variants_imputed.csv',check.names=FALSE)
geno <- as.data.frame(fread('tony-variants_imputed.csv'))
#geno <- read.csv(file('stdin'), check.names=FALSE)

VARIANT_ID <- geno$VARIANT_ID
rownames(geno) <- VARIANT_ID
geno[which(geno == './.',arr.ind=T)] <- NA
geno[which(geno == '0/0' | geno == './0',arr.ind=T)] <- 0
geno[which(geno == '0/1' | geno == './1',arr.ind=T)] <- 1
geno[which(geno == '1/1',arr.ind=T)] <- 2

t.geno <- t(geno[,-c(1:2)])

geno2 <- t(apply(t.geno, 1, function(x) {
    x[is.na(x)] <- '0\t0'
    x[x=='0'] <- '1\t1'
    x[x=='1'] <- '1\t2'
    x[x=='2'] <- '2\t2'
    return(x)
}))

# ped ids
rownames(geno2) <- colnames(geno)[-c(1,2)]
#write.table(geno2,file='',sep='\t',quote=F)

ids <- intersect(my.ped$ID,rownames(geno2))
geno <- geno2[ids,] 

ids2 <- setdiff(my.ped$ID,ids)

#family  id  father  mother  sex affection   g1  g2

print(dim(a <- cbind(my.ped[ids,c('Family','ID','Father','Mother','Gender','Affection')],geno[ids,])))
print(dim(b <- cbind(my.ped[ids2,c('Family','ID','Father','Mother','Gender','Affection')],matrix("0\t0",nrow=length(ids2),ncol=ncol(geno)))))

colnames(b) <- colnames(a)

ped.file <- rbind(a,b)

write.table(ped.file,file='tony-variants_imputed.ped',sep='\t',col.names=FALSE,quote=FALSE,row.names=FALSE)

cat('A trait\n',file='tony-variants_imputed.dat')
cat(paste('M',VARIANT_ID,sep=' '),sep='\n',file='tony-variants_imputed.dat',append=TRUE)


