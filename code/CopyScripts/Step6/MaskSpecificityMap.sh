#!/bin/bash

#SBATCH --time=0:05:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=1G  # memory per CPU core
#SBATCH -J "MaskSpecificity"   # job name
EXPORTHERE


fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap.nii -mas ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap_masked.nii


fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Hmap.nii -mas ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Hmap_masked.nii


fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Pmap.nii -mas ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Pmap_masked.nii


fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map.nii.gz -mas ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked.nii.gz


fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map.nii.gz -mas ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked.nii.gz


