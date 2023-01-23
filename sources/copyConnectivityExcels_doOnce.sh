#!/bin/bash
#
# This ran once, dont do again.
# Copy each connectivity excel to something standard, connectivity.xlsx
for d in ./*/ ; do (cd "$d" && cp *fov*.xlsx connectivity.xlsx); done
