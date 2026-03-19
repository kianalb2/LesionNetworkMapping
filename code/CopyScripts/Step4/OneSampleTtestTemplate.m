%Lesion Based Functional Connectivity Script 
%One sample t-test of average images
%Elijah C. Baughan
%Brigham Young University

%add pathway to Lead-DBS and helper functions
addpath('/grphome/fslg_lnm/nobackup/archive/apps/lead/helpers')
addpath('/grphome/fslg_lnm/nobackup/archive/apps/lead')

%add pathway to spm functions
addpath('/grphome/fslg_lnm/nobackup/archive/apps/spm12')

%not sure why I added this pathway to script 
%try and uncomment if script doesnt work
%add pathway to script
%addpath('TTESTSCRIPTPATHWAYHERE')

%establish initial variables
lesion_name = 'INSERTLESIONNAMEHERE'

output_dir = 'INSERTHOME_FOLDER/Output/INSERTLESIONNAMEHERE'

template_fullpathway = 'INSERTTEMPLATEIMAGEPATHWAYHERE'

matlab_output = 'INSERTHOME_FOLDER/cache/matlab_done/Step4'

merged_image_path = [output_dir,'/',lesion_name,'_merged_z_map','.nii.gz']

t_map_output_file = [output_dir,'/',lesion_name,'t_map','.nii']

p_map_output_file = [output_dir,'/',lesion_name,'p_map','.nii']

%run analysis

%not sure why i change directory each time as well
%cd output_dir

merged_image = ea_load_nii(merged_image_path);

%read in nifti image that will be utilized as a template to place
%t values in

loaded_template_image_t = ea_load_nii(template_fullpathway)
loaded_template_image_p = ea_load_nii(template_fullpathway)


%perform ttest on each voxel across participant

        for x=1:91
            for y=1:109
                for z=1:91
                    [h,p,ci,stats] = ttest(merged_image.img(x,y,z,:));
                    loaded_template_image_t.img(x,y,z) = stats.tstat;
                    loaded_template_image_p.img(x,y,z) = p;
                end
            end
        end

%establish the name of your t map
loaded_template_image_t.fname = t_map_output_file

%save t map image
ea_write_nii(loaded_template_image_t)

%establish the name of your t map
loaded_template_image_p.fname = p_map_output_file

%save p map image
ea_write_nii(loaded_template_image_p)


% Create a unique "done" file name based on a timestamp
timestamp = datestr(now, 'yyyymmdd_HHMMSSFFF'); % Generate a unique timestamp
done_file = sprintf('%s/OneSampleTTest_done_%s.txt', matlab_output, timestamp); % Include the directory in the file path

% Write to the "done" file
fid = fopen(done_file, 'wt');
fprintf(fid, 'done');
fclose(fid);
