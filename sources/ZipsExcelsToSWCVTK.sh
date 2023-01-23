#!/bin/bash
#
# This shell script drives everything from the excels, zips to the SWC and vtk.
# This is step 1.
# count vessels in each zip file and store in a text file. Also extract the connectivity.
# Unzip and store in ROIs . The python converts the connectivity.xlsx to connectivity.dat
# assumption: A shell script has ran to rename the connectivity excels to a standard (connectivty.xlsx) name.
myswc2vtk=/Users/kharches/projects/barryJanssen2022/MicroVasc2022/May1st_2021_ratMicroVasc_Modelling_MacCopyImages/MelvinGabrielle2021/MelvinTaing2022Jan/microvascular_network_files_Melvin/srkSWC2VTK_pythonfiles
for d in ./*/ ; do (cp *.py "$d" && cp *.m "$d" && cp Makefile "$d" && cd "$d" && python3 connectivity_excelToASCII_1.py connectivity.xlsx && python3  blobsexcelToAscii.py && rm *.py && zipinfo -1 *.zip > vesselsInSequence.dat && unzip *.zip && rm -rf ROIs && mkdir ROIs && mv *.roi ROIs && make && rm Makefile && rm -rf ROIs && python3 $myswc2vtk/srkMouse_swc2vtk.py microVasc.swc); done
#

