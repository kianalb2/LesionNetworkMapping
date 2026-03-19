#!/bin/bash

#SBATCH --time=5:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=60G  # memory per CPU core
#SBATCH -J "Step1Wrapper"   # job name
EXPORTHERE

#create average lesion time series for dataset

for lesion in `cat $home_folder/LNM_Home_${analysis_name}/cache/lists/lesion_list.txt`; do
step1jobid=`sbatch --parsable ${home_folder}/LNM_Home_${analysis_name}/cache/scripts/COCKPIT/Step1/BatchFSLMeants.sh $lesion`
date=`date`
echo -e "The slurm job id below was submitted on $date\n$step1jobid" >> $home_folder/LNM_Home_${analysis_name}/cache/lists/step1_jobids.txt
sleep 1
done
