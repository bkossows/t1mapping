function src=coregister(ref,src,oth,interp)
    if nargin
        interp=4;
    end
    clear matlabbatch;
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = cellstr(ref);
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = cellstr(src);
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = cellstr(oth);
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = interp;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

    spm_jobman('initcfg')
    spm_jobman('run', matlabbatch);
    
    if isempty(oth)
        [pathstr,name,ext] = fileparts(src);
    else
        [pathstr,name,ext] = fileparts(oth);
    end
    src=spm_vol(fullfile(pathstr,['r',name,ext]));
end