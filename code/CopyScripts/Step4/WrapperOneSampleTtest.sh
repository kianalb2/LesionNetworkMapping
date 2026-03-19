#!/bin/bash

#SBATCH --time=20:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=5G  # memory per CPU core
#SBATCH -J "Step4Wrapper"   # job name
EXPORTHERE

# make matlab done directory
mkdir $home_folder/LNM_Home_${analysis_name}/cache/matlab_done/Step4

#create scripts to run for each lesion and then submit those scripts!

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
    
    #create matlab script for each lesion
    cache_folder=$home_folder/LNM_Home_${analysis_name}/cache/scripts/${lesion}
    cp -r $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step4/OneSampleTtestTemplate.m ${cache_folder}

    #establish variables
    newscript=$cache_folder/OneSampleTtestTemplate.m
    FullHomeFolderPath=$home_folder/LNM_Home_${analysis_name}

    cd $cache_folder
    
    sed -i 's|INSERTLESIONNAMEHERE|'"${lesion}"'|g' $newscript

    sed -i 's|INSERTHOME_FOLDER|'"${FullHomeFolderPath}"'|g' $newscript

    sed -i 's|INSERTTEMPLATEIMAGEPATHWAYHERE|'"${TemplateImage}"'|g' $newscript

    #create job submission script for each lesion's matlab script
    cp -r $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step4/BatchOneSampleTtestTemplate.sh $cache_folder
    batchscript=$cache_folder/BatchOneSampleTtestTemplate.sh
    cd $cache_folder

    sed -i 's|INSERTLESIONNAMEHERE|'"${lesion}"'|g' $batchscript

    #submit the jobs
    cd $cache_folder
    step4jobid=`sbatch --parsable BatchOneSampleTtestTemplate.sh`
    date=`date`
    echo "The slurm job id below was submitted on $date" >> $home_folder/LNM_Home_${analysis_name}/cache/lists/step4_jobids.txt
    echo "$step4jobid" >> $home_folder/LNM_Home_${analysis_name}/cache/lists/step4_jobids.txt
    sleep 1s

done
