function cell_filenames = cell_rdir(rootdir,varargin)
    %input: rdir.m compatible
    %output: nx1 cells with full filenames
    %compatibility: 3D NIFTI & spm12
    
    output_rdir=rdir(rootdir,varargin);
    cell_output_rdir=struct2cell(output_rdir);
    cell_filenames = cell_output_rdir(1,:)';
end

