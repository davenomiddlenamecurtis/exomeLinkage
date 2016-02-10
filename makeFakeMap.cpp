#if 0

This takes two filenames as arguments. 
First is a dummy map file created by mega2 with all markers at position 0.
Output is to the second. Each chr_??? marker is set at map position bp/1000000.
Each rs??? variant is interpolated between the chr_??? ones

compile with:
g++ -o makeFakeMap makeFakeMap.cpp -lm

#endif

#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <vector>
using namespace std;

#define error(str1,str2) fprintf(stderr,"Error in %s, line %s: %s %s\n",__FILE__, __LINE__,str1,str2),exit(1)

int main(int argc, char *argv[])
{
	FILE *fi,*fo;
	char line[200],varName[100],chr[100];
	float lastPos,thisPos,fakePos;
	int i;
	vector<string> rsIDs;
	if (argc!=3)
		error("Must provide original and new map file on command line, e.g. makeFakeMap real.map fake.map","");
	assert((fi=fopen(argv[1],"r"))!=0);
	assert((fo=fopen(argv[2],"w"))!=0);
	fgets(line,199,fi);
	fprintf(fo,"%s",line);
	lastPos=-1;
	while (fgets(line, 199,fi))
	{
		if (sscanf(line,"%s %s",chr,varName)!=2)
			break;
		if (!strncmp(varName, "chr", 3))
		{
			if (sscanf(varName,"%*[^_]_%f",&thisPos)!=1)
				error("Could not parse this chromosomal location:",varName);
			if (rsIDs.size())
			{
				if (lastPos==-1)
					lastPos=thisPos-10000;
				for (i = 0; i < rsIDs.size(); ++i)
				{
					fakePos=lastPos+(thisPos-lastPos)*(i+1)/(rsIDs.size()+1);
					fprintf(fo,"%s\t%s\t%10.6f\n",chr,rsIDs[i].c_str(),fakePos/1000000);
				}
				rsIDs.clear();
			}
			fprintf(fo,"%s\t%s\t%10.6f\n",chr,varName,thisPos/1000000);
			lastPos=thisPos;
		}
		else
		{
			rsIDs.push_back(string(varName));
		}
	}
	if (rsIDs.size())
	{
		thisPos=lastPos=10000;
		for (i = 0; i < rsIDs.size(); ++i)
		{
			fakePos=lastPos+(thisPos-lastPos)*i/rsIDs.size();
			fprintf(fo,"%s\t%s\t%10.6f\n",chr,rsIDs[i].c_str(),fakePos/1000000);
		}
		rsIDs.clear();
	}
	return 0;
}
