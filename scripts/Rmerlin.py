#! /share/apps/python/bin/python
#Installed: Wed Feb  3 12:20:18 GMT 2016
#
#=====end automatic header=======
#
# -------------------------
# PYTHON SCRIPT VERSION v4.5.3
# Last updated: 2010-07-22
# -------------------------
#   Mega2: Manipulation Environment for Genetic Analysis
#   Copyright (C) 1999-2016 Robert Baron, Charles P. Kollar,
#   Nandita Mukhopadhyay, Lee Almasy, Mark Schroeder, William P. Mulvihill,
#   Daniel E. Weeks, and University of Pittsburgh
#  
#   This file is part of the Mega2 program, which is free software; you
#   can redistribute it and/or modify it under the terms of the GNU
#   General Public License as published by the Free Software Foundation;
#   either version 3 of the License, or (at your option) any later
#   version.
#  
#   Mega2 is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#  
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#  
#   For further information contact:
#       Daniel E. Weeks
#       e-mail: weeks@pitt.edu
# 
# ===========================================================================
#
#
#

import copy, struct, string, sys, getopt, os

# function vc() returns a dictionary of vc LODS 
# ==> merlin_vc_table <==
# CHR	POS	LABEL	TRAIT	H2	LOD	PVALUE
# 15	0.000	D15S128	age	0.000	0.000	0.4997
# 15	9.184	D15S1002	age	0.000	0.000	0.4997

def vc(input_file) :

    # parse the header to figure out the columns
    inf = open(input_file)
    headers = inf.readline().lower().split(None)

    poscol = headers.index('pos')
    markercol = headers.index('label')
    traitcol = headers.index('trait')
    lodcol = headers.index('lod')

    scores = {}
    scores['vc'] = {}
    positions = {}
    order=[]

    for line in inf :
        items = line.split(None)

        try :
            # This is not a named marker
            pos = float(items[markercol])

        except:
            markername = items[markercol]
            
        else :
            markername = '_' + items[markercol]
            
        trait = items[traitcol]
        try:
            trindex = traitnames.index(trait)
        except:
            traitnames.append(trait)

        if not scores['vc'].has_key(trait) :
            scores['vc'][trait] = {}

        scores['vc'][trait][markername] = items[lodcol]

        if not positions.has_key(markername) : 
            positions[markername] = items[poscol]
            order.append(markername)

    inf.close()

    return (positions, order, scores, traitnames)

# end of function vc()

# Function npl() returns a list of LODS for stats ALL, Pair and QTL
# ==> merlin_npl_table <==
# CHR	POS	LABEL	ANALYSIS	ZSCORE	DELTA	LOD	PVALUE
# na	na	min	aff [ALL]	-15.064	-0.188	-13.409	1
# na	na	max	aff [ALL]	23.225	0.707	52.988	2.612e-55

# ==> merlin_qtl_npl_table <==
# CHR	POS	LABEL	ANALYSIS	ZSCORE	DELTA	LOD	PVALUE
# na	na	min	age [QTL]	-16.107	-0.227	-16.882	1
# na	na	max	age [QTL]	22.362	0.707	52.170	1.733e-54

def npl(input_file) :
    # parse the header to figure out the columns
    inf = open(input_file)
    headers = inf.readline().lower().split(None)
    poscol = headers.index('pos')
    markercol = headers.index('label')
    traitcol = headers.index('analysis')
    lodcol = headers.index('lod')
    
    scores = {}
    positions = {}
    traitnames = []
    order = []
    for line in inf :
        items = line.split(None)
        if items[0] == 'na' :
            continue

        try :
            # This is not a named marker
            pos = float(items[markercol])

        except:
            markername = items[markercol]
            
        else :
            markername = '_' + items[markercol]

        trait = items[traitcol]
        try:
            trindex = traitnames.index(trait)
        except:
            traitnames.append(trait)

        stat = items[traitcol+1].strip('[]').lower()

        if not scores.has_key(stat) :
            scores[stat]={}

        if not scores[stat].has_key(trait) :
            scores[stat][trait] = {}

        scores[stat][trait][markername] = items[lodcol+1]
        
        if not positions.has_key(markername) : 
            positions[markername] = items[poscol]
            order.append(markername)
    
    inf.close()
#     print(scores)
#     print(positions)
#     print(order)
    return (positions, order, scores, traitnames)

# end of function npl()

# Function model(),  returns lods, hlods and positions
# ==> merlin_model_table <==
# CHR	POS	LABEL	MODEL	LOD	ALPHA	HLOD
# 15	0.0000	D15S128	aff	-0.4155	0.0000	0.0000
# 15	0.0918	D15S1002	aff	-0.6228	0.0000	0.0000


def model(input_file) :
    # parse the header to figure out the columns
    inf = open(input_file)
    headers = inf.readline().lower().split(None)
    poscol = headers.index('pos')
    markercol = headers.index('label')
    traitcol = headers.index('model')
    lodcol = headers.index('lod')
    hlodcol = headers.index('hlod')

    scores = {}
    scores['lod'] = {}
    scores['hlod'] = {}
    positions = {}
    order=[]

    traitnames = []

    for line in inf :
        items = line.split(None)

        try :
            # This is not a named marker
            pos = float(items[markercol])

        except:
            markername = items[markercol]
            
        else :
            markername = '_' + items[markercol]
        
        trait = items[traitcol]

        try:
            trindex = traitnames.index(trait)
        except:
            traitnames.append(trait)

        if not scores['lod'].has_key(trait) :
            scores['lod'][trait] = {}

        if not scores['hlod'].has_key(trait) :
            scores['hlod'][trait] = {}

        scores['lod'][trait][markername] = items[lodcol]
        scores['hlod'][trait][markername] = items[hlodcol]

        if not positions.has_key(markername) : 
            positions[markername] = str(100.0*float(items[poscol]))
            order.append(markername)
    
    inf.close()

    return (positions, order, scores, traitnames)

#end of function model()

# function output_scores()
# output nplplot-formatted file containing selected scores and statistics

def output_scores(scores, positions, order, traits, stats, outfile, obs_traits, output_all) :

    # write the scores
    outf = open(outfile, 'w')

    # First see if the score matrix has trait keys that match 
    # output traits

    mismatch = 0
    for it in traits :
        try :
            i=obs_traits.index(it)
        except :
            mismatch = 1
            break

    if mismatch and output_all :
        traits = obs_traits

    nostat = 1
    headers = []

    for stat in stats :
        statl = stat.lower()
        if scores.has_key(statl) :
            nostat = 0
            for trait in traits :
                headers.append(trait + '_' + stat)
    
    if nostat :
        sys.stderr.write('ERROR - No scores found\n')
        print('ERROR - No scores found\n')
        sys.exit(-1);

    outf.write('Marker      Position '    + '  '.join(headers) + '\n')
    found_a_score = 0
    for markername in order :
        pos = positions[markername]
        if markername.find('_') >= 0 :
            outf.write('   -        %10s  ' % pos)
        else :
            outf.write('%-10s  %10.8f  ' % (markername, float(pos)))

        for trait in traits :
            for stat in stats :
                statl = stat.lower()
                if scores[statl].has_key(trait) :
                    if scores[statl][trait].has_key(markername) :
                        outf.write('%9s  ' % scores[statl][trait][markername])
                        found_a_score = 1
                    else :
		        outf.write('    NA     ')
                else :
                    outf.write('    NA     ')
        outf.write('\n')

    outf.close()

    if found_a_score :
        return headers
    else :
        os.remove(outfile)
        return None

# end of output_scores()

# function update_header_file to write plot configuration params
# into plot header file

def update_header_file(outfile, headers) :

    # first read in the Mega2 generated lines

    num_headers = len(headers)
    hdrf = open(outfile + '.hdr')
    lines = hdrf.readlines()
    
    # Now write out these lines

    hdrf = open(outfile + '.hdr', 'w')
    for line in lines :
        hdrf.write(line)
        if line.find('inserted by Mega2') >= 0 :
            break

    hdrf.write('lgndtxt <- c(\"' + headers.pop(0) + '\"')

    for header in headers :
        hdrf.write(', \"' + header + '\"')
    
    hdrf.write(')\n')


    R_ltypes=range(1,7)
    R_colors = ['black', 'red', 'green', 'blue']
    R_ptypes = [0, 20, 21, 22]

    plot_attribs = []

# This will create 96 tuples.
# Want ltype to change most often, then color, then ltype

    for ptype in R_ptypes :
        for color  in R_colors :
            for ltype  in R_ltypes :
                plot_attribs.append((str(ltype), color, str(ptype)))
    

    ltypes_str = 'ltypes <- c('
    colors_str = 'my.colors <- c('
    ptypes_str = 'ptypes <- c('

# start off with the first tuple;

    ltypes_str = ltypes_str + plot_attribs[0][0]
    colors_str = colors_str + '\"' + plot_attribs[0][1] + '\"'
    ptypes_str = ptypes_str + plot_attribs[0][2]

    lnum = 1;

    for i in range(1, num_headers) :
        lnum = i % 64;
        ltypes_str = ltypes_str + ', ' + plot_attribs[lnum][0]
        colors_str = colors_str + ', \"' + plot_attribs[lnum][1] + '\"'
        ptypes_str = ptypes_str + ', ' + plot_attribs[lnum][2]


    ltypes_str = ltypes_str + ')'
    colors_str = colors_str + ')'
    ptypes_str = ptypes_str + ')'

    hdrf.write(ltypes_str + '\n')
    hdrf.write(colors_str + '\n')
    hdrf.write(ptypes_str + '\n')

    hdrf.close()

# end of function update_header_file

# example of call to this script:
# Rmerlin.py -c VC -t age,stature,height -o RMERLINDATA.05 merlin_out.05

def parse_opts(options) :
    
    traits = None

    try:
        optlist, input_file = getopt.getopt(options, 'c:o:t:')

    except:
        print("Unknown option to Rmerlin.py.")

    else:
        for o, a in optlist :
            if o == '-c' :
                # statistics list
                stats = a
            elif o == '-t' :
                # trait list
                traits = a
            elif o == '-o' :
                # output file
                outfile = a

    return stats, traits, outfile, input_file[0]

# end of parse_opts()

# main program

def main() :
    
    (stats, traits, outfile, infile) = parse_opts(sys.argv[1:])
    statnames = stats.split(',')

    if traits != None :
        traitnames = traits.split(',')        

    # figure out what file type it is from the header line
    # VC contains H2
    # NPL (QTL) contains ZSCORE
    # PARAM contains HLOD
    
    if not os.path.exists(infile) :
        sys.stderr.write('ERROR - File ' + infile + ' not found.')
        print('ERROR - File ' + infile + ' not found.')
        sys.exit(-1)

    inf = open(infile)
    headers = inf.readline().split(None)
    inf.close()
    # Should we output all scores if trait asked for is not seen?
    output_all_by_default = 0

    try :
        headers.index('H2')
    except:
        try :
            headers.index('ZSCORE')
        except:
            try :
                headers.index('HLOD')
                output_all_by_default = 1
            except:
                sys.stderr.write('ERROR - Unknown merlin table format.')
                print('ERROR - Unknown merlin table format.')
                sys.exit(-1)
            else :
                (positions, order, scores, obs_traitnames) = model(infile)
        else :
            (positions, order, scores, obs_traitnames) = npl(infile)
    else :
        (positions, order, scores, obs_traitnames) = vc(infile)


    headers_out = \
        output_scores(scores, positions, order, traitnames, \
                          statnames, outfile, obs_traitnames, output_all_by_default) 
    if headers_out == None :
        sys.stderr.write('ERROR - No scores found.')
        print 'ERROR - No scores found.'
        sys.exit(-1)
    else :
        update_header_file(outfile, headers_out)


# end of main program

if __name__ == "__main__" :
    main()
