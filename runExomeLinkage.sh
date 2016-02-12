# constants for executable names and folders
set -x
set -u

source parameters.sh

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
echo $MEGA2  --force_numeric_alleles mega2.$chr.inp < mega2.finish  > mega2.$chr.out
$MEGA2  --force_numeric_alleles mega2.$chr.inp < mega2.finish  > mega2.$chr.out
# now will need to parse output
	gotit=no
#  5) C-shell script name:                 2016-2-10-19-15/merlin.13.sh   [new]
    scriptName=`grep -m1 C-shell mega2.$chr.out | cut -d: -f2 | awk '{print $1}'`
    DIR=`dirname $scriptName`
    BASE=`basename $scriptName`
    echo ln -sf $DIR current
    ln -sf $DIR current
    scriptName="current/$BASE"
    echo $scriptName
	cp current/merlin_map.$chr current/real.merlin_map.$chr
	$MAKEFAKEMAPBIN current/real.merlin_map.$chr current/merlin_map.$chr
	cp $modelFile current/merlin_model 
    echo now will execute $scriptName
	csh $scriptName
done
