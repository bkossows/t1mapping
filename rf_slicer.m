function img=rf_slicer(img)
    VO=spm_vol(img);
    img=spm_read_vols(VO);
    
    nslice=size(img,3);
    %order=reshape(reshape(1:nslice,nslice/2,2)',1,[])
    order=[11:20;1:10];
    img=img(:,:,order);
    
    %save new
    [pth, bnm, ext] = spm_fileparts(VO.fname);
    VO.fname = fullfile(pth,['o',bnm,ext]);
    spm_write_vol(VO,img);
    img=spm_vol(VO.fname);
end