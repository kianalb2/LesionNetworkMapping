#!/bin/bash

#SBATCH --time=03:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes 
#SBATCH --mem-per-cpu=40G  # memory per CPU core
EXPORTHERE
#SBATCH -J "INSERTLESIONHERE_concetenate_z_map"   # job name



# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE


#source ~/fsl_groups/fslg_lnm/compute/LesionNetworkMapping/Scripts/MasterConfiguration.sh


cd $home_folder/LNM_Home_${analysis_name}/cache/scripts/INSERTLESIONHERE

bash ConcatZmapTemplate.sh
