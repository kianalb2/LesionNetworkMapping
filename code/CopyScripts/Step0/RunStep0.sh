#!/bin/bash

## Export variables (Definitely update)
export analysis_name=OpticAtaxiaOnly
export lesion_folder=/grphome/grp_lnm/nobackup/autodelete/LesionBank/OpticAtaxiaOnly

## Export variables (Might need to change)
export LNM=/grphome/fslg_lnm/nobackup/archive/analysis_updated
export home_folder=/grphome/grp_lnm/nobackup/autodelete/Results

## Export variables (DON'T CHANGE)
export data=/grphome/fslg_lnm/nobackup/archive/HumanConnectome/GSP1000
export TemplateImage=/grphome/grp_lnm/nobackup/autodelete/inputs/Template/template_images0000.nii

###############################################
########### Lesion Network Mapping ############
########### Brigham Young University ##########
############## Elijah C. Baughan ##############
############# elibaughan@gmail.com ############
###############################################
#Overview
#Step_0: Create directories and scripts
#Step_1: Extraction of Average BOLD Signal using fslmeants
#Step_2: Calculate Correlation
#Step_3: Concatenate Z score maps
#Step_4: Perform one sample t-test for each voxel across Z score maps
#Step_5: Add individual lesion network maps

#Make sure to update the contents of #SBATCH --export= accordingly

#Make sure to set this variable to `less configuration.txt`
export_configuration=`less /grphome/grp_lnm/nobackup/autodelete/code/ConfigurationFiles/SimultanagnosiaOnly.txt`
#Run step 0 before running the "RunAllBatch.sh" script!

###This script only runs Step 0###


echo "Beginning Step 0: Create directories and scripts"


#create home folder and following three folders
mkdir -p ${home_folder}/LNM_Home_${analysis_name}/{Output,cache/{lists,scripts}}

home_dir=${home_folder}/LNM_Home_${analysis_name}

echo "Home directory has been created"

#create a text file with a list of the lesions

for lesion in `ls ${lesion_folder}`; do
    cd ${home_dir}/cache/lists
    suffix=".nii"
    lesion=${lesion%$suffix}
    echo $lesion>>lesion_list.txt
done

echo "Lesion list has been created"

lesion_list=${home_dir}/cache/lists/lesion_list.txt


#create Output and cache folders folders
for lesion in `cat ${lesion_list}`; do
    mkdir -p ${home_dir}/Output/${lesion}/{Average_Time_Series,Z_map}
    mkdir -p ${home_dir}/cache/scripts/${lesion}
done

echo "Output and cache folders have been created"

#create COCKPIT scripts to run pipeline
mkdir -p ${home_dir}/cache/scripts/COCKPIT

#create pipeline scripts

cp ${LNM}/CopyScripts/RunAllBatch.sh ${home_dir}/cache/scripts/COCKPIT
New_RunAllBatch=${home_dir}/cache/scripts/COCKPIT/RunAllBatch.sh
cd ${home_dir}/cache/scripts/COCKPIT
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_RunAllBatch

cp -r ${LNM}/CopyScripts/Step1 ${home_dir}/cache/scripts/COCKPIT
New_WrapperFSLMeants=${home_dir}/cache/scripts/COCKPIT/Step1/WrapperFSLMeants.sh
New_BatchFSLMeants=${home_dir}/cache/scripts/COCKPIT/Step1/BatchFSLMeants.sh
cd ${home_dir}/cache/scripts/COCKPIT/Step1
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_WrapperFSLMeants
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_BatchFSLMeants

cp -r ${LNM}/CopyScripts/Step2 ${home_dir}/cache/scripts/COCKPIT
New_WrapperFuncConn=${home_dir}/cache/scripts/COCKPIT/Step2/WrapperFuncConn.sh
New_BatchFuncConnTemplate=${home_dir}/cache/scripts/COCKPIT/Step2/BatchFuncConnTemplate.sh
cd ${home_dir}/cache/scripts/COCKPIT/Step2
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_WrapperFuncConn
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_BatchFuncConnTemplate

cp -r ${LNM}/CopyScripts/Step3 ${home_dir}/cache/scripts/COCKPIT
New_WrapperConcatZmap=${home_dir}/cache/scripts/COCKPIT/Step3/WrapperConcatZmap.sh
New_BatchConcatZmapTemplate=${home_dir}/cache/scripts/COCKPIT/Step3/BatchConcatZmapTemplate.sh
cd ${home_dir}/cache/scripts/COCKPIT/Step3
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_WrapperConcatZmap
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_BatchConcatZmapTemplate


cp -r ${LNM}/CopyScripts/Step4 ${home_dir}/cache/scripts/COCKPIT
New_WrapperOneSampleTtest=${home_dir}/cache/scripts/COCKPIT/Step4/WrapperOneSampleTtest.sh
New_BatchOneSampleTtestTemplate=${home_dir}/cache/scripts/COCKPIT/Step4/BatchOneSampleTtestTemplate.sh
cd ${home_dir}/cache/scripts/COCKPIT/Step4
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_WrapperOneSampleTtest
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_BatchOneSampleTtestTemplate

cp -r ${LNM}/CopyScripts/Step5 ${home_dir}/cache/scripts/COCKPIT
New_WrapperAdd=${home_dir}/cache/scripts/COCKPIT/Step5/AddLesionNetworks.sh
cd ${home_dir}/cache/scripts/COCKPIT/Step5
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_WrapperAdd

New_WrapperAdd_Lesion=${home_dir}/cache/scripts/COCKPIT/Step5/AddLesions.sh
cd ${home_dir}/cache/scripts/COCKPIT/Step5
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_WrapperAdd_Lesion

cp -r ${LNM}/CopyScripts/Step6 ${home_dir}/cache/scripts/COCKPIT
New_TwoSampleTTestNew=${home_dir}/cache/scripts/COCKPIT/Step6/RunTwoSampleTTest.sh
New_MergeLesionNetworksNew=${home_dir}/cache/scripts/COCKPIT/Step6/MergeLesionNetworks.sh
New_MaskSpecificityNew=${home_dir}/cache/scripts/COCKPIT/Step6/MaskSpecificityMap.sh
New_BatchTwoSampleTTestNew=${home_dir}/cache/scripts/COCKPIT/Step6/BatchTwoSampleTTest.sh
New_ConjunctionMapNew=${home_dir}/cache/scripts/COCKPIT/Step6/ConjunctionMap.sh
New_WrapperStep6New=${home_dir}/cache/scripts/COCKPIT/Step6/WrapperStep6.sh
New_ExtractFiles=${home_dir}/cache/scripts/COCKPIT/Step6/ExtractFiles.sh
New_ExtractLesionNetworks=${home_dir}/cache/scripts/COCKPIT/Step6/ExtractLesionNetworks.sh


cd ${home_dir}/cache/scripts/COCKPIT/Step6
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_TwoSampleTTestNew
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_MergeLesionNetworksNew
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_MaskSpecificityNew
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_BatchTwoSampleTTestNew
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_ConjunctionMapNew
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_WrapperStep6New
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_ExtractFiles
sed -i 's|EXPORTHERE|'"${export_configuration}"'|g' $New_ExtractLesionNetworks
