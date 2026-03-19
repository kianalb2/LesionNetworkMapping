#!/bin/bash

#SBATCH --time=20:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=5G  # memory per CPU core
#SBATCH -J "Step2Wrapper"   # job name
EXPORTHERE

# make matlab done file directories
mkdir $home_folder/LNM_Home_${analysis_name}/cache/matlab_done
mkdir $home_folder/LNM_Home_${analysis_name}/cache/matlab_done/Step2

#create scripts to run for each lesion and then submit those scripts!

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
    
    #create matlab script for each lesion
    cache_folder=$home_folder/LNM_Home_${analysis_name}/cache/scripts/${lesion}
    cp -r $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step2/FuncConnTemplate.m ${cache_folder}
    newscript=$cache_folder/FuncConnTemplate.m

    #copy list of resting state scans as well into cache (this is a test to see if necessary, not sure why jobs are failing in parallel while only 4 or 5 are completing. A part of me thinks it is a problem with reading from the same file to iterate through for loop. So I am trying this. I already tried separating job submissions by 10 minutes, but that did not work.)

    cp -r $LNM/Other/GSP1000_list.xlsx ${cache_folder}
    new_list=$cache_folder/GSP1000_list.xlsx


    LesionTimeSeriesFolder=$home_folder/LNM_Home_${analysis_name}/Output/${lesion}/Average_Time_Series
    FullHomeFolderPath=$home_folder/LNM_Home_${analysis_name}

    cd $cache_folder

    sed -i 's|INSERTDATAPATHWAYHERE|'"${data}"'|g' $newscript

    sed -i 's|INSERTLESIONTIMESERIESFOLDERHERE|'"${LesionTimeSeriesFolder}"'|g' $newscript
    
    sed -i 's|INSERTLESIONNAMEHERE|'"${lesion}"'|g' $newscript

    sed -i 's|INSERTHOME_FOLDER|'"${FullHomeFolderPath}"'|g' $newscript

    sed -i 's|INSERTTEMPLATEIMAGEPATHWAYHERE|'"${TemplateImage}"'|g' $newscript

    sed -i 's|INSERTANALYSISNAMEHERE|'"${analysis_name}"'|g' $newscript

    sed -i 's|INSERTLISTHERE|'"${new_list}"'|g' $newscript

    #create job submission script for each lesion's matlab script
    cp -r $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step2/BatchFuncConnTemplate.sh $cache_folder
    batchscript=$cache_folder/BatchFuncConnTemplate.sh
    cd $cache_folder

    sed -i 's|INSERTLESIONHERE|'"${lesion}"'|g' $batchscript

    #submit the jobs
    cd $cache_folder
    step2jobid=`sbatch --parsable BatchFuncConnTemplate.sh`
    date=`date`
    echo "The slurm job id below was submitted on $date" >> $home_folder/LNM_Home_${analysis_name}/cache/lists/step2_jobids.txt
    echo "$step2jobid" >> $home_folder/LNM_Home_${analysis_name}/cache/lists/step2_jobids.txt
    sleep 1s

done
