#!/bin/bash

#SBATCH --time=1:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=20G  # memory per CPU core
#SBATCH -J "AddLesionNetworks"   # job name
EXPORTHERE



#Step 5#
#Threshold, Binarize, and add


#######################
#positive correlations#
#######################

#remove any nan values, threshold to 4.7, and binarize 
for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}t_map.nii -nan -thr 4.7 -bin $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}thresh_bin_t_map.nii
done

#add lesion networks from each case together (#t statistic maps)
echo "fslmaths \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/add.sh
lastlesion=`tail -n 1 $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`
for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
    if [ "$lesion" != "$lastlesion" ]; then
        echo "$home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}thresh_bin_t_map.nii.gz -add \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/add.sh
    else
        echo "$home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}thresh_bin_t_map.nii.gz \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/add.sh
    fi
done
echo "$home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map.nii" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/add.sh 

bash $home_folder/LNM_Home_${analysis_name}/cache/scripts/add.sh

fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map.nii -mas $FSLDIR/data/standard/MNI152_T1_2mm_brain_mask.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked.nii

#######################
#negative correlations#
#######################

#remove any nan values, threshold to -4.7, and binarize 
for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}t_map.nii -nan -uthr -4.7 -abs -bin $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}thresh_bin_t_map_neg.nii
done

#add lesion networks from each case together (#t statistic maps)
echo "fslmaths \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/add_neg.sh
lastlesion=`tail -n 1 $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`
for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
    if [ "$lesion" != "$lastlesion" ]; then
        echo "$home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}thresh_bin_t_map_neg.nii.gz -add \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/add_neg.sh
    else
        echo "$home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}thresh_bin_t_map_neg.nii.gz \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/add_neg.sh
    fi
done
echo "$home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map.nii" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/add_neg.sh

bash $home_folder/LNM_Home_${analysis_name}/cache/scripts/add_neg.sh

fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map.nii -mas $FSLDIR/data/standard/MNI152_T1_2mm_brain_mask.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked.nii

