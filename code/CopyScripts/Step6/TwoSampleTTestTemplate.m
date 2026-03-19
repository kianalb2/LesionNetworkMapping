%Two Sample T Test
%Elijah C. Baughan
%Brigham Young University


%add pathway to Lead-DBS and helper functions
addpath('/grphome/fslg_lnm/nobackup/archive/apps/lead/helpers')
addpath('/grphome/fslg_lnm/nobackup/archive/apps/lead')

%add pathway to spm functions
addpath('/grphome/fslg_lnm/nobackup/archive/apps/spm12')

        %read in nifti images being analyzed

NETWORK1='NETWORK1HERE'
NETWORK2='/grphome/fslg_lnm/nobackup/archive/analysis_updated/ISLES/ISLES_LesionNetworks_Merged_NoNan.nii'

        network1 = ea_load_nii(NETWORK1);

        network2 = ea_load_nii(NETWORK2);

        %read in nifti image that will be utilized as a template to place
        %results in

        template_t = ea_load_nii('/grphome/fslg_lnm/nobackup/archive/analysis_updated/Template/template_images0000.nii');

        template_h = ea_load_nii('/grphome/fslg_lnm/nobackup/archive/analysis_updated/Template/template_images0000.nii');

        template_p = ea_load_nii('/grphome/fslg_lnm/nobackup/archive/analysis_updated/Template/template_images0000.nii');

      
            %run two sample t test on the 
            %
            %

               for x=1:91
                    for y=1:109
                        for z=1:91

                             voxel_for_network1 = network1.img(x,y,z,:);

                             voxel_for_network2 = network2.img(x,y,z,:);

                             [h,p,ci,stats] = ttest2(voxel_for_network1,voxel_for_network2,"Vartype","unequal");

                             %if the stat.tstat does not exist then just
                             %put 0 into the voxel

                             if isnan(stats.tstat)
                                 template_t.img(x,y,z) = 0;
                             else
                                 template_t.img(x,y,z) = stats.tstat;
                             end

                         


                             

    

                             template_h.img(x,y,z) = h;

                             template_p.img(x,y,z) = p;

                        end
                    end
               end

        t_map_path = 'TMAPOUTPUT';

        %establish the name of your output image 
        template_t.fname = t_map_path;

        %save output image
        ea_write_nii(template_t);

        h_map_path = 'HMAPOUTPUT';

        %establish the name of your output image 
        template_h.fname = h_map_path;

        %save output image
        ea_write_nii(template_h);

        p_map_path = 'PMAPOUTPUT';

        %establish the name of your image 
        template_p.fname = p_map_path;

        %save image
        ea_write_nii(template_p)
 
matlab_output = 'INSERTMATLAB'


% create a done file 
done_file = sprintf('%s/step6_complete.txt', matlab_output); % Include the directory in the file path

% Write to the "done" file
fid = fopen(done_file, 'wt');
fprintf(fid, 'done');
fclose(fid);
 
