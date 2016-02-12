# constants for executable names and folders
MEGA2BIN=/home/rejudcu/mega2/mega2_v4.8.2_src/srcdir/mega2_linux
MAKEFAKEMAPBIN=/home/rejudcu/exomeLinkage/makeFakeMap
MERLINFOLDER=/cluster/project8/vyp/AdamLevine/software/merlin
RFOLDER=/share/apps/R/bin
PATH=$MERLINFOLDER:$RFOLDER:$PATH

# for the user to set
famFile=exome-pedigree.fam
modelFile=/home/rejudcu/exomeLinkage/dominant.model
vcfPrefix=/cluster/project8/vyp/pontikos/People/PetraLiskova/exomes/chr
# e.g. /cluster/project8/vyp/pontikos/People/PetraLiskova/exomes/chr13.vcf.gz

#chrs="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"
chrs="22"

for c in $chrs
do
	chr=`printf "%02d" $c`
	echo Input_Format_Type=6 > mega2.$chr.inp
	echo Input_Pedigree_File=$famFile >> mega2.$chr.inp
	echo Input_Aux_File=$vcfPrefix$c.vcf.gz >> mega2.$chr.inp
	echo "
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
" >> mega2.$chr.inp
	echo Chromosome_Single=$chr >> mega2.$chr.inp
	echo "
Traits_Combine=1 2 e
Default_Reset_Halftype=no 
Default_Reset_Mendelerr=yes
Default_Reset_Alleleerr=no 
Default_Set_Uniq=no 
Rplot_Statistics= 1 e
" >> mega2.$chr.inp
	echo "
2
0
0
0
" >> mega2.finish 
$MEGA2BIN  --force_numeric_alleles mega2.$chr.inp < mega2.finish  > mega2.$chr.out

# now will need to parse output
	gotit=no
#  5) C-shell script name:                 2016-2-10-19-15/merlin.13.sh   [new]
	fgrep C-shell mega2.$chr.out | while read num cshell script name scriptName new
	do
		if [ $gotit = no ]
		then
			gotit=yes
			echo scriptName=$scriptName > setScriptName.sh
		fi
	done
	source setScriptName.sh
	tempFolder=${scriptName%/*}
	mv $tempFolder/merlin_map.$chr $tempFolder/real.merlin_map.$chr
	$MAKEFAKEMAPBIN $tempFolder/real.merlin_map.$chr $tempFolder/merlin_map.$chr
	cp $modelFile $tempFolder/merlin_model 
	csh $scriptName

done
