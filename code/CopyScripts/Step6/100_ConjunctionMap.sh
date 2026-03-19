#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G  # memory per CPU core
#SBATCH -J "Conjunction Map"   # job name
EXPORTHERE

# Run this script after generating all other results, in the case that you want to create 100% conjunction maps

#find the max value of the sensitivity maps to be used in making the threshold
max_value_pos=$(fslstats $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked_nonan.nii.gz -R | awk '{print $2}')
max_value_neg=$(fslstats $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked_nonan.nii.gz -R | awk '{print $2}')

#find the total number of cases
filenumber=$(find "$lesion_folder" -maxdepth 1 -type f | wc -l)

#create multiple thresholded sensitivity maps based on the max values
# 100%
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked_nonan.nii.gz -thr $(bc <<< "1.00 * $max_value_pos") $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Positive/${analysis_name}_pos_sensitivity_100.nii.gz
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked_nonan.nii.gz -thr $(bc <<< "1.00 * $max_value_neg") $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Negative/${analysis_name}_neg_sensitivity_100.nii.gz

## Loop through to binarize each of these files
# Specify the folder path
folder_path="$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles"

# Loop through positive sensitivity files in the folder
for file in "$folder_path"/Positive/*.nii.gz; do
    if [ -f "$file" ]; then
        # Extract file name without extension
        file_name=$(basename "$file" .nii.gz)

        # Define output file path for the binarized image
        output_file="${folder_path}/Binarized/Positive/${file_name}_bin.nii.gz"

        # Binarize the current file using fslmaths
        fslmaths "$file" -bin "$output_file"

    fi
done

# Loop through negative sensitivity files
for file in "$folder_path"/Negative/*.nii.gz; do
    if [ -f "$file" ]; then
        # Extract file name without extension
        file_name=$(basename "$file" .nii.gz)

        # Define output file path for the binarized image
        output_file="${folder_path}/Binarized/Negative/${file_name}_bin.nii.gz"

        # Binarize the current file using fslmaths
        fslmaths "$file" -bin "$output_file"

    fi
done


# Specify the main directory path
main_dir_conj="$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles"


# Loop through Positive sensitivity files and combine each with the specificity file
 # Loop through Positive sensitivity files and combine each with the specificity file
for pos_sensitivity_file in "$main_dir_conj"/Binarized/Positive/*100*.nii.gz; do
    if [ -f "$pos_sensitivity_file" ]; then

        # Extract the last two characters from the file name without extension
        filename=$(basename -- "$pos_sensitivity_file" | cut -f 1 -d '.')

        last_three_chars="${filename: -7:3}"

        # Define output file path for the combined image
        output_file="$home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_${last_three_chars}_pos_conjunction.nii.gz"


        # Combine the PosSpecificity file with the corresponding sensitivity file using fslmaths
        fslmaths "$pos_sensitivity_file" -add $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_pos_specificity_bin.nii.gz -thr 1.9 "$output_file"

    fi
done

 # Loop through Negative sensitivity files and combine each with the specificity file
for neg_sensitivity_file in "$main_dir_conj"/Binarized/Negative/*100*.nii.gz; do
    if [ -f "$neg_sensitivity_file" ]; then

        # Extract the last two characters from the file name without extension
        filename=$(basename -- "$neg_sensitivity_file" | cut -f 1 -d '.')

        last_three_chars="${filename: -7:3}"

        # Define output file path for the combined image
        output_file="$home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_${last_three_chars}_neg_conjunction.nii.gz"


        # Combine the PosSpecificity file with the corresponding sensitivity file using fslmaths
        fslmaths "$neg_sensitivity_file" -add $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_neg_specificity_abs_bin.nii.gz -thr 1.9 "$output_file"

    fi
done


