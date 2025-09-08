#!/bin/bash


# Loop through output files from 0 to 4
for i in {0..4}; do
    filename="output_${i}.log"
    
    echo "---------------" >> results.txt
    echo "${filename} results" >> results.txt
    echo "---------------" >> results.txt
    echo "" >> results.txt
    
    # Run the three grep commands
    grep -A 5 "(nx, ny, nz)" "$filename" >> results.txt
    
    grep -A 5 "PCG Setup:" "$filename" >> results.txt
    
    grep -A 5 "PCG Solve:" "$filename" >> results.txt
done
