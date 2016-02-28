#! /bin/bash 

# runExomeLinkage.sh
# script to run linkage analysis on exome sequence data
# please see README.md file for details

set -x
# set -u

# the lines below need to be edited to set up the analyses and paths correctly

# set parameters specific to the analysis

# set which chromosomes to use
# we have not set up to use X yet
# if you want to test for X linkage you will have to modify the scripts

chrs="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"
# chrs=22
# use above to test just one chromosome

# specify the pedigree file to use to describe the structure and phenotypes of subjects to use
# subjects not in the vcf file will be treated as having unknown genotypes

famFile=/home/rejudcu/exomeLinkage/jel.fam

# specify the prefix for the vcf files, which are assumed to have format prefixCC.vcf, where CC is the chromosome number
# e.g. /home/rejudcu/exomeLinkage/exomes/chr08.vcf.gz
vcfPrefix=/home/rejudcu/exomeLinkage/exomes/chr

# specify a model file which defines the penetrances and allele frequency for the disease variant

modelFile=/home/rejudcu/exomeLinkage/dominant.model

# set locations of necessary binaries and scripts for the system

# set the name and location of the mega2 executable
MEGA2BIN=/home/rejudcu/mega2/mega2_v4.8.2_src/srcdir/mega2_linux

# set the name and location of the makeFakeMap executable
MAKEFAKEMAPBIN=/home/rejudcu/exomeLinkage/makeFakeMap

# set the name of the folder containing the merlin executable
MERLINFOLDER=/cluster/project8/vyp/AdamLevine/software/merlin

# set the name of the folder containing R executables
RFOLDER=/share/apps/R/bin

# set the name of the folder containing the mega2 scripts, such as Rmerlin.py
MEGA2SCRIPTSFOLDER=/home/rejudcu/mega2/bin

# the rest of the script should not require any modifications

export PATH=$MEGA2SCRIPTSFOLDER:$MERLINFOLDER:$RFOLDER:$MEGA2SCRIPTSFOLDER:$PATH

for c in $chrs
do
    date
    echo Starting on chromosome $c
    chr=`printf "%02d" $c`
    echo "
Input_Format_Type=6
Input_Pedigree_File=$famFile
Input_Aux_File=${vcfPrefix}${c}.vcf.gz
Output_Path=.
Input_Path=.
PLINK_Args= --missing-phenotype -9 --trait default
VCF_Args=--remove-indels --maf 0.00001
Input_Untyped_Ped_Option=2
Input_Do_Error_Sim=no 
AlleleFreq_SquaredDev=999999999.000000
Value_Marker_Compression=3
Analysis_Option=Merlin
Value_Missing_Quant_On_Input=-9.000000
Value_Missing_Affect_On_Input=-9
Count_Genotypes=4
Count_Halftyped=no 
Chromosome_Single=$chr
Traits_Combine=1 2 e
Default_Reset_Halftype=no 
Default_Reset_Mendelerr=yes
Default_Reset_Alleleerr=no 
Default_Set_Uniq=no 
Rplot_Statistics= 1 e
" > mega2.$chr.inp
	echo "
2
0
0
0
" > mega2.finish 
    echo $MEGA2BIN  --force_numeric_alleles mega2.$chr.inp < mega2.finish  > mega2.$chr.out
    $MEGA2BIN  --force_numeric_alleles mega2.$chr.inp < mega2.finish  > mega2.$chr.out
    # now will need to parse output, looking for a line like this:
    #  5) C-shell script name:                 2016-2-10-19-15/merlin.13.sh   [new]
    scriptName=`grep -m1 C-shell mega2.$chr.out | cut -d: -f2 | awk '{print $1}'`
    DIR=`dirname $scriptName`
    BASE=`basename $scriptName`
    echo $scriptName
    cp $DIR/merlin_map.$chr $DIR/real.merlin_map.$chr
    $MAKEFAKEMAPBIN $DIR/real.merlin_map.$chr $DIR/merlin_map.$chr
    cp $modelFile $DIR/merlin_model 
    echo now will execute $scriptName
    csh $scriptName > chr$c.out
done


