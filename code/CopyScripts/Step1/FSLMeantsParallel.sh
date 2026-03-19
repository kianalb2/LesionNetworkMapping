#!/bin/bash

#create average lesion time series

    for scan in `ls $data`; do
        fslmeants -i ${data}/${scan} -m ${lesion_folder}/${1} -o ${home_folder}/LNM_Home_${analysis_name}/Output/${1}/Average_Time_Series/${scan}_${1}.txt
    done


