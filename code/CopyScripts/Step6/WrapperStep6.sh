#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --partition=m9
#SBATCH --mem-per-cpu=60G  # memory per CPU core
#SBATCH -J "WrapperStep6"   # job name
EXPORTHERE

# Submit MergeLesionNetworks.sh and store its job ID in job6A_id
job6A_id=$(sbatch --parsable $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6/MergeLesionNetworks.sh)

# sbatch $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6/MergeLesionNetworks.sh

# Submit RunTwoSampleTTest.sh with dependency on MergeLesionNetworks.sh
job6B_id=$(sbatch --parsable --dependency=afterok:$job6A_id $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6/RunTwoSampleTTest.sh)


# create directory for matlab done files
mkdir $home_folder/LNM_Home_${analysis_name}/cache/matlab_done/Step6

#Wait for the MATLAB script to finish
while [ ! -f "$home_folder/LNM_Home_${analysis_name}/cache/matlab_done/Step6/step6_complete.txt" ]; do
  echo "Waiting for step6_complete.txt to be created..."
  sleep 10  # Wait for 10 seconds before checking again
done

# Submit MaskSpecificityMap.sh with dependency on RunTwoSampleTTest.sh
job6C_id=$(sbatch --parsable $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6/MaskSpecificityMap.sh)

# Submit ConjunctionMap.sh with dependency on MaskSpecificityMap.sh
sbatch --dependency=afterok:$job6C_id $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6/ConjunctionMap.sh
