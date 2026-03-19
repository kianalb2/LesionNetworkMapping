#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --partition=m9
#SBATCH --mem-per-cpu=60G  # memory per CPU core
#SBATCH -J "TwoSampleTtest"   # job name
EXPORTHERE

output_file="$home_folder/LNM_Home_${analysis_name}/Output/


for file in "$home_folder/LNM_Home_${analysis_name}/Output/LesionNetworks_bin/"; do
    overlap_percentage=$(fslstats "$file" -k "$output_file" -V | awk '{printf "%.2f", $1 / $2 * 100}')
