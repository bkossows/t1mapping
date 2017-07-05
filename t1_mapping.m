%%%% vfa t1-mappping with b1 correction
%dependencies: spm, coregister, cell_rdir, t1_calc, fillgaps...



%%%%%%%%%%%
%%%%INPUTS
%%%%%%%%%%%%

clear all; close all;

inputs=cell_rdir('**/gre_4*/gre*1.nii');
gre18=cell(size(inputs));
rfmap=cell(size(inputs));
for i=1:size(inputs,1)
    subj=fileparts(fileparts(inputs{i}));
    gre18(i)=cell_rdir([subj,'/gre_18*/gre*1.nii']);
    rfmap(i)=cell_rdir([subj,'/rf_map*/rfmaps*2.nii']);
end
inputs(:,2)=gre18';
inputs(:,3)=rfmap';


%%%%%%%%%%%%%
%%%MAIN LOOP
%%%%%%%%%%%%%

for i=1:size(inputs,1)
    curimgs=inputs(i,:);
    imgs=spm_vol(char(strcat(curimgs,',1')));
    
    %%%%%%%%%%%%%
    %%%PREPROC
    %%%%%%%%%%%%%

    %coregister estimate and reslice 2nd FLASH
    imgs(2)=coregister(imgs(1).fname,imgs(2).fname,'');
    
    %repair outliers in rfmap
    raw_rf=spm_vol([imgs(3).fname(1:end-5),'1.nii']);
    raw_rf_img=spm_read_vols(raw_rf);
    dval=sort(raw_rf_img(:));
    thresh=0.1*mean(dval(end-10:end));
    mask_rf=raw_rf_img>thresh;
    imgs(3)=repair_img(imgs(3).fname,mask_rf);
    
    
    %coregister est&reslice RF-Map
    imgs(3)=coregister(imgs(1).fname,raw_rf.fname,imgs(3).fname,1); %ref src oth interp
    % smooth rf map
    imgs(3)=smooth(imgs(3).fname,12,1);

    %%%%%%%%%%%%%
    %%%MAPPING
    %%%%%%%%%%%%%
    
    %read preprocessed files
    img1=spm_read_vols(imgs(1));
    img2=spm_read_vols(imgs(2));
    b1_img=spm_read_vols(imgs(3));

%     mask=(mat2gray(img1)>(graythresh(img1)*0.1));
%     se = strel('disk',10);
%     closeBW = imclose(mask,se);
%     img1(~mask)=NaN;
%     img2(~mask)=NaN;

    %t1map=t1_wrapper(img1(:,:,80),img2(:,:,80)); %%% fitting routine (v. slow)
    %t1map=t1_poly(img1(:,:,:),img2(:,:,:));    %%% polyval (moderate slow)
    [t1map,pdmap]=t1_calc(img1(:,:,:),img2(:,:,:));
    
    %%%%%%%%%%%%%
    %%%POSTPROC
    %%%%%%%%%%%%%

    %%%% b1 correction
    b1_img(b1_img==0)=NaN;
    b1_deg=zeros(size(b1_img));
    b1_deg(b1_img>2048)=(b1_img(b1_img>2048)-2048)*180/2048;
    b1_r=b1_deg/90;
    t1map_c=t1map./(b1_r.^2);
    pdmap_c=pdmap./b1_r;

    %%%% spoiling correction (?) -> Preibisch 2009
    A=275*b1_r.^2-359*b1_r+142; %[ms]
    B=-0.33*b1_r.^2+0.25*b1_r+0.92;
    t1map_c2=A+B.*t1map_c;

    subplot(1,2,1); imshow(squeeze(pdmap(:,200,:)),[3000 6000]); title('Proton density');
    subplot(1,2,2); imshow(squeeze(t1map_c2(:,200,:)),[300 3000]); title('T1 map');
    %subplot(1,3,3); imshowpair(img1(:,:,80),mask(:,:,80)); title('mask');

    %%%%%%%%%%%%%
    %%%WRITING
    %%%%%%%%%%%%%
    
    VO = imgs(1); % copy info from gre_1
    [pth, bnm, ext] = spm_fileparts(VO.fname);
    VO.fname = fullfile(pth, ['pdmap' ext]);
    spm_write_vol(VO,pdmap_c);
    VO.fname = fullfile(pth, ['b1map' ext]);
    spm_write_vol(VO,b1_deg);
    VO.fname = fullfile(pth, ['t1map' ext]);
    spm_write_vol(VO,t1map_c2);
    if(exist('mask','var'))
        VO.fname = fullfile(pth, ['mask' ext]);
        spm_write_vol(VO,mask);
    end

end
