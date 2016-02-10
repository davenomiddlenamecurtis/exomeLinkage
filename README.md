# exomeLinkage
Carry out linkage analysis on exome sequence data

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

I set the maximum number of alleles to 256 or more. The option to set from 3-255 did not work.

I used  Mega2 command line flag --force_numeric_alleles) so long alleles do not break merlin.

I selected option to Create Merlin model file.

I entered "1 e" for the R plot statistic selection menu.

I used excel to create a fake map file. I read in the one written by mega2 (all variants at position 0) and wrote out one with each variant at 0.01 from the one before. See the example.fake.map file.

In order to specify penetrances, one cannot use a mega2 penetrance file because it also needs a names.txt file. The best way seems to be to have a user-specified merlin model file and have it overwrite the default merlin_model file which gets created by mega2 and which looks like this:

        default 0.500000 0.050000,0.900000,0.900000  default
        
This is all now implemented in the script. Just need to compile makeFakeMap.cpp and specify the locations of executables and data files.
