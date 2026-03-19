#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --partition=m9
#SBATCH --mem-per-cpu=60G  # memory per CPU core
#SBATCH -J "TwoSampleTtest"   # job name
EXPORTHERE


# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

cd $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6

module load matlab

matlab -nodisplay -nodesktop -nosplash -r Edited_TwoSampleTTest
