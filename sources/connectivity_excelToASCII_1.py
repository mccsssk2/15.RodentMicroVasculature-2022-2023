#!/usr/bin/env python
'''
-----
SRK. 23 July 2022.
This file takes the connectivity.xlsx and makes a connectivity.dat.
A python script to extract columns A to D from the excel files for the microvasculature.
As of 14th August 2022, there are at least 2 excel files - connectivity and blobs, that need to be converted into ascii.
Backup ~ files may need to be removed at commandline, unless you rename all connectivity excels
to something uniform.
'''

## Imports
import pandas as pd
import os
import xlrd
import glob
import sys

# read an excel file and convert into a dataframe object.
filename = sys.argv[1]
df = pd.DataFrame(pd.read_excel(filename, engine='openpyxl'))
  
# show the dataframe
# print(df)
#
# relevant table.
connTable = df.loc[1:,:]
connTable.to_csv("connectivity.dat", header=False, sep='\t');

