function img=rf_slicer(img)
    VO=spm_vol(img);
    img=spm_read_vols(VO);
    
    %repair order
    nslice=size(img,3);
    %order=reshape(reshape(1:nslice,nslice/2,2)',1,[])
    order=reshape([11:20;1:10],1,[]);
    img=img(:,:,order);
    
    %repair dimensions
    mat=spm_imatrix(VO.mat);
    mat(9)=10;
    VO.mat=spm_matrix(mat);
    
    %save new
    [pth, bnm, ext] = spm_fileparts(VO.fname);
    VO.fname = fullfile(pth,['o',bnm,ext]);
    spm_write_vol(VO,img);
    img=spm_vol(VO.fname);
end