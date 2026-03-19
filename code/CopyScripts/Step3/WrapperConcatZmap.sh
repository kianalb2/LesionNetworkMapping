#!/bin/bash

#SBATCH --time=5:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=5G  # memory per CPU core
#SBATCH -J "Step3Wrapper"   # job name
EXPORTHERE


#source ~/fsl_groups/fslg_lnm/compute/LesionNetworkMapping/Scripts/MasterConfiguration.sh

#create scripts to run for each lesion and then submit those scripts!

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do

    #create directories for each lesion if not already created and create bash scripts for each lesion
    cache_folder=$home_folder/LNM_Home_${analysis_name}/cache/scripts/${lesion}
    cp -r $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step3/ConcatZmapTemplate.sh ${cache_folder}
    newscript=${cache_folder}/ConcatZmapTemplate.sh
    cd ${cache_folder}

    sed -i 's|INSERTLESIONHERE|'"${lesion}"'|g' $newscript

    #create job submission script for each lesion
    cp -r $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step3/BatchConcatZmapTemplate.sh ${cache_folder}
    batchscript=${cache_folder}/BatchConcatZmapTemplate.sh
    cd ${cache_folder}

    sed -i 's|INSERTLESIONHERE|'"${lesion}"'|g' $batchscript

    #submit the jobs
    cd ${cache_folder}
    step3jobid=`sbatch --parsable BatchConcatZmapTemplate.sh`
    date=`date`
    echo "The slurm job id below was submitted on $date" >> $home_folder/LNM_Home_${analysis_name}/cache/lists/step3_jobids.txt
    echo "$step3jobid" >> $home_folder/LNM_Home_${analysis_name}/cache/lists/step3_jobids.txt

    sleep 1s 

done