#!/bin/bash

#SBATCH --time=50:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --partition=m9
EXPORTHERE
#SBATCH --mem-per-cpu=100G  # memory per CPU core
#SBATCH -J "INSERTLESIONHERE_FuncConn"   # job name



# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

cd $home_folder/LNM_Home_${analysis_name}/cache/scripts/INSERTLESIONHERE

module load matlab

matlab -nodisplay -nodesktop -nosplash -r FuncConnTemplate



