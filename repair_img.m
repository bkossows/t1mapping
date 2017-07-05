function img=repair_img(img)
    VO=spm_vol(img);
    img=spm_read_vols(VO);

    %find and repair outliers
    m=mean(img(:));
    s=std(img(:));
    img(img<m-s | img>m+s)=NaN;
    img=fillgaps(img);

    %save new
    [pth, bnm, ext] = spm_fileparts(VO.fname);
    VO.fname = fullfile(pth,['f',bnm,ext]);
    spm_write_vol(VO,img);
    img=spm_vol(VO.fname);
end