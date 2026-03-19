#!/bin/bash

#SBATCH --time=20:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=5G  # memory per CPU core
#SBATCH -J "RunTwoSampleTtest"   # job name
EXPORTHERE

    #create matlab script for each lesion
    cache_folder=$home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6
    cp -r $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6/TwoSampleTTestTemplate.m ${cache_folder}/Edited_TwoSampleTTest.m
    newscript=$cache_folder/Edited_TwoSampleTTest.m


    MergedLesionNetwork1=$home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Merged_LesionNetworks.nii
    MergedLesionNetwork2=${LNM}/ISLES/ISLES_LesionNetworks_Merged_NoNan.nii
    FullOutputPath_Tmap=$home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap.nii
    FullOutputPath_Hmap=$home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Hmap.nii
    FullOutputPath_Pmap=$home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Pmap.nii

    cd $cache_folder

    sed -i 's|NETWORK1HERE|'"${MergedLesionNetwork1}"'|g' $newscript

    sed -i 's|NETWORK2HERE|'"${MergedLesionNetwork2}"'|g' $newscript
    
    sed -i 's|TMAPOUTPUT|'"${FullOutputPath_Tmap}"'|g' $newscript

    sed -i 's|HMAPOUTPUT|'"${FullOutputPath_Hmap}"'|g' $newscript

    sed -i 's|PMAPOUTPUT|'"${FullOutputPath_Pmap}"'|g' $newscript

    sed -i 's|INSERTMATLAB|'"${home_folder}/LNM_Home_${analysis_name}/cache/matlab_done/Step6"'|g' $newscript



sbatch BatchTwoSampleTTest.sh
