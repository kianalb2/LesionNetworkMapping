#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G  # memory per CPU core
#SBATCH -J "Conjunction Map"   # job name
EXPORTHERE


if [ ! -d "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles" ]; then
    mkdir -p "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles"
fi

if [ ! -d "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Positive" ]; then
    mkdir -p "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Positive"
fi

if [ ! -d "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Negative" ]; then
    mkdir -p "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Negative"
fi

if [ ! -d "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Binarized" ]; then
    mkdir -p "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Binarized"
fi

if [ ! -d "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Binarized/Positive" ]; then
    mkdir -p "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Binarized/Positive"
fi

if [ ! -d "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Binarized/Negative" ]; then
    mkdir -p "$home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Binarized/Negative"
fi

if [ ! -d "$home_folder/LNM_Home_${analysis_name}/Output/FinalResults" ]; then
    mkdir -p "$home_folder/LNM_Home_${analysis_name}/Output/FinalResults"
fi


# remove nan values in sensitivity maps
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked.nii.gz -nan $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked_nonan.nii.gz
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked.nii.gz -nan $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked_nonan.nii.gz

#remove nan values in specificity map
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap_masked.nii.gz -nan $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap_masked_nonan.nii.gz

#threshold the specificity map to create positive and negative versions
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap_masked_nonan.nii.gz -thr 4.7 $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/${analysis_name}_pos_specificity.nii.gz
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap_masked_nonan.nii.gz -uthr -4.7 $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/${analysis_name}_neg_specificity.nii.gz

#take the absolute value of the negative thresholded tmap (i am not exactly why this is necessary but it wont do the next step with negative values)
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/${analysis_name}_neg_specificity.nii.gz -abs $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/${analysis_name}_neg_specificity_abs.nii.gz

#binarize the specificity maps
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/${analysis_name}_pos_specificity.nii.gz -bin $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_pos_specificity_bin.nii.gz
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/${analysis_name}_neg_specificity_abs.nii.gz -bin $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_neg_specificity_abs_bin.nii.gz

#find the max value of the sensitivity maps to be used in making the threshold
max_value_pos=$(fslstats $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked_nonan.nii.gz -R | awk '{print $2}')
max_value_neg=$(fslstats $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked_nonan.nii.gz -R | awk '{print $2}')

#find the total number of cases
filenumber=$(find "$lesion_folder" -maxdepth 1 -type f | wc -l)

#create multiple thresholded sensitivity maps based on the max values
# 95%
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked_nonan.nii.gz -thr $(bc <<< "0.95 * $max_value_pos") $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Positive/${analysis_name}_pos_sensitivity_95.nii.gz
# The variable originally said "$max_value_pos again in this line of code, I changed it 250310
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked_nonan.nii.gz -thr $(bc <<< "0.95 * $max_value_neg") $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Negative/${analysis_name}_neg_sensitivity_95.nii.gz

# 75%
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked_nonan.nii.gz -thr $(bc <<< "0.75 * $max_value_pos") $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Positive/${analysis_name}_pos_sensitivity_75.nii.gz
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked_nonan.nii.gz -thr $(bc <<< "0.75 * $max_value_neg") $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Negative/${analysis_name}_neg_sensitivity_75.nii.gz

# 50%
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked_nonan.nii.gz -thr $(bc <<< "0.5 * $max_value_pos") $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Positive/${analysis_name}_pos_sensitivity_50.nii.gz
fslmaths $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked_nonan.nii.gz -thr $(bc <<< "0.5 * $max_value_neg") $home_folder/LNM_Home_${analysis_name}/Output/ConjunctionFiles/Negative/${analysis_name}_neg_sensitivity_50.nii.gz

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
for pos_sensitivity_file in "$main_dir_conj"/Binarized/Positive/*.nii.gz; do
    if [ -f "$pos_sensitivity_file" ]; then

        # Extract the last two characters from the file name without extension
        filename=$(basename -- "$pos_sensitivity_file" | cut -f 1 -d '.')

        last_two_chars="${filename: -6:2}"

        # Define output file path for the combined image
        output_file="$home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_${last_two_chars}_pos_conjunction.nii.gz"


        # Combine the PosSpecificity file with the corresponding sensitivity file using fslmaths
        fslmaths "$pos_sensitivity_file" -add $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_pos_specificity_bin.nii.gz -thr 1.9 "$output_file"

    fi
done

 # Loop through Negative sensitivity files and combine each with the specificity file
for neg_sensitivity_file in "$main_dir_conj"/Binarized/Negative/*.nii.gz; do
    if [ -f "$neg_sensitivity_file" ]; then

        # Extract the last two characters from the file name without extension
        filename=$(basename -- "$neg_sensitivity_file" | cut -f 1 -d '.')

        last_two_chars="${filename: -6:2}"

        # Define output file path for the combined image
        output_file="$home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_${last_two_chars}_neg_conjunction.nii.gz"


        # Combine the PosSpecificity file with the corresponding sensitivity file using fslmaths
        fslmaths "$neg_sensitivity_file" -add $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/${analysis_name}_neg_specificity_abs_bin.nii.gz -thr 1.9 "$output_file"

    fi
done

# copy the sensitivity files to the Final Results Folder to put everything in one place
cp $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_pos_sensitivity_map_masked_nonan.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/FinalResults
cp $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_neg_sensitivity_map_masked_nonan.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/FinalResults

# copy the specificity tmap to the Final Results folder
cp $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_Specificity_Tmap_masked_nonan.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/FinalResults

# copy individual lesion networks and traces into Final Results folder
mkdir $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/Traces_IndividualNetworks
cp $home_folder/LNM_Home_${analysis_name}/Output/${analysis_name}_LesionTracing*/${analysis_name}_LesionTracing*_nonan_t_map.nii.gz $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/Traces_IndividualNetworks
cp ${lesion_folder}/*.nii $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/Traces_IndividualNetworks

# compress tracings
gzip -f $home_folder/LNM_Home_${analysis_name}/Output/FinalResults/Traces_IndividualNetworks/*.nii


