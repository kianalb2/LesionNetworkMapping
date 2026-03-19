#!/bin/bash

#SBATCH --time=1:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G  # memory per CPU core
#SBATCH -J "AddLesions"   # job name
EXPORTHERE


#Add lesion tracings into one nifti

#add lesion networks from each case together (#t statistic maps)
echo "fslmaths \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/addlesions.sh
lastlesion=`tail -n 1 $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`
for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
    if [ "$lesion" != "$lastlesion" ]; then
        echo "${lesion_folder}/${lesion}.nii -add \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/addlesions.sh
    else
        echo "${lesion_folder}/${lesion}.nii \\" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/addlesions.sh
    fi
done
echo "$home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Combined_Lesions.nii" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/addlesions.sh 

bash $home_folder/LNM_Home_${analysis_name}/cache/scripts/addlesions.sh
