#!/usr/bin/env python
'''
-----
SRK. 15 August 2022.
This file converts the blobs.xlsx to blobs.dat
'''

## Imports
import pandas as pd
import os
import xlrd
import glob

# read an excel file and convert into a dataframe object.
# df = pd.DataFrame(pd.read_excel('blobs.xlsx', engine='openpyxl'))
  
# show the dataframe
# print(df)
#
file_loc = "blobs.xlsx"
# Python assumes row 1 of excel is always a header.
df = pd.read_excel(file_loc, index_col=None, na_values=['NA'], header=None, usecols = "A")
# print(df)
df.to_csv("blobs.dat", header=False, sep='\t');
