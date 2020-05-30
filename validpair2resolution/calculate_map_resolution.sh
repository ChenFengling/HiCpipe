#!/bin/bash
##########
#The MIT License (MIT)
#
# Copyright (c) 2015 Aiden Lab
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
##########
#
# Author: Suhas Rao
# modifications by Neva C. Durand
#
# As described in Rao&Huntley et al., Cell 2014, calculates the map resolution
#
# First creates the 50bp coverage vector. That is, counts the number of 
# contacts for every 50bp bin in the genome (defined as any contact where one
# read mapped within that 50bp bin).
# 
# This vector is then binned into larger and larger increments (i.e. 100bp, 150bp,
# and so on) until the number of bins with >1000 contacts is at least 80% of the 
# total number of bins
#
# Note that the total number of bins depends on the genome size. Change that 
# parameter below if the genome is not hg19
#
# Modified so that binary search is used to more quickly find the map resolution
#
# Usage:
# calculate_map_resolution.sh <merged_nodups file> <50bp coverage file>
#
# The 50bp coverage vector is calculated from the merged_nodups file.
# The 50bp coverage file will be created under the name sent; if it's already been
# created under that name, the script will not recreate it (and indeed will not
# examine the first argument)

# total size of genome, from http://genomewiki.ucsc.edu/index.php/Hg19_Genome_size_statistics
# modify this number if your genome is not hg19
#total=3137161264
# rheMac8 chr1-20MXY
#total=2835979954
total=3137161264 #hg19
#total=3063310485 #gorGor4
#total=2725537669 #mm10

if [ "$#" -ne 1 ]
then
    echo "Usage: calculate_map_resolution.sh <merged_nodups file>"
    echo "  <merged_nodups file>: file created by Juicer containing all valid+unique read pairs"
    exit
fi	

filename=$1
coveragename=$(basename $1).cov

# Create 50bp coverage vector
if [ ! -s $coveragename ]
then
    awk '{
      if ($11>0&&$12>0&&$9!=$10)
        {
        chr1=0;
        chr2=0;

        chr1=$2; 
        chr2=$5;
        if (chr1!=0&&chr2!=0)
        {
         val[chr1 " " int($3/50)*50]++
         val[chr2 " " int($6/50)*50]++
        }
      }
   }
   END{
     for (i in val)
     {
       print i, val[i]
     }
   }' "$filename" > $coveragename
fi


echo -n "Seach resolution: " >&2
# the smallest bin is this newbin, it should be set to 50, but you can set it to a large number if you know the resulotion is bigger (in number) than $newbin, so you can select a upper bound faster
newbin=10000
echo -ne $newbin" " >&2
#bins1000=$(awk '$3>=1000{sum++}END{print sum}' $coveragename)
bins1000=$(awk -v x=$newbin '{
      val[$1 " " int($2/x)*x]=val[$1 " " int($2/x)*x]+$3
    }
    END {
      for (i in val) {
        if (val[i] >= 1000) {
          count++
        }
     }
     print count
   }' $coveragename )
lowrange=0

# threshold is 80% of total bins
binstotal=$(( $total / $newbin ))
threshold=$(( $binstotal * 4 ))
threshold=$(( $threshold / 5 ))

# find reasonable range with big jumps
while [ $bins1000 -lt $threshold ]
do
    lowrange=$newbin
    newbin=$(( $newbin * 2 ))
    echo -ne $newbin" " >&2
    bins1000=$(awk -v x=$newbin '{ 
      val[$1 " " int($2/x)*x]=val[$1 " " int($2/x)*x]+$3
    }
    END { 
      for (i in val) { 
        if (val[i] >= 1000) {
          count++
        } 
     } 
     print count
   }' $coveragename )
    binstotal=$(( $total / $newbin ))
    threshold=$(( $binstotal * 4 ))
    threshold=$(( $threshold / 5 ))
done

# at this point, lowrange failed but newbin succeeded
# thus the map resolution is somewhere between (lowrange, newbin]
midpoint=$(( $newbin - $lowrange ))
midpoint=$(( $midpoint / 2 ))
midpoint=$(( $midpoint + $lowrange ))
# now make sure it's a factor of 50 (ceil)
midpoint=$(( $midpoint + 49 ))
midpoint=$(( $midpoint / 50 ))
midpoint=$(( $midpoint * 50 ))

# binary search
echo -ne "\nBinary search: " >&2
while [ $midpoint -lt $newbin ]
do
    echo -ne $midpoint" " >&2
    bins1000=$(awk -v x=$midpoint '{ 
      val[$1 " " int($2/x)*x]=val[$1 " " int($2/x)*x]+$3
    }
    END { 
      for (i in val) { 
        if (val[i] >= 1000) {
          count++
        } 
     } 
     print count
   }' $coveragename )
    binstotal=$(( $total / $midpoint ))
    threshold=$(( $binstotal * 4 ))
    threshold=$(( $threshold / 5 ))
    if [ $bins1000 -lt $threshold ]
    then
	lowrange=$midpoint;
	# at this point, lowrange failed but newbin succeeded
	midpoint=$(( $newbin - $lowrange ))
	midpoint=$(( $midpoint / 2 ))
	midpoint=$(( $midpoint + $lowrange ))
	# now make sure it's a factor of 50 (ceil)
	midpoint=$(( $midpoint + 49 ))
	midpoint=$(( $midpoint / 50 ))
	midpoint=$(( $midpoint * 50 ))
    else
	newbin=$midpoint;
	# at this point, lowrange failed but newbin succeeded
	midpoint=$(( $newbin - $lowrange ))
	midpoint=$(( $midpoint / 2 ))
	midpoint=$(( $midpoint + $lowrange ))
	# now make sure it's a factor of 50
	midpoint=$(( $midpoint + 49 ))
	midpoint=$(( $midpoint / 50 ))
	midpoint=$(( $midpoint * 50 ))
    fi
done

echo -e "\nThe map resolution is $newbin" >&2

echo $newbin > $(basename $1).res

