#!/bin/bash

#SBATCH --time=80:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G  # memory per CPU core
EXPORTHERE
#SBATCH -J "BatchRunAllSteps"   # job name



# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

#Overview
#Step_0: Create directories and scripts
#Step_1: Extraction of Average BOLD Signal using fslmeants
#Step_2: Calculate Correlation
#Step_3: Concatenate
#Step_4: One sample t test
#Step_5: Add individual lesion network maps

#make sure you have run step_0!

###STEP 1
sbatch $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step1/WrapperFSLMeants.sh
sleep 2m

Step1_Finished_ID=`tail -n 1 $home_folder/LNM_Home_${analysis_name}/cache/lists/step1_jobids.txt`

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`;do
    until [ -f $home_folder/LNM_Home_${analysis_name}/Output/$lesion/Average_Time_Series/sub-1570_bld001_rest_skip4_stc_mc_bp_0.0001_0.08_resid_FS1mm_MNI1mm_MNI2mm_sm7_finalmask.nii_${lesion}.txt ]
    date=`date`
    do echo "$lesion is still on Step 1 $date" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/ProgressReport.txt
    sleep 30s
    done 
    echo "$lesion is DONE with Step 1 $date" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/ProgressReport.txt
done



#run step 2
sbatch --dependency=afterok:$Step1_Finished_ID $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step2/WrapperFuncConn.sh
sleep 2m
Step2_Finished_ID=`tail -n 1 $home_folder/LNM_Home_${analysis_name}/cache/lists/step2_jobids.txt`

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`;do
    until [ -f $home_folder/LNM_Home_${analysis_name}/Output/$lesion/Z_map/sub-1570_bld001_rest_skip4_stc_mc_bp_0.0001_0.08_resid_FS1mm_MNI1mm_MNI2mm_sm7_finalmask.nii_z_map.nii ]
    date=`date`
    do echo "$lesion is still on Step 2 $date" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/ProgressReport.txt
    sleep 30s
    done 
    echo "$lesion is DONE with Step 2 $date" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/ProgressReport.txt
done

# Wait for all MATLAB scripts to finish by checking for the correct number of "done" files
done_count=0
num_iterations=$(wc -l < $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt)
while [ $done_count -lt $num_iterations ]; do
    done_count=$(ls $home_folder/LNM_Home_${analysis_name}/cache/matlab_done/Step2/FuncConn_done_*.txt 2>/dev/null | wc -l)
    echo "Waiting for all MATLAB scripts to complete... ($done_count/$num_iterations)"
    sleep 30  # Check every 30 seconds
done

sleep 1m

#run step 3
sbatch $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step3/WrapperConcatZmap.sh
sleep 2m
Step3_Finished_ID=`tail -n 1 $home_folder/LNM_Home_${analysis_name}/cache/lists/step3_jobids.txt`

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`;do
    until [ -f $home_folder/LNM_Home_${analysis_name}/Output/$lesion/Z_map.zip ]
    date=`date`
    do echo "$lesion is still on Step 3 $date" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/ProgressReport.txt
    sleep 5m
    done 
    echo "$lesion is DONE with Step 3 $date" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/ProgressReport.txt
done

#run step 4
sbatch --dependency=afterok:$Step3_Finished_ID $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step4/WrapperOneSampleTtest.sh
sleep 2m

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`;do
    until [ -f $home_folder/LNM_Home_${analysis_name}/Output/$lesion/${lesion}t_map.nii ]
    date=`date`
    do echo "$lesion is still on Step 4 $date" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/ProgressReport.txt
    sleep 30s
    done 
    echo "$lesion is DONE with Step 4 $date" >> $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/ProgressReport.txt
done

Step4_Finished_ID=`tail -n 1 $home_folder/LNM_Home_${analysis_name}/cache/lists/step4_jobids.txt`

# Wait for all MATLAB scripts to finish by checking for the correct number of "done" files
done_count2=0
while [ $done_count2 -lt $num_iterations ]; do
    done_count2=$(ls $home_folder/LNM_Home_${analysis_name}/cache/matlab_done/Step4/OneSampleTTest_done_*.txt 2>/dev/null | wc -l)
    echo "Waiting for all MATLAB scripts to complete... ($done_count2/$num_iterations)"
    sleep 30  # Check every 30 seconds
done

#run step 5 
sbatch  $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step5/AddLesionNetworks.sh
sbatch  $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step5/AddLesions.sh

# Wait for the Step 5 output to finish before proceeding
# Define step 5 output files
output_folder="${home_folder}/LNM_Home_${analysis_name}/Output"
files=(
    "${output_folder}/${analysis_name}_Combined_Lesions.nii.gz"
    "${output_folder}/${analysis_name}_neg_sensitivity_map_masked.nii.gz"
    "${output_folder}/${analysis_name}_neg_sensitivity_map.nii.gz"
    "${output_folder}/${analysis_name}_pos_sensitivity_map_masked.nii.gz"
    "${output_folder}/${analysis_name}_pos_sensitivity_map.nii.gz"
)

# Set a maximum number of attempts and the interval between checks
max_attempts=120  # 120 checks with 30-second intervals = up to 60 minutes (1 hour)
interval=30  # 30 seconds between checks

# Wait for all files to exist from step 5 output
attempts=0
while true; do
    all_exist=true
    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            all_exist=false
            break
        fi
    done

    if $all_exist; then
        echo "All output files from step 5 found. Proceeding..."
        break
    fi

    # Increment attempts and check if maximum reached
    attempts=$((attempts + 1))
    if [ $attempts -ge $max_attempts ]; then
        echo "Maximum attempts reached, some files not found."
        exit 1
    fi

    # Wait before checking again
    echo "Waiting for step 5 files... Attempt $attempts of $max_attempts."
    sleep $interval
done


# Submit Step 6
sbatch $home_folder/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step6/WrapperStep6.sh




