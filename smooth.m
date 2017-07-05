function img=smooth(img,kernel,preserve)

    matlabbatch{1}.spm.spatial.smooth.data = cellstr(img);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [kernel kernel kernel];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = preserve;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';

    spm_jobman('initcfg')
    spm_jobman('run', matlabbatch);
    [pathstr,name,ext] = fileparts(img);
    img=spm_vol(fullfile(pathstr,['s',name,ext]));
end