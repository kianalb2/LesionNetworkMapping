#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G  # memory per CPU core
#SBATCH -J "MergeLesionNetworks"   # job name
EXPORTHERE

#clear this so it doesn't just keep adding to it. 
rm $home_folder/LNM_Home_${analysis_name}/cache/scripts/merge.sh

#remove any nan values
for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}t_map.nii -nan $home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}_nonan_t_map.nii
done

#add lesion networks from each case together (#t statistic maps)
echo "fslmerge -t $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Merged_LesionNetworks.nii \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/merge.sh
lastlesion=`tail -n 1 $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
    if [ "$lesion" != "$lastlesion" ]; then
        echo "$home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}_nonan_t_map.nii.gz \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/merge.sh
    else
        echo "$home_folder/LNM_Home_${analysis_name}/Output/${lesion}/${lesion}_nonan_t_map.nii.gz" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/merge.sh
    fi
done

bash $home_folder/LNM_Home_${analysis_name}/cache/scripts/merge.sh

#remove any nan values
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Merged_LesionNetworks.nii -nan $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Merged_LesionNetworks.nii

#decompress the .nii.gz file to just .nii because spm will only work with .nii
gzip -d $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Merged_LesionNetworks.nii.gz

