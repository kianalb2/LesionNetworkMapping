#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G  # memory per CPU core
#SBATCH -J "ExtractLesionNetworks"   # job name
EXPORTHERE

#create directories
mkdir $home_folder/LNM_Home_${analysis_name}/Output/LesionNetworks 
mkdir $home_folder/LNM_Home_${analysis_name}/Output/LesionNetworks_bin


#Extract t_maps of all lesions
for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
cp $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}t_map.nii $home_folder/LNM_Home_${analysis_name}/Output/LesionNetworks/
done

#Extract binarized t_maps of all lesions
for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
cp $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}thresh_bin_t_map.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/LesionNetworks_bin/
done