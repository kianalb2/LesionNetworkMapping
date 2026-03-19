%Lesion Based Functional Connectivity Script 
%Elijah C. Baughan
%Brigham Young University


%add pathway to Lead-DBS and helper functions
addpath('/grphome/fslg_lnm/nobackup/archive/apps/lead/helpers')
addpath('/grphome/fslg_lnm/nobackup/archive/apps/lead')

%add pathway to spm functions
addpath('/grphome/fslg_lnm/nobackup/archive/apps/spm12')

%add pathways to other folders 
addpath('/grphome/fslg_lnm/nobackup/archive/HumanConnectome/Only1000Sub')
addpath('/grphome/fslg_lnm/nobackup/archive/analysis_updated/Template')

%establish directory variables
scan_dir = 'INSERTDATAPATHWAYHERE';

lesion_timeseries_dir = 'INSERTLESIONTIMESERIESFOLDERHERE';

results_dir = 'INSERTHOME_FOLDER/Output/INSERTLESIONNAMEHERE';

lesion_name = 'INSERTLESIONNAMEHERE';

analysis_name = 'INSERTANALYSISNAMEHERE';

template_fullpathway = 'INSERTTEMPLATEIMAGEPATHWAYHERE';

matlab_output = 'INSERTHOME_FOLDER/cache/matlab_done/Step2'

list_file = readtable('INSERTLISTHERE');

GSP1000pathway = '/grphome/fslg_lnm/nobackup/archive/HumanConnectome/Only1000Sub'

for i=1: size(list_file,1)

    %must use {i} in curly brackets when reading files into commands
    
    scan_name = list_file.FileName{i};
    scan_fullpathway = fullfile(GSP1000pathway,list_file.FileName{i});

    lesion_timeseries_name = [scan_name,'_',lesion_name,'.txt'];
    lesion_timeseries_fullpathway = [results_dir,'/','Average_Time_Series/',lesion_timeseries_name];

    %set up output variables
    r_map_name = [scan_name,'_','r_map.nii'];
    
    z_map_name = [scan_name,'_','z_map.nii'];

    r_map_fullpathway = [results_dir,'/','R_map/',r_map_name];
    
    z_map_fullpathway = [results_dir,'/','Z_map/',z_map_name];


        %read in nifti image being analyzed

        loadedimage = ea_load_nii(scan_fullpathway);

        %read in nifti image that will be utilized as a template to place
        %correlation coefficants in

        loaded_template_image = ea_load_nii(template_fullpathway);

        %read in lesion average time series
        lesion_average = readmatrix(lesion_timeseries_fullpathway);


            %correlate the lesion average with each voxels time series in the
            %loadedimage and replace each corresponding voxel in the template image
            %with the r value

               for x=1:91
                    for y=1:109
                        for z=1:91

                             Ind_voxel_time_series = loadedimage.img(x,y,z,:);

                             Reshaped_ind_voxel_time_series = reshape(Ind_voxel_time_series,[120,1]);

                             r_value = corr2(lesion_average, Reshaped_ind_voxel_time_series);

                             loaded_template_image.img(x,y,z) = r_value;

                        end
                    end
               end


        %establish the name of your lesion based functional connectivity output image 
        loaded_template_image.fname = r_map_fullpathway;

        %save lesion based functional connectivity output image
        %ea_write_nii(loaded_template_image);

        %standardize correlation coefficiants into z scores
        loaded_template_image.img = atan(loaded_template_image.img);

        %establish the name of your standardized z score image 
        loaded_template_image.fname = z_map_fullpathway;

        %save standardized z score image
        ea_write_nii(loaded_template_image);
 



end

% Create a "done" file with a unique name based on a timestamp
timestamp = datestr(now, 'yyyymmdd_HHMMSSFFF'); % Generate a unique timestamp
done_file = sprintf('FuncConn_done_%s.txt', timestamp); % Use only timestamp in sprintf
full_done_file = fullfile(matlab_output, done_file); % Combine matlab_output and done_file
fid = fopen(full_done_file, 'wt'); % Open the file for writing in text mode
fprintf(fid, 'done');
fclose(fid);

