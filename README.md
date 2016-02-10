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

I made a pedigree file called jel.fam which looks like this:
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

I used default penetrance values but it will be better so specify a penetrance file.

I set the maximum number of alleles to 256 or more. The option to set from 3-255 did not work.

There is a supposed to be a way to recode the alleles to numeric. I haven't found it yet. Instead, I edited mega2 source so that all variants whose REF allele did not have length 1 were counted as indels (even if ALT was same length). Otherwise, they break merlin.

I selected option to Create Merlin model file.

I entered "1 e" for the R plot statistic selection menu.

At present it creates the analysis files in a unique, time-stamped folder. This makes it hard to write a script to automate the process. I am looking into it. There is a variable called CreateRunFolder and originally one could set it to 0 by providing the argument -nosave, however this is commented out. (In mega2.cpp.) It is used in utils.cpp and it would be trivial to edit the code to ignore this. Alternatively, a script could look in all plausible folders. But then would pick up old ones as well. We want to get control of where these files get written.


