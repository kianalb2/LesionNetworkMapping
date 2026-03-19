#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G  # memory per CPU core
#SBATCH -J "ExtractFiles"   # job name
EXPORTHERE

mkdir $home_folder/LNM_Home_${analysis_name}/Output/ProjectPackage
mkdir $home_folder/LNM_Home_${analysis_name}/Output/ProjectPackage/LesionNetworks
mkdir $home_folder/LNM_Home_${analysis_name}/Output/ProjectPackage/LesionTraces



for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
    cp $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}t_map.nii $home_folder/LNM_Home_${analysis_name}/Output/ProjectPackage/LesionNetworks/

done



cp -r $lesion_folder/* $home_folder/LNM_Home_${analysis_name}/Output/ProjectPackage/LesionTraces/

cp -r $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/ $home_folder/LNM_Home_${analysis_name}/Output/ProjectPackage/

cp $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap.nii $home_folder/LNM_Home_${analysis_name}/Output/ProjectPackage/FinalResults

