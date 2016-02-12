# for the user to set
#famFile=exome-pedigree.fam
famFile=jel.fam
modelFile=/home/rejudcu/exomeLinkage/dominant.model
vcfPrefix=../chr
# e.g. /home/rejudcu/exomeLinkage/exomes/chr13.vcf.gz

#chrs="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"
chrs="22"
# chrs="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"
#chrs="22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 "
# small ones first to check it works OK
# chrs="9"

MEGA2=/home/rejudcu/mega2/mega2_v4.8.2_src/srcdir/mega2_linux
MAKEFAKEMAPBIN=/home/rejudcu/exomeLinkage/makeFakeMap
MERLINFOLDER=/cluster/project8/vyp/AdamLevine/software/merlin
RFOLDER=/share/apps/R/bin
MEGA2_BIN=/home/rejudcu/mega2/bin
PATH=scripts/:$MERLINFOLDER:$RFOLDER:$MEGA2_BIN:$PATH


