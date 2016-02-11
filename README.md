# exomeLinkage
Carry out linkage analysis on exome sequence data

This provides a system to carry out linkage analysis of exome sequence data. The typical scenario would be that one had exome-sequenced a few members of a family with a genetic disorder and had failed to discover a causative variant. The system uses mega2 to set up the analyses and merlin to perform them. A script to automate this process is provided. 

If you use this, please be sure to appropriately acknowledge/cite the authors of mega2 and merlin.

It is assumed that the data is vcf.gz files, one per chromosome.

The user must create a pedigree file as described in the mega2 documentation and edit the runExomeLinkage.sh script to point at the right executables and data files.

Before using the system, mega2 and merlin must be installed and makeFakeMap (provided) must be compiled.

The runExomeLinkage.sh script sets up a batch file for mega2 and runs it. However mega2 needs a few extra lines which are provided by a redirected input file. The default map file produced by mega2 is replaced by one created by makeFakeMap. The merlin model file is replaced by the one provided by the user. Then the script to run merlin is executed. This is repeated for each chromosome.

Further notes are below.


Notes

Use mega2 and merlin

Download mega2 from here:

https://watson.hgen.pitt.edu/register/ 

Documentation for mega2 here:

https://watson.hgen.pitt.edu/docs/mega2_html/mega2.html

To compile mega2 you need a modern C++ compiler because it has "lamdas" in the code.

On the CS cluster at UCL enter this to get g++ 4.7.2:

scl enable devtoolset-1.1 bash

When I did the default build mega2 would crash when trying to index a vcf file. I built the debug version and this ran fine. To build the debug version, in the srcdir folder enter:
```
make dbg
```
This gave me an executable called mega2_linux

Most of the input for mega2 is written to a batch file called e.g. mega2.chr22.inp.

mega2 creates a new working directory each time. The script has to parse the output of mega2 to find the name of this directory.

I selected compressed VCF format.

I added --maf 0.0001 to the "Enter VCF parameters" options (as well as --remove-indels). This was to remove monomorphic variants.

I made a pedigree file called jel.fam which looks like this (without blank lines):
```
jel	J13		J11	J12	2	2

jel	VIII9	J11	J12	2	2

jel	J11		J14	J9	1	2

jel	J12		0	0	2	1

jel	J2		J14	J9	1	2

jel	J9		J8	V9	2	2

jel J14		0	0	1	1

jel	J10		J8	V9	1	1

jel J8		0	0	1	2

jel	V9		0	0	2	1
```
If a subject is not in the vcf file it will be given unknown genotypes. Subjects in the vcf file not in the pedigree file will be ignored.

The vcf files should be numbered with 1 2 3 ... 22 but mega2 uses 01 02 03 ... 22. We haven't tried with X yet.

I set the maximum number of alleles to 256 or more. The option to set from 3-255 did not work.

I used  Mega2 command line flag --force_numeric_alleles so long alleles do not break merlin.

I selected option to Create Merlin model file.

I entered "1 e" for the R plot statistic selection menu.

In order to specify penetrances, one cannot use a mega2 penetrance file because it also needs a names.txt file. The best way seems to be to have a user-specified merlin model file and have it overwrite the default merlin_model file which gets created by mega2 and which looks like this:

        default 0.00100 0.050000,0.900000,0.900000  default
        
To compile makeFakeMap:

g++ -o makeFakeMap makeFakeMap.cpp -lm
