#!/bin/bash

#concatenate images using fslmerge
fslmerge -t ${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/INSERTLESIONHERE_merged_z_map.nii.gz ${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/Z_map/*

#get rid of any nan values
fslmaths ${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/INSERTLESIONHERE_merged_z_map.nii.gz -nan ${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/INSERTLESIONHERE_merged_z_map.nii.gz

#zip average time series files and zmap files once the cocatenated image has been produced
zmap_merged=${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/INSERTLESIONHERE_merged_z_map.nii.gz
if [ -f $zmap_merged ];then
    zip -rm ${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/Average_Time_Series.zip ${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/Average_Time_Series
    zip -rm ${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/Z_map.zip ${home_folder}/LNM_Home_${analysis_name}/Output/INSERTLESIONHERE/Z_map
fi
